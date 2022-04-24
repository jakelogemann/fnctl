#!/usr/bin/env bash
set -euo pipefail
INPUT_EXTRA_NIX_CONFIG="${INPUT_EXTRA_NIX_CONFIG:-}"

if type -p nix &>/dev/null ; then
  echo "Aborting: Nix is already installed at $(type -p nix)" >&2 && exit $LINENO
fi

# Create a temporary workdir
workdir=$(mktemp -d); trap 'rc=$?; set -x; rm -vrf "$workdir" && exit $rc' EXIT
add_config() { echo "$1" | tee -a "$workdir/nix.conf" >/dev/null; }

if [[ $INPUT_EXTRA_NIX_CONFIG != "" ]]; then add_config "$INPUT_EXTRA_NIX_CONFIG"; fi
# If not specified, add a few useful defaults.
if [[ ! $INPUT_EXTRA_NIX_CONFIG =~ "keep-going" ]];  then add_config "keep-going = true"; fi
if [[ ! $INPUT_EXTRA_NIX_CONFIG =~ "max-jobs" ]];    then add_config "max-jobs = auto"; fi
if [[ ! $INPUT_EXTRA_NIX_CONFIG =~ "warn-dirty" ]];  then add_config "warn-dirty = false"; fi
if [[ ! $INPUT_EXTRA_NIX_CONFIG =~ "tarball-ttl" ]]; then add_config "tarball-ttl = 0"; fi
if [[ ! $INPUT_EXTRA_NIX_CONFIG =~ "trusted-users" ]];  then add_config "trusted-users = root $USER"; fi
if [[ ! $INPUT_EXTRA_NIX_CONFIG =~ "experimental-features" ]]; then add_config "experimental-features = nix-command flakes"; fi

# Nix installer flags
installer_options=(
  --no-channel-add
  --darwin-use-unencrypted-nix-store-volume
  --nix-extra-conf-file "$workdir/nix.conf"
)

# only use the nix-daemon settings if on darwin (which get ignored) or systemd is supported
if [[ $OSTYPE =~ darwin || -e /run/systemd/system ]]; then
  installer_options+=(
    --daemon
    --daemon-user-count "$(python -c 'import multiprocessing as mp; print(mp.cpu_count() * 2)')"
  )
else
  # "fix" the following error when running nix*
  # error: the group 'nixbld' specified in 'build-users-group' does not exist
  add_config "build-users-group ="
  sudo mkdir -p /etc/nix
  sudo chmod 0755 /etc/nix
  sudo cp $workdir/nix.conf /etc/nix/nix.conf
fi

if [[ $INPUT_INSTALL_OPTIONS != "" ]]; then
  IFS=' ' read -r -a extra_installer_options <<< "$INPUT_INSTALL_OPTIONS"
  installer_options=("${extra_installer_options[@]}" "${installer_options[@]}")
fi

echo "installer options: ${installer_options[*]}"

# There is --retry-on-errors, but only newer curl versions support that
curl_retries=5
while ! curl -sS -o "$workdir/install" -v --fail -L "${INPUT_INSTALL_URL:-https://nixos.org/nix/install}"
do
  sleep 1
  ((curl_retries--))
  if [[ $curl_retries -le 0 ]]; then
    echo "curl retries failed" >&2
    exit 1
  fi
done

sh "$workdir/install" "${installer_options[@]}"

if [[ $OSTYPE =~ darwin ]]; then
  # macOS needs certificates hints
  cert_file=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt
  echo "NIX_SSL_CERT_FILE=$cert_file" >> "$GITHUB_ENV" && export NIX_SSL_CERT_FILE=$cert_file
  sudo launchctl setenv NIX_SSL_CERT_FILE "$cert_file"
fi

# Set paths
echo "/nix/var/nix/profiles/default/bin" >> "$GITHUB_PATH"
echo "/nix/var/nix/profiles/per-user/$USER/profile/bin" >> "$GITHUB_PATH"

if [[ $INPUT_NIX_PATH != "" ]]; then echo "NIX_PATH=${INPUT_NIX_PATH}" >> "$GITHUB_ENV"; fi

# Output GITHUB_STEP_SUMMARY  
cat <<-EOF >>"${GITHUB_STEP_SUMMARY:-/dev/null}"

# ${GITHUB_REPOSITORY:-oops} 

- **Triggered by**: ${GITHUB_EVENT_NAME:-nothing} from ${GITHUB_ACTOR:-nobody}
- **Ref Name**: ${GITHUB_REF_NAME:-missing}
- **SHA**: ${GITHUB_SHA:-missing}
- **Expiration**: ~${GITHUB_RETENTION_DAYS:-0}days
- **Invocation ID**: ~${INVOCATION_ID:-missing}

<details><summary><code>nix.conf</code></summary><pre>
$(cat $workdir/nix.conf | nl)
</pre></details>

<details><summary>Environment Variables</summary><pre>
$(env | sort | nl)
</pre></details>

<details><summary>Event Payload</summary><pre>
$(jq -Ser '.' "${GITHUB_EVENT_PATH}")
</pre></details>

EOF

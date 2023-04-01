#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/kubevela/kubevela"
TOOL_NAME="kubevela"
TOOL_TEST="vela version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

get_arch() {
  local arch=""

  case "$(uname -m)" in
  x86_64 | amd64) arch='amd64' ;;
  aarch64 | arm64) arch="arm64" ;;
  *)
    fail "Arch '$(uname -m)' not supported!"
    ;;
  esac

  echo -n $arch
}

get_platform() {
  local platform=""

  case "$(uname | tr '[:upper:]' '[:lower:]')" in
  darwin) platform="darwin" ;;
  linux) platform="linux" ;;
  windows) platform="windows" ;;
  *)
    fail "Platform '$(uname -m)' not supported!"
    ;;
  esac

  echo -n $platform
}

get_ext() {
  local platform="$1"
  ext="tar.gz"

  if [ "$platform" == "windows" ]; then
    ext="zip"
  fi

  echo -n $ext
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -oE 'refs/tags/v[0-9]+.[0-9]+.[0-9]+(-.*)?' |
    cut -d/ -f3- |
    sed 's/^v//'
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version="$1"
  local release_file="$2"
  local download_path="$3"

  url="$GH_REPO/releases/download/v${version}/$release_file"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$download_path" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="${3%/bin}/bin"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error occurred while installing $TOOL_NAME $version."
  )
}

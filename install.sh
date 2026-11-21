#!/usr/bin/env bash
# StageRig OS: set a fresh Ubuntu 26.04 LTS Desktop up as a rig for playing live.
#
#   wget -qO- https://dguedry.github.io/stagerig-os/install.sh | sudo bash
#
# Options (after "sudo bash -s --" when piped, or ./install.sh ...):
#   --keep-desktop-apps   leave office, mail and games installed
#   --no-drivers          do not look for a graphics driver to install
#   --no-surge            do not fetch Surge XT from its own site
#   --deb FILE            install this stagerig-os .deb instead of the published one
#
# It adds two package sources (StageRig, StageRig OS), installs the stagerig-os
# package, and that package does the rest. Safe to run again.

set -euo pipefail

KEEP_APPS=0; DRIVERS=1; SURGE=1; LOCAL_DEB=""
while [ $# -gt 0 ]; do
    case "$1" in
        --keep-desktop-apps) KEEP_APPS=1 ;;
        --no-drivers)        DRIVERS=0 ;;
        --no-surge)          SURGE=0 ;;
        --deb)               LOCAL_DEB="$(readlink -f "${2:?--deb needs a file}")"; shift ;;
        -h|--help)           sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *)                   echo "Unknown option: $1" >&2; exit 2 ;;
    esac
    shift
done

WARNINGS=()
step() { printf '\n== %s\n' "$*"; }
note() { printf '   %s\n' "$*"; }
warn() { printf '   WARNING: %s\n' "$*"; WARNINGS+=("$*"); }
fetch() {   # fetch URL FILE
    if command -v wget >/dev/null; then wget -q -O "$2" "$1"
    else curl -fsSL -o "$2" "$1"; fi
}

[ "$(id -u)" -eq 0 ] || { echo "Run it with sudo." >&2; exit 1; }
. /etc/os-release
[ "${ID:-}" = ubuntu ] || { echo "This is $PRETTY_NAME; StageRig OS is made for Ubuntu." >&2; exit 1; }
[ "${VERSION_ID:-}" = 26.04 ] || warn "made for and checked against Ubuntu 26.04; this is $VERSION_ID"
export DEBIAN_FRONTEND=noninteractive
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT

# ---------------------------------------------------------------------------
step "Package sources"
install -d /etc/apt/keyrings
add_source() {   # add_source NAME BASE-URL
    if fetch "$2/key.gpg" "$tmp/$1.gpg" && [ -s "$tmp/$1.gpg" ]; then
        install -m 644 "$tmp/$1.gpg" "/etc/apt/keyrings/$1.gpg"
        echo "deb [signed-by=/etc/apt/keyrings/$1.gpg] $2/apt stable main" > "/etc/apt/sources.list.d/$1.list"
        note "$2/apt"
    else
        return 1
    fi
}
add_source stagerig https://dguedry.github.io/stagerig \
    || { echo "Could not reach StageRig's package source. Is the computer online?" >&2; exit 1; }
if [ -z "$LOCAL_DEB" ]; then
    add_source stagerig-os https://dguedry.github.io/stagerig-os \
        || { echo "Could not reach StageRig OS's package source." >&2; exit 1; }
fi
apt-get update -q

# ---------------------------------------------------------------------------
step "StageRig OS, StageRig, plugins and soundfonts"
apt-get install -y "${LOCAL_DEB:-stagerig-os}"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo \
    || warn "could not add Flathub (VST Environment adds it for each user at first login)"

if [ "$SURGE" -eq 1 ]; then
    step "Surge XT"
    # Not in Ubuntu 26.04's archive; its makers publish a .deb with each release.
    if dpkg-query -W -f='${Status}' surge-xt 2>/dev/null | grep -q 'ok installed'; then
        note "already installed"
    else
        url=""
        fetch https://api.github.com/repos/surge-synthesizer/releases-xt/releases/latest "$tmp/surge.json" \
            && url=$(grep -o 'https://[^"]*linux-x64[^"]*\.deb' "$tmp/surge.json" | head -n 1) || true
        if [ -n "$url" ] && fetch "$url" "$tmp/surge-xt.deb" && apt-get install -y "$tmp/surge-xt.deb"; then
            note "installed from $url"
        else
            warn "Surge XT did not install; get it from https://surge-synthesizer.github.io"
        fi
    fi
fi

# ---------------------------------------------------------------------------
if [ "$KEEP_APPS" -eq 0 ]; then
    step "Removing desktop software a rig does not need"
    patterns='libreoffice* thunderbird* rhythmbox* shotwell* transmission-* remmina*
              aisleriot gnome-mahjongg gnome-mines gnome-sudoku cheese simple-scan'
    # shellcheck disable=SC2086
    mapfile -t gone < <(dpkg-query -W -f='${db:Status-Abbrev} ${Package}\n' $patterns 2>/dev/null \
                        | awk '$1 ~ /^i/ {print $2}')
    if [ "${#gone[@]}" -gt 0 ]; then
        apt-get purge -y "${gone[@]}"
        apt-get autoremove --purge -y
    else
        note "none of it is installed"
    fi
    if command -v snap >/dev/null && snap list thunderbird >/dev/null 2>&1; then
        snap remove --purge thunderbird || warn "could not remove the thunderbird snap"
    fi
fi

# ---------------------------------------------------------------------------
if [ "$DRIVERS" -eq 1 ]; then
    step "Graphics driver"
    if lspci 2>/dev/null | grep -qi 'vga.*nvidia\|3d.*nvidia'; then
        if dpkg-query -W -f='${Package}\n' 'nvidia-driver-*' 2>/dev/null | grep -q .; then
            note "NVIDIA driver already installed"
        elif command -v ubuntu-drivers >/dev/null; then
            ubuntu-drivers install || warn "ubuntu-drivers could not install the NVIDIA driver"
        else
            warn "NVIDIA card found but ubuntu-drivers is missing (Software & Updates > Additional Drivers)"
        fi
    else
        note "no NVIDIA card: the kernel's own driver is used"
    fi
fi

# ---------------------------------------------------------------------------
step "Done"
if [ "${#WARNINGS[@]}" -gt 0 ]; then
    echo "   ${#WARNINGS[@]} warning(s):"
    printf '     - %s\n' "${WARNINGS[@]}"
fi
echo "   Restart the computer. VST Environment installs itself the first time you log in."
echo "   Then run: stagerig-os-check"

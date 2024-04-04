#!/bin/bash

set -e

# cant run this script as root
if [ "$EUID" -eq 0 ]; then
    echo "Please run this script as a normal user, not root."
    exit 1
fi

PRODUCT=$(cat /sys/devices/virtual/dmi/id/product_name)
VENDOR=$(cat /sys/devices/virtual/dmi/id/sys_vendor)

HOMEBREW_FOLDER="${HOME}/homebrew"
THEME_FOLDER="${HOMEBREW_FOLDER}/themes"

function set_default() {
    PROFILE=$1
    # replace `: "Xbox" to` `: "$1"
    if [[ -f "${THEME_FOLDER}/handheld-controller-glyphs/config_USER.json" ]]; then
        sed -i "s#: \"Xbox\"#: \"$PROFILE\"#g" "${THEME_FOLDER}/handheld-controller-glyphs/config_USER.json"
    fi
}

url="https://github.com/victor-borges/handheld-controller-glyphs.git"

if [[ -d "${THEME_FOLDER}/handheld-controller-glyphs" ]]; then
    rm -rf "${THEME_FOLDER}/handheld-controller-glyphs"
fi

git clone "${url}" --depth=1 "${THEME_FOLDER}/handheld-controller-glyphs"

PRODUCT_MATCH=false
if [[ "$PRODUCT" =~ "ROG Ally RC71L" ]]; then
    set_default "ROG Ally"
    PRODUCT_MATCH=true
elif [[ "$PRODUCT" == "G1617-01" ]]; then
    set_default "GPD Win Mini"
    PRODUCT_MATCH=true
elif [[ "$PRODUCT" == "G1618-04" ]]; then
    set_default "GPD Win4"
    PRODUCT_MATCH=true
elif [[ "$PRODUCT" == "83E1" ]]; then
    set_default "Legion Go"
    PRODUCT_MATCH=true
fi

if [[ "$PRODUCT_MATCH" == true ]]; then
    exit 0
fi

if [[ "$VENDOR" == "AYANEO" ]]; then
    set_default "AYANEO"
elif [[ "$VENDOR" == "GPD" ]]; then
    set_default "GPD"
elif [[ "$VENDOR" == "AOKZOE" || "$VENDOR" == "ONE-NETBOOK" ]]; then
    set_default "Aokzoe/OneXPlayer"
fi

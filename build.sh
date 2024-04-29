#!/usr/bin/env bash

set -e

CMAKE_OSX_ARCHITECTURES="arm64e;arm64"

ipaFile="$(find ./packages/*com.burbn.instagram*.ipa -type f -exec basename {} \;)"

if [ -z "${ipaFile}" ]; then
    echo -e '\033[1m\033[0;31m./packages/com.burbn.instagram.ipa not found.\nPlease put a decrypted Instagram IPA in its path.\033[0m'
    exit 1
elif [ -z "$(ls -A modules/libflex/FLEX)" ]; then
    echo -e '\033[1m\033[0;31mFLEX submodule not found.\nPlease run the following command to checkout submodules:\n\n\033[0m    git submodule update --init --recursive'
    exit 1
fi

echo -e '\033[1m\033[32mBuilding SCInsta tweak for sideloading (as IPA)\033[0m'

# Clean build artifacts
make clean
rm -rf .theos

# Check if building with dev mode
if [ "$1" == "--dev" ];
then
    FLEXPATH='packages/libbhFLEX.dylib'

    make "DEV=1"
else
    FLEXPATH='.theos/obj/debug/libbhFLEX.dylib'

    make
fi

# IPA File
echo -e '\033[1m\033[32mBuilding the IPA.\033[0m'
rm -f packages/SCInsta-sideloaded.ipa
pyzule -i "packages/${ipaFile}" -o packages/SCInsta-sideloaded.ipa -f .theos/obj/debug/SCInsta.dylib $FLEXPATH -c 0 -m 15.0 -du
echo -e "\033[1m\033[32mDone, we hope you enjoy SCInsta!\033[0m\n\nYou can find the ipa file at: $(pwd)/packages"

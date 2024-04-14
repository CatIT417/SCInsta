#!/usr/bin/env bash

CMAKE_OSX_ARCHITECTURES="arm64e;arm64"

ipaFile="$(find ./packages/*com.burbn.instagram*.ipa -type f -exec basename {} \;)"

if [ -z "${ipaFile}" ]; then
  echo -e '\033[1m\033[0;31m./packages/com.burbn.instagram.ipa not found.\nPlease put a decrypted Instagram IPA in its path.\033[0m'
  exit 1
elif [ -z "$(ls -A modules/libflex/FLEX)" ]; then
  echo -e '\033[1m\033[0;31mFLEX submodule not found.\nPlease run the following command to checkout submodules:\n\n\033[0m    git submodule update --init --recursive'
  exit 1
fi

echo -e '\033[1m\033[32mBuilding BHInsta tweak for sideloading (as IPA)\033[0m'

make clean
rm -rf .theos
make

# IPA File
echo -e '\033[1m\033[32mBuilding the IPA.\033[0m'
pyzule -i "packages/${ipaFile}" -o packages/BHInsta-sideloaded -uwsgf .theos/obj/debug/BHInsta.dylib .theos/obj/debug/libbhFLEX.dylib -m 15.0
echo -e "\033[1m\033[32mDone, we hope you enjoy BHInsta!\033[0m\n\nYou can find the ipa file at: $(pwd)/packages"

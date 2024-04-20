#!/usr/bin/env bash

echo 'Note: This script is meant to be used while developing the tweak.'
echo '      This does not build "libbhFLEX", it must be done manually and moved to ./packages'
echo

./build.sh --dev

# Install to device
cp -fr ./packages/SCInsta-sideloaded.ipa ~/Documents/Signing/SCInsta/ipas/UNSIGNED.ipa
cd ~/Documents/Signing
./sign.sh SCInsta
./deploy.sh SCInsta #true
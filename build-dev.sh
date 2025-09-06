#!/usr/bin/env bash

set -e

echo 'Note: This script is meant to be used while developing the tweak.'
echo '      This does not build "libflex" or "FLEXing", they must be built manually and moved to ./packages'
echo

if [ "$1" == "true" ];
then
    # Package & deploy app to device
    ./build.sh sideload --dev

    # Install to device
    cp -fr ./packages/SCInsta-sideloaded.ipa ~/Documents/Signing/SCInsta/ipas/UNSIGNED.ipa
    cd ~/Documents/Signing
    ./sign.sh SCInsta
    ./deploy.sh SCInsta true
else
    # Kill LiveContainer process on iPhone
    pymobiledevice3 developer dvt pkill "LiveContainer" --tunnel ""

    # Built tweak and deploy to live container
    make clean
    make DEV=1

    # Change framework locations to @rpath
    install_name_tool -change "/Library/Frameworks/Cephei.framework/Cephei" "@rpath/Cephei.framework/Cephei" ".theos/obj/debug/SCInsta.dylib" 2>/dev/null || true
    install_name_tool -change "/Library/Frameworks/CepheiPrefs.framework/CepheiPrefs" "@rpath/CepheiPrefs.framework/CepheiPrefs" ".theos/obj/debug/SCInsta.dylib" 2>/dev/null || true
    install_name_tool -change "/Library/Frameworks/CepheiUI.framework/CepheiUI" "@rpath/CepheiUI.framework/CepheiUI" ".theos/obj/debug/SCInsta.dylib" 2>/dev/null || true
    install_name_tool -change "/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate" "@rpath/CydiaSubstrate.framework/CydiaSubstrate" ".theos/obj/debug/SCInsta.dylib" 2>/dev/null || true

    # Copy to livecontainer tweaks folder
    cp -fr .theos/obj/debug/SCInsta.dylib livecontainer/Documents/Tweaks/SCInsta/SCInsta.dylib

    # Launch SCInsta on iPhone
    sleep 1
    pymobiledevice3 developer dvt launch --kill-existing --tunnel "" com.socuul.scinsta-devlauncher
fi
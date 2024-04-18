# BHInsta
A feature-rich tweak for Instagram on iOS!\
`Version v0.3.1-dev` | `Tested on Instagram v327.1.0`

# Features
### General
- Copy description
- Hide reels tab
- Do not save recent searches
- Hide explore posts grid
- Hide trending searches
- No suggested chats (in dms)

### Feed
- Hide ads
- Hide stories tray
- No suggested posts
- No suggested for you (accounts)
- No suggested reels
- No suggested threads posts

### Confirm actions
- Confirm like: Posts
- Confirm like: Reels
- Confirm follow
- Confirm call
- Confirm voice messages
- Confirm sticker interaction
- Confirm posting comment

### Save media (partially broken)
- Download images/videos
- Save profile image

### Story and messages
- Keep deleted message
- Unlimited replay of direct stories
- Disabling sending read receipts
- Remove screenshot alert
- Disable story seen receipt

### Security
- Padlock (biometric requirement to access app)

### Built-in Tweak Settings
> Long press on the Instagram settings button to bring up the BHInsta tweak settings

# Building
## Prerequisites
- XCode + Command-Line Developer Tools
- [Homebrew](https://brew.sh/#install)
- [CMake](https://formulae.brew.sh/formula/cmake#default) (brew install cmake)
- [Theos](https://theos.dev/docs/installation)
- [pyzule](https://github.com/asdfzxcvbn/pyzule?tab=readme-ov-file#installation)

## Setup
1. Install iOS 14.5 frameworks for theos
   1. [Click to download iOS SDKs](https://github.com/xybp888/iOS-SDKs/archive/refs/heads/master.zip)
   2. Unzip, then copy the `iPhoneOS14.5.sdk` folder into `~/theos/sdks`
2. Clone BHInsta repo from GitHub: `git clone --recurse-submodules https://github.com/SoCuul/BHInsta --branch v0.3.0`
3. [Download decrypted Instagram IPA](https://armconverter.com/decryptedappstore/us/instagram), and place it inside the `packages` folder with the name `com.burbn.instagram.ipa`

## Build IPA
```sh
$ chmod +x build.sh
$ ./build.sh
```

## Install IPA
You can install the tweaked IPA file like any other sideloaded iOS app. If you have not done this before, here are some suggestions to get started.

- [AltStore](https://altstore.io/#Downloads) (Free, No notifications*) *Notifications require $99/year Apple Developer Program
- [Sideloadly](https://sideloadly.io/#download) (Free, No notifications*) *Notifications require $99/year Apple Developer Program
- [Signulous](https://www.signulous.com/register) ($19.99/year, Receives notifications)
- [UDID Registrations](https://www.udidregistrations.com/buy) ($9.99/year, Receives notifications)

# In-App Screenshots
![BHInsta Settings](https://i.imgur.com/55ervgv.jpg)

# Contributing
Contributions to this tweak are greatly appreciated. Feel free to create a pull request if you would like to contribute.
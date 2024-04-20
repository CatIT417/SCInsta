TARGET := iphone:clang:14.5
INSTALL_TARGET_PROCESSES = Instagram
ARCHS = arm64e;arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SCInsta

SCInsta_FILES = $(shell find src -type f \( -iname \*.x -o -iname \*.xm -o -iname \*.m \)) $(wildcard modules/JGProgressHUD/*.m)
SCInsta_FRAMEWORKS = UIKit Foundation CoreGraphics Photos CoreServices SystemConfiguration SafariServices Security QuartzCore
SCInsta_PRIVATE_FRAMEWORKS = Preferences
SCInsta_EXTRA_FRAMEWORKS = Cephei CepheiPrefs CepheiUI
SCInsta_CFLAGS = -fobjc-arc -Wno-unsupported-availability-guard -Wno-unused-value -Wno-deprecated-declarations -Wno-nullability-completeness -Wno-unused-function -Wno-incompatible-pointer-types

include $(THEOS_MAKE_PATH)/tweak.mk

ifndef DEV
SCInsta_SUBPROJECTS += modules/libflex
endif
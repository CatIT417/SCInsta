TARGET := iphone:clang:14.5
INSTALL_TARGET_PROCESSES = Instagram
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = sideloadfix

sideloadfix_FILES = SideloadFix.x
sideloadfix_FRAMEWORKS = Foundation
sideloadfix_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
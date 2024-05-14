TARGET := iphone:clang:14.5
INSTALL_TARGET_PROCESSES = Instagram
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = sideloadfix

$(TWEAK_NAME)_FILES = SideloadFix.x
$(TWEAK_NAME)_FRAMEWORKS = Foundation
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
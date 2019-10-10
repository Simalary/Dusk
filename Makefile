INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Dusk

Dusk_FILES = DuskMessages.x  DuskPhone.x UIColor+Extensions.m
Dusk_CFLAGS = -fobjc-arc

ARCHS = arm64 arm64e

include $(THEOS_MAKE_PATH)/tweak.mk

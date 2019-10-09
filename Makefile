INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DuskMessages

DuskMessages_FILES = DuskMessages.x  UIColor+Extensions.m
DuskMessages_CFLAGS = -fobjc-arc

ARCHS = arm64 arm64e

include $(THEOS_MAKE_PATH)/tweak.mk

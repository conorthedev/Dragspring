TARGET = iphone:clang:13.0:11.0
INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Dragspring

Dragspring_FILES = Tweak.x
Dragspring_CFLAGS = -fobjc-arc

SUBPROJECTS += Preferences

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

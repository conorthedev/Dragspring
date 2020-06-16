TARGET = iphone:clang:13.0:11.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = DragspringPrefs

DragspringPrefs_FILES = DSSettingsController.m $(wildcard SkittyPrefs/*.m)
DragspringPrefs_FRAMEWORKS = UIKit
DragspringPrefs_LIBRARIES = appearancecell
DragspringPrefs_PRIVATE_FRAMEWORKS = Preferences
DragspringPrefs_INSTALL_PATH = /Library/PreferenceBundles
DragspringPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

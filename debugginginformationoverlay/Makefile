include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = DebuggingInformationOverlay
DebuggingInformationOverlay_FILES = SSTRootListController.m
DebuggingInformationOverlay_INSTALL_PATH = /Library/PreferenceBundles
DebuggingInformationOverlay_FRAMEWORKS = UIKit
DebuggingInformationOverlay_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/DebuggingInformationOverlay.plist$(ECHO_END)

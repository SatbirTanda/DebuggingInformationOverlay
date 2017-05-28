export ARCHS = armv7 armv7s arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DebuggingInformationOverlay
DebuggingInformationOverlay_FILES = Tweak.xm
DebuggingInformationOverlay_FRAMEWORKS = UIKit
DebuggingInformationOverlay_LIBRARIES = applist
DebuggingInformationOverlay_CFLAGS = "-Wno-error"

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += debugginginformationoverlay
include $(THEOS_MAKE_PATH)/aggregate.mk

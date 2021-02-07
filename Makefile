include $(THEOS)/makefiles/common.mk
ARCHS = arm64 arm64e

BUNDLE_NAME = EmeraldStock
EmeraldStock_BUNDLE_NAME = com.laughingquoll.Emerald.StockPill
EmeraldStock_BUNDLE_EXTENSION = bundle
EmeraldStock_CFLAGS =  -fobjc-arc
EmeraldStock_FILES = $(wildcard *.m)
EmeraldStock_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore CoreTelephony
EmeraldStock_EXTRA_FRAMEWORKS = EmeraldFramework
EmeraldStock_INSTALL_PATH = /Library/Emerald/Bundles/
EmeraldStock_LDFLAGS += -F../../.theos/$(THEOS_OBJ_DIR_NAME)

include $(THEOS_MAKE_PATH)/bundle.mk
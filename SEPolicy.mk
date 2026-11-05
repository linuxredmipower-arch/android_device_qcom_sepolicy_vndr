# Board specific SELinux policy variable definitions
SEPOLICY_PATH:= device/qcom/sepolicy_vndr-aospa
QSSI_SEPOLICY_PATH:= device/qcom/sepolicy
BOARD_SYSTEM_EXT_SEPOLICY_PREBUILT_DIRS := device/qcom/sepolicy/generic
BOARD_PRODUCT_SEPOLICY_PREBUILT_DIRS := device/qcom/sepolicy/generic/product
# PixelOS-CLO 的 QSSI sepolicy 没有 generic/public/attribute；按存在性加入
ifneq ($(wildcard $(QSSI_SEPOLICY_PATH)/generic/public/attribute),)
SYS_ATTR_PROJECT_PATH := $(TOP)/$(QSSI_SEPOLICY_PATH)/generic/public/attribute
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS:= \
    $(SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS) \
    $(QSSI_SEPOLICY_PATH)/generic/public \
    $(QSSI_SEPOLICY_PATH)/generic/public/attribute
else
SYS_ATTR_PROJECT_PATH :=
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS:= \
    $(SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS) \
    $(QSSI_SEPOLICY_PATH)/generic/public
endif

SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS:= \
    $(SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS) \
    $(QSSI_SEPOLICY_PATH)/generic/private

#once all the services are moved to Product /ODM above lines will be removed.
# sepolicy rules for product images
PRODUCT_PUBLIC_SEPOLICY_DIRS := \
    $(PRODUCT_PUBLIC_SEPOLICY_DIRS) \
    $(QSSI_SEPOLICY_PATH)/generic/product/public

PRODUCT_PRIVATE_SEPOLICY_DIRS := \
    $(PRODUCT_PRIVATE_SEPOLICY_DIRS) \
    $(QSSI_SEPOLICY_PATH)/generic/product/private

ifeq (,$(filter sdm845 sdm710, $(TARGET_BOARD_PLATFORM)))
    BOARD_VENDOR_SEPOLICY_DIRS := \
       $(BOARD_VENDOR_SEPOLICY_DIRS) \
       $(SEPOLICY_PATH) \
       $(SEPOLICY_PATH)/generic/vendor/common \
       $(SEPOLICY_PATH)/generic/vendor/common/attribute \
       $(SEPOLICY_PATH)/qva/vendor/common

    ifeq ($(TARGET_SEPOLICY_DIR),)
      BOARD_VENDOR_SEPOLICY_DIRS += $(SEPOLICY_PATH)/generic/vendor/$(TARGET_BOARD_PLATFORM)
      BOARD_VENDOR_SEPOLICY_DIRS += $(SEPOLICY_PATH)/qva/vendor/$(TARGET_BOARD_PLATFORM)
    else
      BOARD_VENDOR_SEPOLICY_DIRS += $(SEPOLICY_PATH)/generic/vendor/$(TARGET_SEPOLICY_DIR)
      BOARD_VENDOR_SEPOLICY_DIRS += $(SEPOLICY_PATH)/qva/vendor/$(TARGET_SEPOLICY_DIR)
    endif

    ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
    BOARD_VENDOR_SEPOLICY_DIRS += $(SEPOLICY_PATH)/generic/vendor/test
    BOARD_VENDOR_SEPOLICY_DIRS += $(SEPOLICY_PATH)/qva/vendor/test
    BOARD_VENDOR_SEPOLICY_DIRS += $(SEPOLICY_PATH)/qva/vendor/test/sysmonapp
    endif
endif


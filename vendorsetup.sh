#!/bin/bash


echo start cloning repos and bringups
# common dt
git clone https://github.com/Ten-X-Devices/device_oplus_mt6893-common device/oplus/mt6893-common --depth=1 && rm device/oplus/mt6893-common/vendorsetup.sh
# proprietary_vendor
git clone https://github.com/Ten-X-Devices/vendor_oplus_mt6893-common --depth=1 vendor/oplus/mt6893-common
# hardware mediatek
rm -rf hardware/mediatek && git clone https://github.com/oplus-ossi-development/android_hardware_mediatek hardware/mediatek
# oneplus parts
git clone https://github.com/oplus-ossi-development/android_packages_apps_OneplusParts packages/apps/OneplusParts --depth=1
# kernel dt
git clone --depth=1 --recurse-submodules https://github.com/Ten-X-Devices/kernel_oplus_mt6893 kernel/oplus/mt6893
# hardware mediatek wlan
git clone https://github.com/oplus-ossi-development/android_hardware_mediatek_wlan hardware/mediatek/wlan --depth=1
# vendor oplus cupida
git clone https://github.com/Ten-X-Devices/vendor_oplus_cupida vendor/oplus/cupida --depth=1
# sepolicy vndr
git clone https://github.com/oplus-ossi-development/android_device_mediatek_sepolicy_vndr device/mediatek/sepolicy_vndr --depth=1
# oplus hardware
rm -rf hardware/oplus && git clone https://github.com/LineageOS/android_hardware_oplus hardware/oplus --depth=1

# Oplus camera
CAM=device/oplus/camera/camera.mk
if ! [ -a $CAM ]; then
    git clone https://gitlab.com/nattolecats/android_device_oplus_camera device/oplus/camera --depth=1
fi

cd device/oplus/camera/ && git lfs pull && cd ../../../

# Clang
CLANG17=prebuilts/clang/host/linux-x86/clang-r487747/bin/clang
if ! [ -a $CLANG17 ]; then
    git clone https://gitlab.com/nattolecats/android_prebuilts_clang_host_linux-x86_clang-r487747 prebuilts/clang/host/linux-x86/clang-r487747 --depth=1
fi

# Bypass API modified validations
export DISABLE_STUB_VALIDATION=true

# Move it right directory
mv device/oneplus/denniz device/oplus/denniz &> /dev/null
mv device/oplus/RMX3031 device/oplus/cupida &> /dev/null

#apply patch
bash device/oplus/mt6893-common/patches/apply.sh

#end cloning
echo bringup successful

#delete setup
rm device/oplus/cupida/vendorsetup.sh

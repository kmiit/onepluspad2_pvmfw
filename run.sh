#!/bin/bash

# git clone --depth 1 https://android.googlesource.com/platform/system/tools/mkbootimg
git submodule update --depth=1

# unpack images from oneplus 13 rom
mkdir op13
payload_dumper --partitions pvmfw,vbmeta,vbmeta_system,vbmeta_vendor --out op13 $OP13_ROM_URL

# unpack images from oneplus pad pro rom
mkdir opad
payload_dumper --partitions system,system_ext,product,vbmeta,vbmeta_system,vbmeta_vendor,vendor_boot --out opad $OPAD_ROM_URL

# resign vbmeta_system of oneplus pad pro with pvmfw
bash remake.sh vbmeta_system_mod.img opad/vbmeta_system.img

# mod vendor_boot image of oneplus pad pro
mkbootimg_args=`python3 mkbootimg/unpack_bootimg.py --boot_img opad/vendor_boot.img --out unpack --format mkbootimg`
sed -i 's/androidboot.hypervisor.protected_vm.supported=0/androidboot.hypervisor.protected_vm.supported=true/g' unpack/bootconfig
repack_args='python3 mkbootimg/mkbootimg.py --vendor_boot vendor_boot_mod.img '$mkbootimg_args
echo $repack_args
eval $repack_args

# resign modified vendor_boot
bash resign.sh vendor_boot_mod.img opad/vendor_boot.img

# prepare output
mkdir out
mv op13/pvmfw.img out/
mv vbmeta_system_mod.img out/
mv vendor_boot_mod.img out/
mv opad/vbmeta_system.img out/
mv opad/vendor_boot.img out/


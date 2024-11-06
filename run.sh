#!/bin/bash
sudo apt update -y
sudo apt remove -y firefox
sudo apt install aria2 -y

aria2c -x16 -j$(nproc) -U "Mozilla/5.0" $OP13_ROM_URL -o "op13.zip"
aria2c -x16 -j$(nproc) -U "Mozilla/5.0" $OPAD_ROM_URL -o "opad.zip"

git clone --depth 1 https://android.googlesource.com/platform/system/tools/mkbootimg
echo "Init repository done"

echo "Start dumping Oneplus 13 fw files"
# unpack images from oneplus 13 rom

mkdir op13
op13_partitions=("pvmfw" "vbmeta" "vbmeta_system" "vbmeta_vendor")
for partition in "${op13_partitions[@]}"; do
python -m payload_dumper --partitions ${partition} --out op13 "op13.zip"
echo "${partition} dump finished."
done
echo "Dump Oneplus 13 fw done."
rm op13.zip

# unpack images from oneplus pad pro rom
echo "Start dumping Oneplus Pad Pro fw files"
mkdir opad

opad_partitions=("system" "system_ext" "product" "vbmeta" "vbmeta_system" "vbmeta_vendor" "vendor_boot")
for partition in "${opad_partitions[@]}"; do
python -m payload_dumper --partitions ${partition} --out opad "opad.zip"
echo "${partition} dump finished."
done
echo "Dump Oneplus Pad Pro fw done."
rm opad.zip

echo "Resign vbmeta"
# resign vbmeta_system of oneplus pad pro with pvmfw
bash remake.sh vbmeta_system_mod.img opad/vbmeta_system.img
echo "Done."

echo "Mod vendor_boot"
# mod vendor_boot image of oneplus pad pro
mkbootimg_args=`python3 mkbootimg/unpack_bootimg.py --boot_img opad/vendor_boot.img --out unpack --format mkbootimg`
sed -i 's/androidboot.hypervisor.protected_vm.supported=0/androidboot.hypervisor.protected_vm.supported=true/g' unpack/bootconfig
repack_args='python3 mkbootimg/mkbootimg.py --vendor_boot vendor_boot_mod.img '$mkbootimg_args
echo $repack_args
eval $repack_args
echo "Donw."

echo "Resign vendor_boot"
# resign modified vendor_boot
bash resign.sh vendor_boot_mod.img opad/vendor_boot.img
echo "Done."

# prepare output
mkdir out
mv op13/pvmfw.img out/
mv vbmeta_system_mod.img out/
mv vendor_boot_mod.img out/
mv opad/vbmeta_system.img out/
mv opad/vendor_boot.img out/


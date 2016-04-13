	eval ${UBOOT_TOOLCHAIN:+env PATH=$UBOOT_TOOLCHAIN:$PATH} ${CROSS_COMPILE}gcc --version | head -1 | tee -a $DEST/debug/install.log
	echo
	local cthreads=$CTHREADS
	[[ $LINUXFAMILY == "marvell" ]] && local MAKEPARA="u-boot.mmc"
	[[ $BOARD == "odroidc2" ]] && local MAKEPARA="ARCH=arm" && local cthreads=""

	eval ${UBOOT_TOOLCHAIN:+env PATH=$UBOOT_TOOLCHAIN:$PATH} 'make $CTHREADS $BOOTCONFIG CROSS_COMPILE="$CROSS_COMPILE"' 2>&1 \

	[ -f .config ] && sed -i 's/CONFIG_LOCALVERSION=""/CONFIG_LOCALVERSION="-armbian"/g' .config
	[ -f .config ] && sed -i 's/CONFIG_LOCALVERSION_AUTO=.*/# CONFIG_LOCALVERSION_AUTO is not set/g' .config
	[ -f $SOURCES/$BOOTSOURCEDIR/tools/logos/udoo.bmp ] && cp $SRC/lib/bin/armbian-u-boot.bmp $SOURCES/$BOOTSOURCEDIR/tools/logos/udoo.bmp
	touch .scmversion
	
	# patch mainline uboot configuration to boot with old kernels
	if [[ $BRANCH == "default" && $LINUXFAMILY == sun*i ]] ; then
		if [ "$(cat $SOURCES/$BOOTSOURCEDIR/.config | grep CONFIG_ARMV7_BOOT_SEC_DEFAULT=y)" == "" ]; then
			echo "CONFIG_ARMV7_BOOT_SEC_DEFAULT=y" >> $SOURCES/$BOOTSOURCEDIR/.config
			echo "CONFIG_OLD_SUNXI_KERNEL_COMPAT=y" >> $SOURCES/$BOOTSOURCEDIR/.config
		fi
	fi

	eval ${UBOOT_TOOLCHAIN:+env PATH=$UBOOT_TOOLCHAIN:$PATH} 'make $MAKEPARA $cthreads CROSS_COMPILE="$CROSS_COMPILE"' 2>&1 \
	local uboot_name=${CHOSEN_UBOOT}_${REVISION}_${ARCH}
if [[ \$DEVICE == "/dev/null" ]]; then exit 0; fi
	( dd if=/usr/lib/$uboot_name/bl1.bin.hardkernel of=\$DEVICE bs=1 count=442 conv=fsync ) > /dev/null 2>&1	
	( dd if=/usr/lib/$uboot_name/bl1.bin.hardkernel of=\$DEVICE bs=512 skip=1 seek=1 conv=fsync ) > /dev/null 2>&1	
	( dd if=/usr/lib/$uboot_name/bl1.bin.hardkernel of=\$DEVICE bs=1 count=442 conv=fsync ) > /dev/null 2>&1
	( dd if=/usr/lib/$uboot_name/bl1.bin.hardkernel of=\$DEVICE bs=512 skip=1 seek=1 conv=fsync ) > /dev/null 2>&1
	( dd if=/usr/lib/$uboot_name/u-boot.bin of=\$DEVICE bs=512 seek=97 conv=fsync ) > /dev/null 2>&1
	( dd if=/dev/zero of=\$DEVICE seek=1249 count=799 bs=512 conv=fsync ) > /dev/null 2>&1 
Architecture: $ARCH
	# NOTE: Fix CC=$CROSS_COMPILE"gcc" before reenabling
	# make $CTHREADS 'sunxi-nand-part' CC=$CROSS_COMPILE"gcc" >> $DEST/debug/install.log 2>&1
	# make $CTHREADS 'sunxi-fexc' CC=$CROSS_COMPILE"gcc" >> $DEST/debug/install.log 2>&1
	# make $CTHREADS 'meminfo' CC=$CROSS_COMPILE"gcc" >> $DEST/debug/install.log 2>&1
	eval ${KERNEL_TOOLCHAIN:+env PATH=$KERNEL_TOOLCHAIN:$PATH} ${CROSS_COMPILE}gcc --version | head -1 | tee -a $DEST/debug/install.log
	echo
	
	if [[ $ARCH == *64* ]]; then ARCHITECTURE=arm64; else ARCHITECTURE=arm; fi
			eval ${KERNEL_TOOLCHAIN:+env PATH=$KERNEL_TOOLCHAIN:$PATH} 'make $CTHREADS ARCH=$ARCHITECTURE CROSS_COMPILE="$CROSS_COMPILE" silentoldconfig'
			eval ${KERNEL_TOOLCHAIN:+env PATH=$KERNEL_TOOLCHAIN:$PATH} 'make $CTHREADS ARCH=$ARCHITECTURE CROSS_COMPILE="$CROSS_COMPILE" olddefconfig'
		eval ${KERNEL_TOOLCHAIN:+env PATH=$KERNEL_TOOLCHAIN:$PATH} 'make $CTHREADS ARCH=$ARCHITECTURE CROSS_COMPILE="$CROSS_COMPILE" oldconfig'
		eval ${KERNEL_TOOLCHAIN:+env PATH=$KERNEL_TOOLCHAIN:$PATH} 'make $CTHREADS ARCH=$ARCHITECTURE CROSS_COMPILE="$CROSS_COMPILE" menuconfig'
	eval ${KERNEL_TOOLCHAIN:+env PATH=$KERNEL_TOOLCHAIN:$PATH} 'make $CTHREADS ARCH=$ARCHITECTURE CROSS_COMPILE="$CROSS_COMPILE" $TARGETS modules dtbs 2>&1' \
	if [ ${PIPESTATUS[0]} -ne 0 ] || [ ! -f arch/$ARCHITECTURE/boot/$TARGETS ]; then
	# produce deb packages: image, headers, firmware, dtb
	eval ${KERNEL_TOOLCHAIN:+env PATH=$KERNEL_TOOLCHAIN:$PATH} 'make -j1 $KERNEL_PACKING KDEB_PKGVERSION=$REVISION LOCALVERSION="-"$LINUXFAMILY \
		KBUILD_DEBARCH=$ARCH ARCH=$ARCHITECTURE DEBFULLNAME="$MAINTAINER" DEBEMAIL="$MAINTAINERMAIL" CROSS_COMPILE="$CROSS_COMPILE" 2>&1 ' \
install_external_applications ()
{
display_alert "Installing extra applications and drivers" "" "info"
for plugin in $SRC/lib/extras/*.sh; do
	source $plugin
done
	make clean >/dev/null
	make ARCH=$ARCHITECTURE CC="${CROSS_COMPILE}gcc" KSRC="$SOURCES/$LINUXSOURCEDIR/" >> $DEST/debug/compilation.log 2>&1

	make ARCH=$ARCHITECTURE CC="${CROSS_COMPILE}gcc" KSRC="$SOURCES/$LINUXSOURCEDIR/" >> $DEST/debug/compilation.log 2>&1
# h3disp/sun8i-corekeeper.sh for sun8i/3.4.x
if [ "${LINUXFAMILY}" = "sun8i" -a "${BRANCH}" = "default" ]; then
	install -m 755 "$SRC/lib/scripts/sun8i-corekeeper.sh" "$CACHEDIR/sdcard/usr/local/bin"
	sed -i 's|^exit\ 0$|/usr/local/bin/sun8i-corekeeper.sh \&\n\n&|' "$CACHEDIR/sdcard/etc/rc.local"
	dpkg -x ${DEST}/debs/${CHOSEN_UBOOT}_${REVISION}_${ARCH}.deb /tmp/
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/SPL of=$LOOP bs=512 seek=2 status=noxfer >/dev/null 2>&1)
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/u-boot.img of=$LOOP bs=1K seek=42 status=noxfer >/dev/null 2>&1)
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/u-boot.mmc of=$LOOP bs=512 seek=1 status=noxfer >/dev/null 2>&1)
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/SPL of=$LOOP bs=1k seek=1 status=noxfer >/dev/null 2>&1)
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/u-boot.img of=$LOOP bs=1k seek=69 conv=fsync >/dev/null 2>&1)
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/bootloader.bin of=$LOOP bs=512 seek=4097 conv=fsync > /dev/null 2>&1)
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/u-boot-dtb.bin of=$LOOP bs=512 seek=6144 conv=fsync > /dev/null 2>&1)
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/bl1.bin.hardkernel of=$LOOP seek=1 conv=fsync ) > /dev/null 2>&1
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/bl2.bin.hardkernel of=$LOOP seek=31 conv=fsync ) > /dev/null 2>&1
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/u-boot.bin of=$LOOP bs=512 seek=63 conv=fsync ) > /dev/null 2>&1
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/tzsw.bin.hardkernel of=$LOOP seek=719 conv=fsync ) > /dev/null 2>&1
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/bl1.bin.hardkernel of=$LOOP bs=1 count=442 conv=fsync ) > /dev/null 2>&1	
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/bl1.bin.hardkernel of=$LOOP bs=512 skip=1 seek=1 conv=fsync ) > /dev/null 2>&1	
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/u-boot.bin of=$LOOP bs=512 seek=64 conv=fsync ) > /dev/null 2>&1	
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/bl1.bin.hardkernel of=$LOOP bs=1 count=442 conv=fsync ) > /dev/null 2>&1
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/bl1.bin.hardkernel of=$LOOP bs=512 skip=1 seek=1 conv=fsync ) > /dev/null 2>&1
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/u-boot.bin of=$LOOP bs=512 seek=97 conv=fsync ) > /dev/null 2>&1
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/u-boot-sunxi-with-spl.bin of=$LOOP bs=1024 seek=8 status=noxfer >/dev/null 2>&1)
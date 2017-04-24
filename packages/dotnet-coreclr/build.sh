TERMUX_PKG_HOMEPAGE=https://www.microsoft.com/net/core
TERMUX_PKG_DESCRIPTION=".NET Core is a development platform that you can use to build command-line applications, microservices and modern websites. It is open source, cross-platform and is supported by Microsoft."
local _COMMIT=e0b8c96334016770680d64fc83a8e7dbdeb657ee
TERMUX_PKG_VERSION="2.0.0.0"
TERMUX_PKG_SRCURL=https://github.com/dotnet/coreclr/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=c16e0006e27845326ae11d977fd8e4cddf5ec5e17902feb6ceed501590e09b1b
TERMUX_PKG_DEPENDS="libicu,libuuid,libandroid-glob,libandroid-support,liblzma"
TERMUX_PKG_FOLDERNAME="coreclr-${_COMMIT}"
TERMUX_PKG_BUILD_IN_SRC="yes"

# TODO: Git clone shallow both clr and fx

# See https://github.com/dotnet/coreclr/blob/master/Documentation/building/linux-instructions.md
# TODO: Enable O3 optimizations
termux_step_pre_configure() {
	export _ARCH=$TERMUX_ARCH
	case $_ARCH in
		arm) CFLAGS+=" -mcpu=cortex-a8";;
		aarch64) _ARCH=arm64;;
		x86_64) _ARCH=x64;;
	esac

	# TODO: This might be wrong; the toolchain is android, but we use the android llvm? This does not sound very right...
	PATH=$PATH:/usr/lib/llvm-3.8/bin
}

termux_step_configure () {
	termux_setup_cmake
}

termux_step_make() {
	# TODO: Instead use git clone
	# Required for version number and other build internal
	# git init
	# git commit -m "Termux Build" --allow-empty
	# git branch release/$TERMUX_PKG_VERSION 

	# Initialize RootFS
	# Use termux patched ndk (TODO: Create folders and inject r14)
	# ln -s /home/builder/lib/android-ndk /home/builder/.termux-build/dotnet-coreclr/src/cross/android-rootfs/android-ndk-r14
	# TODO: Instead of downloading, use the built dependencies
	# NDK_DIR=`realpath /home/builder/.termux-build/_lib/toolchain-aarch64-ndk14-api21-v17` ./cross/build-android-rootfs.sh 
	# See https://github.com/qmfrederik/coredroid
	# Skip tests, otherwise it will take forever
	CONFIG_DIR=`realpath cross/android/arm64` ROOTFS_DIR=`realpath $TERMUX_STANDALONE_TOOLCHAIN/sysroot` ./build.sh cross arm64 skipgenerateversion skipnuget skiptests cmakeargs -DENABLE_LLDBPLUGIN=0
	# CONFIG_DIR=`realpath cross/android/arm64` ROOTFS_DIR=`realpath /home/builder/.termux-build/dotnet-coreclr/src/cross/android-rootfs/toolchain/arm64/sysroot` ./build.sh cross arm64 skipgenerateversion skipnuget skiptests cmakeargs -DENABLE_LLDBPLUGIN=0
}

termux_step_make_install() {
	mkdir $TERMUX_PREFIX/share/dotnet
	cp $TERMUX_PKG_SRCDIR/bin/Product/Linux.$_ARCH.Release/corerun $TERMUX_PREFIX/share/dotnet/corerun
	cp $TERMUX_PKG_SRCDIR/bin/Product/Linux.$_ARCH.Release/libcoreclr.so $TERMUX_PREFIX/share/dotnet/libcoreclr.so
	cp $TERMUX_PKG_SRCDIR/bin/Product/Linux.$_ARCH.Release/mscorlib.dll $TERMUX_PREFIX/share/dotnet/mscorlib.dll
}

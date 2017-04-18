TERMUX_PKG_HOMEPAGE=https://www.microsoft.com/net/core
TERMUX_PKG_DESCRIPTION=".NET Core is a development platform that you can use to build command-line applications, microservices and modern websites. It is open source, cross-platform and is supported by Microsoft."
local _COMMIT=e0b8c96334016770680d64fc83a8e7dbdeb657ee
TERMUX_PKG_VERSION="2.0.0.0"
TERMUX_PKG_SRCURL=https://github.com/dotnet/coreclr/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=c16e0006e27845326ae11d977fd8e4cddf5ec5e17902feb6ceed501590e09b1b
TERMUX_PKG_DEPENDS="libicu"
TERMUX_PKG_FOLDERNAME="coreclr-${_COMMIT}"

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

}

termux_step_make() {
	# Requires to be run from the src path
	pushd $TERMUX_PKG_SRCDIR

	# TODO: Instead use git clone
	# Required for version number and other build internal
	# git init
	# git commit -m "Termux Build" --allow-empty
	# git branch release/$TERMUX_PKG_VERSION 

	# Initialize RootFS
	# Use termux patched ndk (TODO: Create folders and inject r14)
	ln -s /home/builder/lib/android-ndk /home/builder/.termux-build/dotnet-coreclr/src/cross/android-rootfs/android-ndk-r14
	./cross/build-android-rootfs.sh
	# See https://github.com/qmfrederik/coredroid
	# Skip tests, otherwise it will take forever
	CONFIG_DIR=`realpath cross/android/arm64` ROOTFS_DIR=`realpath /home/builder/.termux-build/dotnet-coreclr/src/cross/android-rootfs/toolchain/arm64/sysroot` ./build.sh cross arm64 skipgenerateversion skipnuget skiptests cmakeargs -DENABLE_LLDBPLUGIN=0


	# Might be unecessary. Returns the the working folder of Termux's build-package.sh
	popd
}

termux_step_make_install() {
	mkdir $TERMUX_PREFIX/share/dotnet
	cp $TERMUX_PKG_SRCDIR/bin/Product/Linux.$_ARCH.Release/corerun $TERMUX_PREFIX/share/dotnet/corerun
	cp $TERMUX_PKG_SRCDIR/bin/Product/Linux.$_ARCH.Release/libcoreclr.so $TERMUX_PREFIX/share/dotnet/libcoreclr.so
	cp $TERMUX_PKG_SRCDIR/bin/Product/Linux.$_ARCH.Release/mscorlib.dll $TERMUX_PREFIX/share/dotnet/mscorlib.dll
}

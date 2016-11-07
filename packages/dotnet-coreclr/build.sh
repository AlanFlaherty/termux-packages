TERMUX_PKG_HOMEPAGE=https://www.microsoft.com/net/core
TERMUX_PKG_DESCRIPTION=".NET Core is a development platform that you can use to build command-line applications, microservices and modern websites. It is open source, cross-platform and is supported by Microsoft."
TERMUX_PKG_VERSION="1.1.0"
TERMUX_PKG_SRCURL=https://github.com/dotnet/coreclr/archive/master.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=""
TERMUX_PKG_RM_AFTER_INSTALL=""
TERMUX_PKG_DEPENDS=""
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_FOLDERNAME="coreclr-master"
TERMUX_PKG_CLANG="yes"

# See https://github.com/dotnet/coreclr/blob/master/Documentation/building/linux-instructions.md
# TODO: Enable O3 optimizations
termux_step_pre_configure() {
	export _ARCH=$TERMUX_ARCH
	case $_ARCH in
		arm) CFLAGS+=" -mcpu=cortex-a8";;
		aarch64) _ARCH=arm64;;
		x86_64) _ARCH=x64;;
	esac

	export ROOTFS_DIR=$TERMUX_STANDALONE_TOOLCHAIN
}

termux_step_make() {
	# Requires to be run from the src path
	pushd $TERMUX_PKG_SRCDIR

	# Required for version number and other build internal
	git init
	git commit -m "Termux Build" --allow-empty
	git branch release/$TERMUX_PKG_VERSION 

	# Skip tests, otherwise it will take forever
	./build.sh $_ARCH skiptests

	# Might be unecessary. Returns the the working folder of Termux's build-package.sh
	popd
}

termux_step_make_install() {
	mkdir $TERMUX_PREFIX/share/dotnet
	cp $TERMUX_PKG_SRCDIR/bin/Product/Linux.$_ARCH.Release/corerun $TERMUX_PREFIX/share/dotnet/
	cp $TERMUX_PKG_SRCDIR/bin/Product/Linux.$_ARCH.Release/libcoreclr $TERMUX_PREFIX/share/dotnet/
	cp $TERMUX_PKG_SRCDIR/bin/Product/Linux.$_ARCH.Release/mscorlib.dll $TERMUX_PREFIX/share/dotnet/
}

TERMUX_PKG_HOMEPAGE=https://www.microsoft.com/net/core
TERMUX_PKG_DESCRIPTION=".NET Core is a development platform that you can use to build command-line applications, microservices and modern websites. It is open source, cross-platform and is supported by Microsoft."
TERMUX_PKG_VERSION="1.1.0"
TERMUX_PKG_SRCURL=https://github.com/dotnet/coreclr/archive/master.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=""
TERMUX_PKG_RM_AFTER_INSTALL=""
TERMUX_PKG_DEPENDS=""
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_FOLDERNAME="coreclr-master"

# See https://github.com/dotnet/coreclr/blob/master/Documentation/building/linux-instructions.md
# TODO: Enable O3 optimizations

termux_step_make() {
	# Requires to be run from the src path
	pushd $TERMUX_PKG_SRCDIR

	# Required for version number and other build internal
	git init
	git commit -m "Termux Build" --allow-empty
	git branch release/$TERMUX_PKG_VERSION 

	# Skip tests, otherwise it will take forever
	./build.sh aarch64 skiptests

	# Might be unecessary. Returns the the working folder of Termux's build-package.sh
	popd
}

termux_step_make_install() {
	# TODO: Copy output files
	cp $TERMUX_PKG_SRCDIR/bin/Product/Linux.aarch64.Release/corerun $TERMUX_PREFIX/bin/share/dotnet/
	cp $TERMUX_PKG_SRCDIR/bin/Product/Linux.aarch64.Release/libcoreclr $TERMUX_PREFIX/bin/share/dotnet/
	cp $TERMUX_PKG_SRCDIR/bin/Product/Linux.aarch64.Release/mscorlib.dll $TERMUX_PREFIX/bin/share/dotnet/
}

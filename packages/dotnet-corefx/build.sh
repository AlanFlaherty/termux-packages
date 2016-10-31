TERMUX_PKG_HOMEPAGE=https://www.microsoft.com/net/core
TERMUX_PKG_DESCRIPTION=".NET Core is a development platform that you can use to build command-line applications, microservices and modern websites. It is open source, cross-platform and is supported by Microsoft."
TERMUX_PKG_VERSION="1.1.0"
TERMUX_PKG_SRCURL=https://github.com/dotnet/cli/archive/master.tar.gz
# TODO: Get the dependencies for Termux, and port the missing ones
TERMUX_PKG_DEPENDS="dotnet-coreclr"
# TERMUX_PKG_DEPENDS="libcurl, libgcc1, libgssapi-krb5-2, libicu55, liblldb-3.6, liblttng-ust0, libssl1.0.0, libstdc++6, libstdc++6, libunwind8, libuuid1, zlib1g"
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_FOLDERNAME="corefx-master"

# See https://github.com/dotnet/corefx/blob/master/Documentation/building/cross-building.md

termux_step_make() {
	# Requires to be ran from the src path
	pushd $TERMUX_PKG_SRCDIR

	# Required for version number and other build internal
	git init
	git commit -m "Termux Build" --allow-empty
	git branch release/$TERMUX_PKG_VERSION 

	# Skip tests, otherwise it will take forever
	./build.sh -builldArch=arm64 cross

	# Might be unecessary. Returns the the working folder of Termux's build-package.sh
	popd
}

termux_step_make_install() {
	# TODO: Check what other files should be copied
	cp $TERMUX_PKG_SRCDIR/bin/Linux.AnyCPU.Release/* $TERMUX_PREFIX/share/dotnet/
	cp $TERMUX_PKG_SRCDIR/bin/Linux.arm.Debug/Native/* $TERMUX_PREFIX/share/dotnet/
}

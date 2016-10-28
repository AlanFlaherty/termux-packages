MUX_PKG_HOMEPAGE=https://www.microsoft.com/net/core
TERMUX_PKG_DESCRIPTION=".NET Core is a development platform that you can use to build command-line applications, microservices and modern websites. It is open source, cross-platform and is supported by Microsoft."
TERMUX_PKG_VERSION="1.0.0-preview2.0.1"
TERMUX_PKG_SRCURL=https://github.com/dotnet/cli/archive/rel/1.0.0.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=""
TERMUX_PKG_RM_AFTER_INSTALL=""
TERMUX_PKG_DEPENDS="libc6, libcurl3, libgcc1, libgssapi-krb5-2, libicu55, liblldb-3.6, liblttng-ust0, libssl1.0.0, libstdc++6, libstdc++6, libunwind8, libuuid1, zlib1g"
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_FOLDERNAME="cli-rel-1.0.0"

	# Might be unecessary. See: https://docs.microsoft.com/en-us/dotnet/articles/core/rid-catalog#linux-rids
DOTNET_RUNTIME_ID="ubuntu.16.04-x64"

termux_step_make() {
	# Requires to be run from the src path
	pushd $TERMUX_PKG_SRCDIR

	# Required for version number and other build internal (see PrepareTargets.cs, other build stages also require this)
	git init
	git commit -m "Termux Build" --allow-empty
	git branch rel/$TERMUX_PKG_VERSION 

	# Skip tests, otherwise it will take forever
	./build.sh /t:Compile

	# Might be unecessary. Returns the the working folder of Termux's build-package.sh
	popd
}

termux_step_make_install() {
	cp $TERMUX_PKG_SRCDIR/artifacts/$DOTNET_RUNTIME_ID/stage2/dotnet $TERMUX_PREFIX/bin/dotnet
}

termux_step_pre_configure() {
	# export TERMUX_ORIG_PATH=$PATH
	echo TODO: Add to PATH $TERMUX_PKG_HOSTBUILD_DIR
	# export PATH=$TERMUX_PKG_HOSTBUILD_DIR:$PATH
}

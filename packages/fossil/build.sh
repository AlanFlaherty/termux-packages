TERMUX_PKG_HOMEPAGE=https://www.fossil-scm.org
TERMUX_PKG_DESCRIPTION='DSCM with built-in wiki, http interface and server, tickets database'
TERMUX_PKG_MAINTAINER='Vishal Biswas @vishalbiswas'
TERMUX_PKG_VERSION=2.1
TERMUX_PKG_SRCURL=https://www.fossil-scm.org/index.html/uv/fossil-src-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=85dcdf10d0f1be41eef53839c6faaa73d2498a9a140a89327cfb092f23cfef05
TERMUX_PKG_FOLDERNAME=fossil-${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS='libsqlite, openssl'

termux_step_pre_configure () {
	# Avoid mixup of flags between cross compilation
	# and native build.
	CC="$CC $CFLAGS $LDFLAGS"
	unset CFLAGS LDFLAGS
}

termux_step_configure () {
	$TERMUX_PKG_SRCDIR/configure \
		--prefix=$TERMUX_PREFIX \
		--host=$TERMUX_HOST_PLATFORM \
		--json \
		--disable-internal-sqlite \
		--with-openssl=$TERMUX_PREFIX \
		--with-zlib=auto
}


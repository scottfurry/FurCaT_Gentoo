# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"

inherit autotools multilib wxwidgets

DESCRIPTION="C++ wrapper around the public domain SQLite 3.x database"
HOMEPAGE="http://utelle.github.io/wxsqlite3"
SRC_URI="https://github.com/utelle/${PN}/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="wxWinLL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	>=dev-db/sqlite-3.43.1
	doc? (
		app-doc/doxygen[dot]
	)"

DEPEND="${RDEPEND}"
DOCS=( readme.md )

pkg_setup() {
    setup-wxwidgets
}

src_prepare() {
    default
    eautoreconf
}

src_configure() {
	local myeconfargs=(
	        --prefix="${EPREFIX}/usr"
		--enable-shared
		--with-wx-config="${WX_CONFIG}"
	)
	default
}

src_compile() {
	default
	if use doc; then
		pushd docs
		doxygen Doxyfile || die
	popd
	fi
}

src_install() {
	default
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc

	if use doc; then
		docinto html
		dodoc -r docs/html/*
	fi
}

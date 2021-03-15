# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Taken from pg_overlay: https://data.gpo.zugaina.org/pg_overlay/media-sound/mac
EAPI=7

inherit autotools

DESCRIPTION="Monkey's Audio Codecs"
HOMEPAGE="https://www.monkeysaudio.com"
SRC_URI="http://monkeysaudio.com/files/MAC_SDK_${PV/.}.zip -> ${P}.zip"

LICENSE="mac"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND=""

src_unpack() {
	mkdir ${S}
	cd ${S}
	unpack ${A}
}

src_prepare() {
	default
	cp Source/Projects/NonWindows/Makefile .
}

src_compile() {
	emake prefix=${EPREFIX}/usr libdir=${EPREFIX}/usr/$(get_libdir)
}

src_install() {
    emake DESTDIR=${ED} prefix=${EPREFIX}/usr libdir=${EPREFIX}/usr/$(get_libdir) install
}

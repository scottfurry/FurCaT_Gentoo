# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper unpacker xdg
PN_NOBIN="${PN/-bin}"
MY_PN="${PN_NOBIN/evolus/}"
MY_PNC="${MY_PN/p/P}"
MY_PV="${PV}.ga"

DESCRIPTION="A simple GUI prototyping tool to create mockups"
HOMEPAGE="https://pencil.evolus.vn/"
SRC_URI="https://pencil.evolus.vn/dl/V${MY_PV}/${MY_PNC}_${MY_PV}_amd64.deb"

# bug 703602 - splitdebug - symbol clash
RESTRICT="splitdebug mirror strip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="
	app-accessibility/at-spi2-atk
	app-accessibility/at-spi2-core
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	media-gfx/graphite2
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/libepoxy
	media-libs/libpng
	net-print/cups
	sys-apps/dbus
	virtual/opengl
	sys-apps/util-linux
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/pango
"

S="${WORKDIR}/${P}/${MY_PN}-${MY_PV}"

QA_PREBUILT="
	opt/${MY_PN}/*.so
        opt/${MY_PN}/*.bin
        opt/${MY_PN}/*.pak
	opt/${MY_PN}/chrome-sandbox
	opt/${MY_PN}/${MY_PN}
"

src_unpack() {
        # deb archive does not use a containing folder
        # manual intervention required
        install -d "${S}"
        cd "${S}" || die "cd into target directory ${S} failed"
        unpack_deb "${A}"
}

src_prepare() {
	default
	# Using modified desktop file to ensure app name does not conflict
	# Desktop file also addresses https://github.com/evolus/pencil/issues/722 and 724
	# (Crash on app start - sandbox privilage conflict)
	rm -fR "${S}/usr/share/applications" || die
        # only contains changelog"
        rm -fR "${S}/usr/share/doc" || die
	# rename opt/Pencil folder
	mv "opt/${MY_PNC}" "opt/${MY_PN}"
}

src_install() {
	doins -r *
	make_wrapper "${PN_NOBIN}" "/opt/${MY_PN}/${MY_PN}" || die
        # use own desktop file
        domenu "${FILESDIR}/${PN_NOBIN}.desktop" || die

        # correct permissions of install components
        fperms 4755 "/opt/${MY_PN}/chrome-sandbox" || die
        fperms a+x "/opt/${MY_PN}/${MY_PN}" || die
}

pkg_postinst() {
        xdg_pkg_postinst
}

pkg_postrm() {
        xdg_pkg_postrm
}

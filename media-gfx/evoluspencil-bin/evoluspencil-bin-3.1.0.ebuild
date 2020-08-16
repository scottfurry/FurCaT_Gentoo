# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils unpacker xdg
PN_NOBIN="${PN/-bin}"
MY_PN="${PN_NOBIN/evolus/}"
MY_PV="${PV}.ga"
MY_INSTALL_DIR="/opt/${PN_NOBIN}"

DESCRIPTION="A simple GUI prototyping tool to create mockups"
HOMEPAGE="https://pencil.evolus.vn/"
SRC_URI="https://pencil.evolus.vn/dl/V${MY_PV}/${MY_PN}_${MY_PV}_amd64.deb"
# bug 703602 - splitdebug - symbol clash
RESTRICT="splitdebug mirror strip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nss
	media-gfx/graphite2
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/libepoxy
	media-libs/libpng
	net-print/cups
	sys-apps/dbus
	virtual/opengl
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libxcb
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/pango
"

S="${WORKDIR}/${P}/${MY_PN}-${MY_PV}"
MY_S="${S}/opt/${MY_PN}-${MY_PV}"

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
	rm "${MY_S}/${MY_PN}.desktop" || die
        # only contains changelog"
        rm -rf "${MY_S}/usr/share/doc" || die
}

src_install() {
	insinto opt/"${PN_NOBIN}"
	doins -r "${MY_S}"/*
	make_wrapper "${PN_NOBIN}" "${MY_INSTALL_DIR}/${MY_PN}" || die
        # use own desktop file
        domenu "${FILESDIR}/${PN_NOBIN}.desktop" || die

        # correct permissions of install components
        fperms 4755 "${MY_INSTALL_DIR}/chrome-sandbox" || die
        fperms a+x "${MY_INSTALL_DIR}/${MY_PN}" || die
        fperms a+x "${MY_INSTALL_DIR}/natives_blob.bin" || die

	# icon is 256px^2
	newicon -s 256 "${MY_S}/${MY_PN}.png" "${PN_NOBIN}.png"
}

pkg_postinst() {
        xdg_pkg_postinst
}

pkg_postrm() {
        xdg_pkg_postrm
}

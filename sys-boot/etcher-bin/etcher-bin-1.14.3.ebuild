# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

MY_PN="${PN//-bin}"
MY_INSTALL_DIR="/opt/balenaEtcher"
MY_EXEC="balena-${MY_PN}"

inherit desktop unpacker pax-utils xdg wrapper

DESCRIPTION="Flash OS images to SD cards & USB drives, safely and easily."
HOMEPAGE="https://etcher.io/"
SRC_URI="https://github.com/balena-io/${MY_PN}/releases/download/v${PV}/balena-${MY_PN}_${PV}_amd64.deb"

LICENSE="GPL2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="
	app-accessibility/at-spi2-atk:2
	app-accessibility/at-spi2-core:2
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libxshmfence
	x11-libs/pango
"
S="${WORKDIR}/${P}"

QA_PREBUILT="
	"${MY_INSTALL_DIR}"/chrome-sandbox
	"${MY_INSTALL_DIR}/${MY_EXEC}"
	"${MY_INSTALL_DIR}/${MY_EXEC}.bin"
	"${MY_INSTALL_DIR}"/libEGL.so
	"${MY_INSTALL_DIR}"/libffmpeg.so
	"${MY_INSTALL_DIR}"/libGLESv2.so
	"${MY_INSTALL_DIR}"/libvk_swiftshader.so
	"${MY_INSTALL_DIR}"/libvulkan.so*
	"${MY_INSTALL_DIR}"/swiftshader/libEGL.so
	"${MY_INSTALL_DIR}"/swiftshader/libGLESv2.so
"
RESTRICT="mirror strip test"

src_unpack() {
	# deb archive does not use a containing folder
	# manual intervention required
        install -d "${S}"
	cd "${S}" || die "cd into target directory ${S} failed"
	unpack_deb "${A}"
}

src_install() {
	# remove upstream provided desktop file
        rm usr/share/applications/${MY_EXEC}.desktop || die
	# only contains changelog"
	rm -rf usr/share/doc || die

	doins -r *
	# correct permissions of install components
	fperms 4711 "${MY_INSTALL_DIR}/chrome-sandbox" || die
	fperms a+x "${MY_INSTALL_DIR}/${MY_EXEC}" || die
	fperms a+x "${MY_INSTALL_DIR}/${MY_EXEC}.bin" || die

        make_wrapper "${MY_PN}" "${MY_INSTALL_DIR}/${MY_EXEC}" || die
	# use own desktop file
	domenu "${FILESDIR}/${MY_PN}.desktop" || die
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}

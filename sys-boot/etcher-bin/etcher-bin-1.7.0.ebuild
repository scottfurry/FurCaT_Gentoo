# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit desktop eutils unpacker pax-utils xdg

MY_PN="${PN/-bin}"
MY_INSTALL_DIR="/opt/balenaEtcher"
MY_EXEC="balena-${MY_PN}-electron"
DESCRIPTION="Flash OS images to SD cards & USB drives, safely and easily."
HOMEPAGE="https://etcher.io/"
SRC_URI="https://github.com/balena-io/${MY_PN}/releases/download/v${PV}/balena-${MY_PN}-electron_${PV}_amd64.deb"
RESTRICT="mirror strip"
LICENSE="GPL2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
	media-libs/libpng
        >=x11-libs/gtk+-3.0
        x11-libs/cairo
        x11-libs/libXtst
	sys-apps/lsb-release
"

RDEPEND="
	${DEPEND}
	x11-libs/libnotify
        x11-libs/libXScrnSaver
        dev-libs/nss
"

S="${WORKDIR}/${P}"

QA_PREBUILT="
	opt/${MY_PN}/*.so
	opt/${MY_PN}/*.bin
	opt/${MY_PN}/*.pak
        opt/${MY_PN}/chrome-sandbox
        opt/${MY_PN}/${MY_EXEC}
	opt/${MY_PN}/**/*.elf
"
RESTRICT="strip test"

src_unpack() {
	# deb archive does not use a containing folder
	# manual intervention required
        install -d "${S}"
	cd "${S}" || die "cd into target directory ${S} failed"
	unpack_deb "${A}"
}

src_prepare() {
        default
        rm usr/share/applications/${MY_EXEC}.desktop || die
	# only contains changelog"
	rm -rf usr/share/doc || die
}

src_install() {
	doins -r *
        make_wrapper "${MY_PN}" "${MY_INSTALL_DIR}/${MY_EXEC}" || die
	# use own desktop file
	domenu "${FILESDIR}/${MY_PN}.desktop" || die
	# correct permissions of install components
	fperms 4755 "${MY_INSTALL_DIR}/chrome-sandbox" || die
	fperms a+x "${MY_INSTALL_DIR}/${MY_EXEC}" || die
	fperms a+x "${MY_INSTALL_DIR}/${MY_EXEC}.bin" || die
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}

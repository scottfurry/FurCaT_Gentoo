# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# derived from https://data.gpo.zugaina.org/src_prepare-overlay/sys-boot/rpi-imager/rpi-imager-9999.ebuild

EAPI=8

inherit xdg cmake optfeature

DESCRIPTION="Raspberry Pi Imaging Utility"
HOMEPAGE="https://www.raspberrypi.com/software/"
SRC_URI="https://github.com/raspberrypi/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~aarch64"
LICENSE="Apache-2.0"
SLOT="0"

CMAKE_USE_DIR="${S}/src"
CMAKE_BUILD_TYPE="Release"

BDEPEND="
	dev-qt/linguist-tools
"
RDEPEND="
	app-arch/libarchive
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtquickcontrols2:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	net-misc/curl
	sys-fs/udisks:2
	|| (
		dev-libs/openssl
		net-libs/gnutls
	)
"
DEPEND="
	${RDEPEND}
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_CHECK_VERSION=OFF
		-DENABLE_TELEMETRY=OFF
	)

	cmake_src_configure
}

pkg_postinst() {
	optfeature "writing to disk as non-root user" sys-fs/udisks
}

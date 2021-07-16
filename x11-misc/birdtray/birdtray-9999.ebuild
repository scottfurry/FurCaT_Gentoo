# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="New mail system tray notification for Thunderbird."
HOMEPAGE="https://github.com/gyunaev/birdtray"
if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gyunaev/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/gyunaev/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL3+"
SLOT="0"
IUSE=""

RDEPEND="dev-db/sqlite:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libX11"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

CMAKE_BUILD_TYPE=Release

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	cmake_src_configure
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}

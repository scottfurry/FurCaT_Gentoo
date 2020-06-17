# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg eutils cmake

DESCRIPTION="SQLite Database Browser"
HOMEPAGE="http://sqlitebrowser.org"

if [[ ${PV} == 9999 ]] ; then
    EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}"
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	EGIT_SUBMODULES=()
	inherit git-r3
    KEYWORDS=""
    S="${WORKDIR}/${PN}"
else
    SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3 MPL-2.0"
SLOT="0"
IUSE="sqlcipher test"
RESTRICT="network-sandbox"

DEPEND="
	dev-db/sqlite:3
	sqlcipher? ( >=dev-db/sqlcipher-3.4.2 )
	dev-qt/qtcore:5
	dev-qt/linguist-tools:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	>=app-editors/qhexedit2-0.8.6
	>=x11-libs/qscintilla-2.11.1:=[qt5(+)]
	>=dev-libs/qcustomplot-2.0.1[qt5(+)]
	test? ( dev-qt/qttest:5 )
"

RDEPEND="${DEPEND}"

CMAKE_BUILD_TYPE=Release

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-Dsqlcipher=$(usex sqlcipher) \
		-DENABLE_TESTING=$(usex test) \
		-DFORCE_INTERNAL_QSCINTILLA=OFF \
		-DFORCE_INTERNAL_QCUSTOMPLOT=OFF \
		-DFORCE_INTERNAL_QHEXEDIT=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	newicon images/logo.png sqlitebrowser.png
	newicon images/logo.svg sqlitebrowser.svg
}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}

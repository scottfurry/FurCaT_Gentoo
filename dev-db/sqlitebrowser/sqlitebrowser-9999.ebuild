# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg

DESCRIPTION="A light GUI editor for SQLite databases"
HOMEPAGE="https://sqlitebrowser.org/"

if [[ "${PV}" = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+ MPL-2.0"
SLOT="0"
IUSE="sqlcipher test"
RESTRICT="network-sandbox"

DEPEND="
	app-editors/qhexedit2
	dev-db/sqlite:3
	sqlcipher? ( >=dev-db/sqlcipher-3.4.2 )
	dev-libs/qcustomplot
	>=dev-qt/qtconcurrent-5.5:5
	>=dev-qt/qtcore-5.5:5
	>=dev-qt/qtgui-5.5:5
	>=dev-qt/qtnetwork-5.5:5[ssl]
	>=dev-qt/qtprintsupport-5.5:5
	>=dev-qt/qtwidgets-5.5:5
	>=dev-qt/qtxml-5.5:5
	>=x11-libs/qscintilla-2.11.1:=[qt5(+)]
"

BDEPEND="
	>=dev-qt/linguist-tools-5.5:5
	test? ( >=dev-qt/qttest-5.5:5 )
"


RDEPEND="
	${DEPEND}
	>=dev-qt/qtsvg-5.5:5
"

CMAKE_BUILD_TYPE="Release"

src_prepare() {
	cmake_src_prepare

	if ! use test; then
		sed -i CMakeLists.txt \
			-e "/find_package/ s/ Test//" \
			-e "/set/ s/ Qt5::Test//" \
			|| die "Cannot remove Qt Test from CMake dependencies"
	fi
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

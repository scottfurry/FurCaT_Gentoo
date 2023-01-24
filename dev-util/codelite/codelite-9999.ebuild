# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# derived from:
# https://github.com/sveyret/sveyret-gentoo/blob/master/dev-util/codelite/codelite-15.0.0.ebuild
EAPI=8

WX_GTK_VER=3.2-gtk3

inherit cmake xdg wxwidgets git-r3

DESCRIPTION="A Free, open source, cross platform C, C++, PHP and Node.js IDE"
HOMEPAGE="http://codelite.org/"
EGIT_REPO_URI="https://github.com/eranif/${PN}"
EGIT_SUBMODULES=('*')
EGIT_OVERRIDE_REPO_ERANIF_CODELITE_ARCHIVE_REFS_TAGS="${PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/wxGTK:3.2-gtk3 net-libs/libssh dev-db/sqlite:3"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-util/cmake-3.16"

CMAKE_BUILD_TYPE="Release"

src_prepare() {
	setup-wxwidgets
	cmake_src_prepare
	eapply_user
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}

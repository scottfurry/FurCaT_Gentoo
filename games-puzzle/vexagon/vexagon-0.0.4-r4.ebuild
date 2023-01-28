# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
WX_GTK_VER="3.2-gtk3"
MY_P="${PN}-master"

inherit cmake xdg wxwidgets

DESCRIPTION="Complete the puzzle by matching numbered square or hexagonal tiles"
HOMEPAGE="https://vexagon.furcat.ca/"
SRC_URI="https://gitlab.com/digifuzzy/${PN}/-/archive/master/${MY_P}.tar.gz"

LICENSE="wxWinLL-3 GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="x11-libs/wxGTK:${WX_GTK_VER}"
RDEPEND="${DEPEND}"

src_unpack() {
    unpack ${A}
    mv "${WORKDIR}/${MY_P}" "${WORKDIR}/${P}"
}

src_prepare() {
    setup-wxwidgets
    cmake_src_prepare
}

src_configure() {
    local mycmakeargs=(
        -D_VEXREVISION_="v${PV} (Gentoo)"
    )
    cmake_src_configure
}

pkg_postinst() {
	xdg_postinst
}

pkg_postrm() {
	xdg_postrm
}

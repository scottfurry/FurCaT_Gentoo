# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake


DESCRIPTION="Monkey's Audio Codecs"
HOMEPAGE="https://www.monkeysaudio.com"
SRC_URI="http://monkeysaudio.com/files/MAC_${PV/.}_SDK.zip -> ${P}.zip"

LICENSE="mac"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND=""

# No test available, Making src_test fail
RESTRICT="test"

CMAKE_BUILD_TYPE=Release

src_unpack() {
	mkdir ${S}
	cd ${S}
	unpack ${A}
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	cmake_src_configure
}

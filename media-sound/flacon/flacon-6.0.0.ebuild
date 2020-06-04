# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Ignore rudimentary et, uz@Latn.
PLOCALES="cs cs_CZ de el es es_MX et fr gl he hu id it ja_JP lt ms_MY nb nl nl_BE pl pl_PL pt_BR pt_PT ro_RO ru sr sr@latin tr uk uz@Latn zh_CN zh_TW"
# Tests require lots of disk space
CHECKREQS_DISK_BUILD=10G

inherit check-reqs cmake eutils l10n virtualx xdg

DESCRIPTION="Extracts audio tracks from an audio CD image to separate tracks"
HOMEPAGE="https://flacon.github.io/"
SRC_URI="https://github.com/flacon/flacon/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	app-i18n/uchardet
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-qt/linguist-tools:5
	dev-qt/qtconcurrent:5
	test? (
		dev-qt/qttest:5
		media-libs/flac
		media-sound/mac
		media-sound/shntool
		media-sound/ttaenc
		media-sound/wavpack
	)
"
PATCHES=( "${FILESDIR}/${PN}-5.5.1-rm-gzip-cmd.patch" )

pkg_pretend() {
	use test && check-reqs_pkg_pretend
}

pkg_setup() {
	use test && check-reqs_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	remove_locale() {
		rm "translations/${PN}_${1}".{ts,desktop} || die
	}

	l10n_find_plocales_changes 'translations' "${PN}_" '.ts'
	l10n_for_each_disabled_locale_do remove_locale
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS="$(usex test)"
	)
	cmake_src_configure
}

src_test() {
	virtx "${BUILD_DIR}/tests/${PN}_test"
}

pkg_postinst() {
	elog "${PN} optionally supports formats listed below."
	elog "(List will be empty if all extra packages are installed.)"
	elog "Please install the required packages and restart ${PN}."
	optfeature 'FLAC input and output support' media-libs/flac
	optfeature 'WavPack input and output support' media-sound/wavpack
	optfeature 'APE input support' media-sound/mac
	optfeature 'TTA input support' media-sound/ttaenc
	optfeature 'AAC output support' media-libs/faac
	optfeature 'MP3 output support' media-sound/lame
	optfeature 'Vorbis output support' media-sound/vorbis-tools
	optfeature 'MP3 Replay Gain support' media-sound/mp3gain
	optfeature 'Vorbis Replay Gain support' media-sound/vorbisgain
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}

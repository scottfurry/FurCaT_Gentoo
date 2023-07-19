# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic qmake-utils

DESCRIPTION="Qt port of Neil Hodgson's Scintilla C++ editor control"
HOMEPAGE="https://www.riverbankcomputing.com/software/qscintilla/intro"

MY_PN=${PN/qs/QS}
SRC_URI="https://www.riverbankcomputing.com/static/Downloads/${MY_PN}/${PV}/${MY_PN}_src-${PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0/15"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="designer doc"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	designer? ( dev-qt/designer:5 )
"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	S="${WORKDIR}/${MY_PN}_src-${PV}"
	cd ${S}

	# Sub-slot sanity check
	local subslot=${SLOT#*/}
	local version=$(sed -nre 's:.*VERSION\s*=\s*([0-9\.]+):\1:p' "${S}"/src/qscintilla.pro || die)
	local major=${version%%.*}
	if [[ ${subslot} != ${major} ]]; then
		eerror
		eerror "Ebuild sub-slot (${subslot}) does not match QScintilla major version (${major})"
		eerror "Please update SLOT variable as follows:"
		eerror "    SLOT=\"${SLOT%%/*}/${major}\""
		eerror
		die "sub-slot sanity check failed"
	fi
	elog "subslot: ${subslot}\tversion: ${version}\tmajor: ${major}"
}

qsci_run_in() {
	pushd "$1" >/dev/null || die
	shift || die
	"$@" || die
	popd >/dev/null || die
}

src_configure() {
	if use designer; then
		# prevent building against system version (bug 466120)
		append-cxxflags -I../src
		append-ldflags -L../src
	fi

	qsci_run_in src eqmake5
	use designer && qsci_run_in designer eqmake5
}

src_compile() {
	qsci_run_in src emake
	use designer && qsci_run_in designer emake
}

src_install() {
	qsci_run_in src emake INSTALL_ROOT="${D}" install
	use designer && qsci_run_in designer emake INSTALL_ROOT="${D}" install

	use doc && local HTML_DOCS=( doc/html/. )
	einstalldocs
}

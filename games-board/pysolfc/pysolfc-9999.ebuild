# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
PYTHON_REQ_USE="tk"

inherit eutils distutils-r1

MY_PN=PySolFC
CARD_BASE="${MY_PN}-Cardsets"
DESCRIPTION="An exciting collection of more than 1000 solitaire card games"
HOMEPAGE="http://pysolfc.sourceforge.net/"

if [[ ${PV} == 9999 ]] ; then
	CARDSET_GIT_URL="https://github.com/shlomif/${CARD_BASE}.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_PN}"
	EGIT_REPO_URI="https://github.com/shlomif/${MY_PN}.git"
	EGIT_SUBMODULES=()
	inherit git-r3
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}"
	DEPEND="=dev-python/pysol_cards-9999"
else
	SRC_URI="https://github.com/shlomif/${MY_PN}/archive/${P}.tar.gz
		https://github.com/shlomif/${CARD_BASE}/archive/${CARD_VER}.tar.gz -> ${CARD_BASE}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${P}"
	DEPEND=">=dev-python/pysol_cards-0.8.6"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="minimal +sound"
RESTRICT="network-sandbox"

DEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/random2[${PYTHON_USEDEP}]
	!minimal? ( dev-python/pillow[tk,${PYTHON_USEDEP}] dev-tcltk/tktable )
	sound? ( dev-python/pygame[${PYTHON_USEDEP}] )
"

RDEPEND="${DEPEND}"
# for testing - add pycotap

python_prepare_all() {
    ln -s "${S}/data/images" "${S}/images"
	if [[ ${PV} == "9999" ]] ; then
		git-r3_fetch "${CARDSET_GIT_URL}"
		git-r3_checkout "${CARDSET_GIT_URL}" "${WORKDIR}/${MY_PN}-Cardsets"
	else
		unpack "${WORKDIR}/${CARD_BASE}.tar.gz"
	fi
	distutils-r1_python_prepare_all
}

python_compile_all() {
	pushd html-src > /dev/null || die "html-src not found"
	PYTHONPATH=.. "${EPYTHON}" gen-html.py
	mv images html/ || die "mv images failed"
	popd > /dev/null
}

python_install_all() {
	insinto /usr/share/applications
	doins ${S}/data/pysol.desktop

	insinto /usr/share/${MY_PN}
	doins -r "${WORKDIR}/${CARD_BASE}/"*

	doman docs/*.6
	DOCS=( README.md AUTHORS.md docs/README docs/README.SOURCE )
	HTML_DOCS=( html-src/html/* )
	dosym /usr/share/doc/${P}/html /usr/share/${MY_PN}/html

	distutils-r1_python_install_all
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Deal PySol FreeCell cards"
HOMEPAGE="https://pypi.org/project/pysol-cards/"
if [[ ${PV} == "9999" ]] ; then
    EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}"
	EGIT_REPO_URI="https://github.com/shlomif/${PN}.git"
	EGIT_SUBMODULES=()
	inherit git-r3
    KEYWORDS=""
    S="${WORKDIR}/${PN}"
else
    SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
    KEYWORDS="amd64 ~arm64 x86"
    S="${WORKDIR}/${MY_PN}-${P}"
fi

LICENSE="Apache-2.0 MIT"
SLOT="0"
IUSE=""
RESTRICT="network-sandbox"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
    dev-python/pbr[${PYTHON_USEDEP}]
	dev-python/random2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${BDEPEND}"
RDEPEND="${DEPEND}"

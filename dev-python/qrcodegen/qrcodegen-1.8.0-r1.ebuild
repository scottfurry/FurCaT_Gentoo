# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="High quality QR Code generator library for Python 2 and 3"
HOMEPAGE="https://www.nayuki.io/page/qr-code-generator-library"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
    dev-python/setuptools[${PYTHON_USEDEP}]
"

RDEPEND="
    ${DEPEND}
"

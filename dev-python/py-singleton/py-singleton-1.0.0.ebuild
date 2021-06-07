# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Singleton pattern for python 2 & 3."
HOMEPAGE="https://github.com/randydu/py-singleton https://pypi.org/project/py-singleton/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"
IUSE=""

DOCS=( README.md )

distutils_enable_tests pytest

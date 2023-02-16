# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Find unused code in Python programs"
HOMEPAGE="https://github.com/jendrikseipp/vulture https://pypi.org/project/vulture/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"
IUSE=""

DOCS=( README.md )

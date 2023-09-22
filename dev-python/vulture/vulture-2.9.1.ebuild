# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1 pypi

DESCRIPTION="High quality QR Code generator library for Python 2 and 3"
HOMEPAGE="https://www.nayuki.io/page/qr-code-generator-library"
SRC_URI="$(pypi_sdist_url ${PN} ${PV})"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"
IUSE=""

DOCS=( README.md )

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# ebuild derived from work provided by Michael Corvinus voron1@gmail.com
# provided in Gentoo Bug #666802 (https://bugs.gentoo.org/666802)
# and Gentoo Pull #29208 (https://github.com/gentoo/gentoo/pull/29208)

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )
PYTHON_REQ_USE="tk"

inherit desktop distutils-r1 multiprocessing xdg-utils

DESCRIPTION="Thonny is a Python IDE meant for learning programming."
HOMEPAGE="https://thonny.org/ https://github.com/thonny/thonny"
SRC_URI="https://github.com/thonny/thonny/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
$(python_gen_cond_dep '
    >=dev-python/cffi-1.8:=[${PYTHON_USEDEP}]
    >=dev-python/jedi-0.18.1:=[${PYTHON_USEDEP}]
    dev-python/setuptools:=[${PYTHON_USEDEP}]
    dev-python/pyserial:=[${PYTHON_USEDEP}]
    dev-python/pylint:=[${PYTHON_USEDEP}]
    dev-python/docutils:=[${PYTHON_USEDEP}]
    dev-python/mypy:=[${PYTHON_USEDEP}]
    dev-python/asttokens:=[${PYTHON_USEDEP}]
    dev-python/send2trash:=[${PYTHON_USEDEP}]
    dev-python/wheel:=[${PYTHON_USEDEP}]
    dev-python/pip:=[${PYTHON_USEDEP}]
' 'python*')"

BDEPEND=""

distutils_enable_tests pytest

DEPEND=""

RDEPEND+=${DEPEND}

src_prepare() {
	default
}

src_install() {
	distutils-r1_src_install
	newicon thonny/res/thonny.png thonny.png
	domenu ${S}/packaging/linux/org.thonny.Thonny.desktop
}

pkg_postinst() {
        xdg_desktop_database_update
}

pkg_postrm() {
        xdg_desktop_database_update
}

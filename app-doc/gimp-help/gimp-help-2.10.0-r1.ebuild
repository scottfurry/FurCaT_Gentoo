# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )
inherit python-any-r1

DESCRIPTION="GNU Image Manipulation Program help files"
HOMEPAGE="https://docs.gimp.org/"
SRC_URI="mirror://gimp/help/${P}.tar.bz2"

LICENSE="FDL-1.2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
# available languages in package
MY_L10N="ca da de el en en-GB es fi fr hr it ja ko lt nl nn pt-BR ro ru sl sv zh-CN"
for lang in ${MY_L10N}; do
	IUSE+=" ${lang/#/l10n_}"
done

BDEPEND="${PYTHON_DEPS}
	sys-devel/gettext
"

DEPEND="$(python_gen_any_dep 'dev-libs/libxml2[python,${PYTHON_USEDEP}]')
	dev-libs/libxslt
"
# Adds python3 support - gimp-help gitlab issue # 201
# https://gitlab.gnome.org/GNOME/gimp-help/-/issues/201
PATCHES=( "${FILESDIR}/${P}-python3.patch" )

# languages for building
BUILD_L10N=""

python_check_deps() {
	has_version "dev-libs/libxml2[${PYTHON_USEDEP}]"
}

src_configure() {
	# build up string of languages
	for lang in ${MY_L10N}; do
		if use l10n_${lang}; then
			BUILD_L10N+=" ${lang/-/_}"
		fi
	done
	if [ -z "${BUILD_L10N}" ]; then
		# default to English if no languages found
		BUILD_L10N="en"
	fi
	econf --without-gimp
}

src_compile() {
	# need to identify build languages during
	# build to prevent building all languages
	emake LANGUAGES="${BUILD_L10N}"
}

src_install() {
	# need to identify build languages during install
	# to prevent building/installing all languages
	emake DESTDIR="${D}" LANGUAGES="${BUILD_L10N}" install
}

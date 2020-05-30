# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

KEYWORDS="~amd64 ~x86"
MY_PN=${PN^^}
DESCRIPTION="Makes the illusion of embedding SQL queries in the regular C++ code"
HOMEPAGE="http://soci.sourceforge.net/"
# DOCUMENTATION="http://soci.sourceforge.net/doc/master/"
SRC_URI="https://github.com/${MY_PN}/${PN}/archive/${P}.zip"
LICENSE="Boost-1.0"
SLOT="0"
# 2019Nov - reported issues with building on arm7h
KEYWORDS="~amd64 ~x86 !arm"
IUSE="asan boost doc firebird mysql mariadb odbc oracle postgres +sqlite static-libs test"
# ASAN - enable address sanitizer

BDEPEND="
	app-text/dos2unix
"

# mariadb? ( dev-db/mariadb-connector-c:= )
DEPEND="
	${BDEPEND}
	boost? ( dev-libs/boost )
	firebird? ( dev-db/firebird )
	mysql? ( dev-db/mysql-connector-c:= )
	odbc? ( dev-db/unixODBC )
	oracle? ( dev-db/oracle-instantclient-basic )
	postgres? ( dev-db/postgresql:= )
	sqlite? ( dev-db/sqlite:3 )
"
RDEPEND=${DEPEND}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX='/usr'
		-DSOCI_CXX11=ON
		-DSOCI_STATIC=$(usex static-libs)
		-DSOCI_TESTS=$(usex test)
		-DSOCI_ASAN=$(usex asan)
		-DWITH_BOOST=$(usex boost)
		-DSOCI_EMPTY=ON    # empty db - always build
		-DWITH_DB2=OFF     # disable and not in IUSE - IBM DB2 support
		-DWITH_FIREBIRD=$(usex firebird)
		-DWITH_MYSQL=$(usex mysql)
		-DWITH_ODBC=$(usex odbc)
		-DWITH_ORACLE=$(usex oracle)
		-DWITH_POSTGRESQL=$(usex postgres)
		-DWITH_SQLITE3=$(usex sqlite)    # default - use system sqlite
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	# move generated cmake modules to their correct path location
	install -d ${D}/usr/share/cmake/Modules
	mv -v ${D}/usr/cmake/* ${D}/usr/share/cmake/Modules
	rm -vR ${D}/usr/cmake/
	# Remove the spurious executable permission
	chmod a-x AUTHORS README.md CHANGES LICENSE_1_0.txt
	find docs -type f -exec chmod a-x {} \;
	# correct non-unix EOLs
	dos2unix AUTHORS README.md CHANGES LICENSE_1_0.txt
	# process documentation
	# NOTE: known issue - ebuild QA msg: Colliding files found by ecompress(sitemap.xml.gz)
	dodoc AUTHORS README.md CHANGES LICENSE_1_0.txt
	if use doc; then
		docinto html
		dodoc -r ${S}/docs/*
	fi
}

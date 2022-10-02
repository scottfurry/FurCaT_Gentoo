# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# taken from overlay "nest" - http://gpo.zugaina.org/Overlays/nest

EAPI=8

inherit cmake

DESCRIPTION="Database access library for C++"
HOMEPAGE="http://soci.sourceforge.net/"
SRC_URI="https://github.com/SOCI/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-1"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="firebird mysql odbc oracle postgres sqlite static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
        dev-libs/boost:=
        firebird? ( dev-db/firebird )
        mysql? ( dev-db/mysql-connector-c:= )
        odbc? ( dev-db/unixODBC )
        oracle? ( dev-db/oracle-instantclient:= )
        postgres? ( dev-db/postgresql:= )
        sqlite? ( dev-db/sqlite:3 )
"

DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DSOCI_CXX11=ON
		-DSOCI_STATIC=$(usex static-libs)
		-DSOCI_TESTS=$(usex test)
		-DWITH_DB2=OFF     # disable and not in IUSE - IBM DB2 support
	)
	cmake_src_configure
}

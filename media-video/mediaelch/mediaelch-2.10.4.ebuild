# taken from https://data.gpo.zugaina.org/salfter/media-video/mediaelch/
EAPI=8
inherit qmake-utils

DESCRIPTION="Video metadata scraper"
# tarball produced with this command:
# docker run "-v${PWD}:/a" devsisters/tarballize https://github.com/Komet/MediaElch v$PV
SRC_URI="https://alfter.us/wp-content/uploads/2023/07/$P.tar.xz"
S=$WORKDIR/v$PV
HOMEPAGE="https://www.kvibes.de/mediaelch/"

SLOT="0"
LICENSE="LGPL-3"
KEYWORDS="amd64 x86"

DEPEND="dev-qt/qtquickcontrols:5
	dev-qt/qtcore:5
	media-video/mediainfo
	dev-qt/qtmultimedia:5[widgets]
	dev-qt/qtdeclarative:5
	dev-qt/qtopengl:5
	dev-qt/qtsvg:5"

src_configure()
{
  cd $S
  eqmake5
}

src_install()
{
  emake install INSTALL_ROOT=$D
}

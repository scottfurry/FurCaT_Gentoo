# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils pax-utils xdg

DESCRIPTION="A complete solution for viewing and editing PDF files"
HOMEPAGE="https://code-industry.net/free-pdf-editor/"
SRC_URI="https://code-industry.net/public/${P}-qt5.x86_64.tar.gz"

LICENSE="master-pdf-editor"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

RDEPEND=">=media-gfx/sane-backends-1.0"

QA_PREBUILT="/opt/${PN}/masterpdfeditor5
	/opt/${PN}/lib/*.so*
	/opt/${PN}/iconengines/*.so*
	/opt/${PN}/platformthemes/*.so*
	/opt/${PN}/printsupport/*.so*
	/opt/${PN}/platforms/*.so*
	/opt/${PN}/imageformats/*.so*
"

S="${WORKDIR}/${PN}-${PV%%.*}"
EXEC_NAME="masterpdfeditor5"

src_prepare() {
	default
	sed -i "s|Exec=/opt/master-pdf-editor-5/${EXEC_NAME}|Exec=${EXEC_NAME}|" "${S}/${EXEC_NAME}.desktop" || die
	sed -i "s|Path=/opt/master-pdf-editor-5||" "${S}/${EXEC_NAME}.desktop" || die
	sed -i "s|Icon=/opt/master-pdf-editor-5/${EXEC_NAME}.png|Icon=${PN}|" "${S}/${EXEC_NAME}.desktop" || die
}

src_install() {
	default
	pax-mark m "/opt/${PN}/${EXEC_NAME}"
	insinto /opt/${PN}
	doins -r fonts lang stamps templates ${EXEC_NAME}
	fperms +x /opt/${PN}/${EXEC_NAME}
	make_wrapper ${EXEC_NAME} /opt/${PN}/${EXEC_NAME}
	insinto "/usr/share/licenses/${PN}"
	doins "license.txt"
	domenu ${EXEC_NAME}.desktop
	newicon ${S}/${EXEC_NAME}.png ${PN}.png
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop pax-utils xdg

SHORT_PN="${PN/-bin}"
MIN_PN="${SHORT_PN/vs}"
CAP_PN="${SHORT_PN/vsc/VSC}"

DESCRIPTION="A community-driven, freely-licensed binary distribution of Microsoft's VSCode"
HOMEPAGE="https://vscodium.com/"
SRC_URI="
	amd64? ( https://github.com/VSCodium/${SHORT_PN}/releases/download/${PV}/${CAP_PN}-linux-x64-${PV}.tar.gz -> ${P}-amd64.tar.gz )
	arm? ( https://github.com/VSCodium/${SHORT_PN}/releases/download/${PV}/${CAP_PN}-linux-armhf-${PV}.tar.gz -> ${P}-arm.tar.gz )
	arm64? ( https://github.com/VSCodium/${SHORT_PN}/releases/download/${PV}/${CAP_PN}-linux-arm64-${PV}.tar.gz -> ${P}-arm64.tar.gz )
"

RESTRICT="mirror strip bindist"

LICENSE="
	Apache-2.0
	BSD
	BSD-1
	BSD-2
	BSD-4
	CC-BY-4.0
	ISC
	LGPL-2.1+
	MIT
	MPL-2.0
	openssl
	PYTHON
	TextMate-bundle
	Unlicense
	UoI-NCSA
	W3C
"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64"
IUSE=""

RDEPEND="
	app-accessibility/at-spi2-atk
	app-crypt/libsecret[crypt]
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/libpng:0/16
	net-print/cups
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libnotify
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/pango
"

QA_PREBUILT="
	/opt/${SHORT_PN}/${MIN_PN}
	/opt/${SHORT_PN}/libEGL.so
	/opt/${SHORT_PN}/libffmpeg.so
	/opt/${SHORT_PN}/libGLESv2.so
	/opt/${SHORT_PN}/libvulkan.so*
	/opt/${SHORT_PN}/chrome-sandbox
	/opt/${SHORT_PN}/libvk_swiftshader.so
	/opt/${SHORT_PN}/swiftshader/libEGL.so
	/opt/${SHORT_PN}/swiftshader/libGLESv2.so
	/opt/${SHORT_PN}/resources/app/extensions/*
	/opt/${SHORT_PN}/resources/app/node_modules.asar.unpacked/*
"

S="${WORKDIR}"

src_install() {
	# Cleanup
	rm "${S}/resources/app/LICENSE.txt" || die

	# Install
	pax-mark m codium
	insinto "/opt/${SHORT_PN}"
	doins -r *
	fperms +x /opt/${SHORT_PN}/{,bin/}${MIN_PN}
	fperms +x /opt/${SHORT_PN}/chrome-sandbox
	fperms -R +x /opt/${SHORT_PN}/resources/app/out/vs/base/node
	fperms +x /opt/${SHORT_PN}/resources/app/node_modules.asar.unpacked/@vscode/ripgrep/bin/rg
	dosym "../../opt/${SHORT_PN}/bin/${MIN_PN}" "usr/bin/${SHORT_PN}"
	domenu "${FILESDIR}/${SHORT_PN}.desktop"
	domenu "${FILESDIR}/${SHORT_PN}-url-handler.desktop"
	newicon "resources/app/resources/linux/code.png" "${SHORT_PN}.png"
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "When compared to the regular VSCode, ${CAP_PN} has a few quirks"
	elog "More information at: https://github.com/${CAP_PN}/${SHORT_PN}/blob/master/DOCS.md"
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop pax-utils xdg optfeature

PN_SHRT="${PN/-bin}"            # vscodium
PN_MIN="${PN_SHRT/vs}"          # codium
PN_CAPS="${PN_SHRT/vsc/VSC}"    # VSCodium
# After release 1.70.1, upstream added a build number to package identification
# release number is apart of package version value "x.y.z.release"
#
# After release 1.78.1.23130, upstream no longer producing 32bit releases
# Restored in release 1.79.0.23159
#
# After release 1.78.1.23130, upstream has a different mechanism for initiating terminal
#
DESCRIPTION="A community-driven, freely-licensed binary distribution of Microsoft's VSCode"
HOMEPAGE="https://vscodium.com/"
SRC_URI="
	amd64? ( https://github.com/${PN_CAPS}/${PN_SHRT}/releases/download/${PV}/${PN_CAPS}-linux-x64-${PV}.tar.gz -> ${P}-amd64.tar.gz )
	arm? ( https://github.com/${PN_CAPS}/${PN_SHRT}/releases/download/${PV}/${PN_CAPS}-linux-armhf-${PV}.tar.gz -> ${P}-arm.tar.gz )
	arm64? ( https://github.com/${PN_CAPS}/${PN_SHRT}/releases/download/${PV}/${PN_CAPS}-linux-arm64-${PV}.tar.gz -> ${P}-arm64.tar.gz )
"

RESTRICT="strip bindist"

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
KEYWORDS="-* ~amd64"
# disabled KEYWORDS="arm arm64"
IUSE=""

RDEPEND="
	|| (
		>=app-accessibility/at-spi2-core-2.46.0:2
		( app-accessibility/at-spi2-atk dev-libs/atk )
	)
	app-crypt/libsecret[crypt]
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/util-linux
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libxshmfence
	x11-libs/pango
"

QA_PREBUILT="
	/opt/${PN_SHRT}/bin/code-tunnel
	/opt/${PN_SHRT}/chrome_crashpad_handler
	/opt/${PN_SHRT}/chrome-sandbox
	/opt/${PN_SHRT}/${PN_MIN}
	/opt/${PN_SHRT}/libEGL.so
	/opt/${PN_SHRT}/libffmpeg.so
	/opt/${PN_SHRT}/libGLESv2.so
	/opt/${PN_SHRT}/libvk_swiftshader.so
	/opt/${PN_SHRT}/libvulkan.so*
	/opt/${PN_SHRT}/resources/app/extensions/*
	/opt/${PN_SHRT}/resources/app/node_modules.asar.unpacked/*
	/opt/${PN_SHRT}/swiftshader/libEGL.so
	/opt/${PN_SHRT}/swiftshader/libGLESv2.so
"
S="${WORKDIR}"

src_install() {
	# Disable update server
	sed -e "/updateUrl/d" -i ./resources/app/product.json || die

	# Install
	pax-mark m "${PN_MIN}"
	insinto "/opt/${PN_SHRT}"
	doins -r *
	fperms +x /opt/${PN_SHRT}/{,bin/}${PN_MIN}
	fperms +x /opt/${PN_SHRT}/chrome_crashpad_handler
	fperms 4711 /opt/${PN_SHRT}/chrome-sandbox
	fperms 755 /opt/${PN_SHRT}/resources/app/extensions/git/dist/{askpass,git-editor}{,-empty}.sh
	fperms -R +x /opt/${PN_SHRT}/resources/app/out/vs/base/node
	fperms +x /opt/${PN_SHRT}/resources/app/node_modules/@vscode/ripgrep/bin/rg
	dosym "../../opt/${PN_SHRT}/bin/code-tunnel" "usr/bin/code-tunnel"
	dosym "../../opt/${PN_SHRT}/bin/${PN_MIN}" "usr/bin/${PN_SHRT}"
	dosym "../../opt/${PN_SHRT}/bin/${PN_MIN}" "usr/bin/${PN_MIN}"
	domenu "${FILESDIR}/${PN_SHRT}.desktop"
	domenu "${FILESDIR}/${PN_SHRT}-url-handler.desktop"
	newicon "resources/app/resources/linux/code.png" "${PN_SHRT}.png"
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "When compared to the regular VSCode, ${PN_CAPS} has a few quirks"
	elog "More information at: https://github.com/${PN_CAPS}/${PN_SHRT}/blob/master/DOCS.md"
	optfeature "keyring support inside ${PN_CAPS}" "gnome-base/gnome-keyring"
}

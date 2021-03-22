# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop pax-utils xdg

MY_PN="${PN/-bin}"
ALT_PN="${MY_PN/vs}"

DESCRIPTION="Community-driven, freely-licensed binary distribution of Microsoft’s editor VSCode"
HOMEPAGE="https://vscodium.com/"
SRC_URI="
	amd64? ( https://github.com/VSCodium/${MY_PN}/releases/download/${PV}/VSCodium-linux-x64-${PV}.tar.gz )
	arm? ( https://github.com/VSCodium/${MY_PN}/releases/download/${PV}/VSCodium-linux-armhf-${PV}.tar.gz )
	arm64? ( https://github.com/VSCodium/${MY_PN}/releases/download/${PV}/VSCodium-linux-arm64-${PV}.tar.gz )"
RESTRICT="bindist strip test"
LICENSE="MIT"
SLOT="0"
KEYWORDS="-* amd64 ~arm ~arm64"
IUSE="+ext_vsx ext_msm libsecret"
# IUSE specific to VSCodium:
# ext_vsx - default - use open-vsx.org url for extension libraries
# ext_msm - use Microsoft VSCode Marketplace url for extension libraries
REQUIRED_USE=" || ( ext_vsx ext_msm )"

RDEPEND="
	app-accessibility/at-spi2-atk
	dev-libs/nss
	media-libs/libpng:0/16
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/libnotify
	x11-libs/pango
	libsecret? ( app-crypt/libsecret[crypt] )
	amd64? ( sys-apps/ripgrep )
	arm64? ( sys-apps/ripgrep )
"

S="${WORKDIR}"

src_prepare() {
	# NOTE - by default vscodium uses open-vsx.com for extension library.
	# To revert to Microsoft markplace, use the 'ext_msm' use flag.
	# See https://github.com/VSCodium/vscodium/issues/418 for explanation.
	if $(use ext_msm); then
		ewarn "Re-writing product file extension links"
		product_file="${S}/resources/app/product.json"
		# NOTE: leading line spacing important
		replace="  \"extensionsGallery\": {\n \
  \"serviceUrl\": \"https://marketplace.visualstudio.com/_apis/public/gallery\",\n \
  \"cacheUrl\": \"https://vscode.blob.core.windows.net/gallery/index\",\n \
  \"itemUrl\": \"https://marketplace.visualstudio.com/items\"\n \
  },"
		# awk explanation:
		# -v ... define awk variables and set to bash values
		# 1st -e -> find and insert replacement before match
		# 2nd -e -> find and removing subsequent 4 lines
		# Inline search/replace not possible.
		# Save to temp file and move after.
		awk -v replace="${replace}" \
		    -e '/extensionsGallery/{print replace}' \
		    -e'/extensionsGallery/{n=4};n{n--; next};1' < "${product_file}" > "${product_file}.tmp"
		mv "${product_file}.tmp" "${product_file}" || die
	fi
	default

	# Unbundle ripgrep on amd64 & arm64
	if use amd64 || use arm64; then
		rm "resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg" || die
	fi
}

src_install() {
	pax-mark m ${ALT_PN}
	insinto "/opt/${MY_PN}"
	doins -r *
	dosym "/opt/${MY_PN}/bin/${ALT_PN}" "usr/bin/${ALT_PN}"

	domenu "${FILESDIR}/${ALT_PN}.desktop"
	domenu "${FILESDIR}/${ALT_PN}-url-handler.desktop"
	
	fperms +x /opt/${MY_PN}/{,bin/}${ALT_PN}
	fperms +x /opt/${MY_PN}/chrome-sandbox
	fperms +x /opt/${MY_PN}/resources/app/extensions/git/dist/askpass.sh
	fperms -R +x /opt/${MY_PN}/resources/app/out/vs/base/node

	if use amd64 || use arm64; then
		dosym "../../../../../../../usr/bin/rg" "${EPREFIX}/opt/${MY_PN}/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg"
	else
		#fix Spawn EACESS bug #25848
		# On other arches we don't unbundle rg, so we have to make it executable
		fperms +x /opt/${MY_PN}/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg
	fi

	dodoc resources/app/LICENSE.txt resources/app/ThirdPartyNotices.txt
	newicon resources/app/resources/linux/code.png ${MY_PN}.png
}


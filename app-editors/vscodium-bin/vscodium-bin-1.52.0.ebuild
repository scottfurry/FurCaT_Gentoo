# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit desktop eutils pax-utils xdg
MY_PN="${PN/-bin}"
MY_P="${MY_PN}-${PV}"
MY_INSTALL_DIR="/opt/${MY_PN}"
MY_EXEC="${MY_PN/vs}"

DESCRIPTION="Community-driven, freely-licensed binary distribution of Microsoft’s editor VSCode"
HOMEPAGE="https://vscodium.com/"
SRC_URI="
	amd64? ( https://github.com/VSCodium/vscodium/releases/download/${PV}/VSCodium-linux-x64-${PV}.tar.gz )
	arm? ( https://github.com/VSCodium/vscodium/releases/download/${PV}/VSCodium-linux-armhf-${PV}.tar.gz )
	arm64? ( https://github.com/VSCodium/vscodium/releases/download/${PV}/VSCodium-linux-arm64-${PV}.tar.gz )"
RESTRICT="mirror strip bindist"
LICENSE="MIT"
SLOT="0"
KEYWORDS="-* amd64 ~arm ~arm64"
IUSE="+ext_vsx ext_msm"
# IUSE specific to VSCodium:
# ext_vsx - default - use open-vsx.org url for extension libraries
# ext_msm - use Microsoft VSCode Marketplace url for extension libraries
REQUIRED_USE="
	|| ( ext_vsx ext_msm )"

DEPEND="
	media-libs/libpng
	>=x11-libs/gtk+-3.0
	x11-libs/cairo
	x11-libs/libXtst
	!app-editors/vscodium
"

RDEPEND="
	${DEPEND}
	app-accessibility/at-spi2-atk
	>=net-print/cups-2.0.0
	x11-libs/libnotify
	x11-libs/libXScrnSaver
	dev-libs/nss
	app-crypt/libsecret[crypt]
"

QA_PRESTRIPPED="*"
QA_PREBUILT="opt/${MY_PN}/codium"

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
}

src_install() {
	insinto "${MY_INSTALL_DIR}"
	doins -r *
	dosym "${MY_INSTALL_DIR}/${MY_EXEC}" "/usr/bin/${MY_PN}"
	make_wrapper "${MY_PN}" "${MY_INSTALL_DIR}/${MY_EXEC}"
	domenu "${FILESDIR}/${MY_PN}.desktop"
	newicon "resources/app/resources/linux/code.png" ${MY_PN}.png

	fperms +x "${MY_INSTALL_DIR}/${MY_EXEC}"
	fperms 4755 "${MY_INSTALL_DIR}/chrome-sandbox"
	fperms +x "${MY_INSTALL_DIR}/libEGL.so"
	fperms +x "${MY_INSTALL_DIR}/libGLESv2.so"
	fperms +x "${MY_INSTALL_DIR}/libffmpeg.so"
	fperms +x "${MY_INSTALL_DIR}/resources/app/extensions/git/dist/askpass.sh"
	#fix Spawn EACESS bug #25848
	fperms +x "${MY_INSTALL_DIR}/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg"

	insinto "/usr/share/licenses/${MY_PN}"
	for i in resources/app/LICEN*; do
		newins "${i}" "$(basename ${i})"
	done
	pax-mark m "${MY_INSTALL_DIR}/${MY_EXEC}"
}

pkg_postinst() {
	xdg_pkg_postinst
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	xdg_icon_cache_update
}

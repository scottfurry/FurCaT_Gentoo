# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit desktop eutils pax-utils xdg
MY_PN="${PN/-bin}"
MY_P="${MY_PN}-${PV}"
MY_INSTALL_DIR="/opt/${PN}"
MY_EXEC="${MY_PN/vs}"

DESCRIPTION="Community-driven, freely-licensed binary distribution of Microsoft’s editor VSCode"
HOMEPAGE="https://vscodium.com/"
SRC_URI="https://github.com/VSCodium/${MY_PN}/releases/download/${PV}/VSCodium-linux-x64-${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror strip"
LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="libsecret hunspell +ext_vsx ext_msm"
# IUSE specific to VSCodium:
# ext_vsx - default - use open-vsx.org url for extension libraries
# ext_msm - use Microsoft VSCode Marketplace url for extension libraries
REQUIRED_USE="|| ( ext_vsx ext_msm )"

DEPEND="
	media-libs/libpng
	>=x11-libs/gtk+-3.0
	x11-libs/cairo
	x11-libs/libXtst
"

RDEPEND="
	${DEPEND}
	>=net-print/cups-2.0.0
	x11-libs/libnotify
	x11-libs/libXScrnSaver
	dev-libs/nss
	hunspell? ( app-text/hunspell )
	libsecret? ( app-crypt/libsecret[crypt] )
"

src_unpack() {
	# vscodium tarball differs from vscode-bin as vscodium does not use a containing folder.
	# manual intervention required to correct.
	install -d "${WORKDIR}/${P}"
	S="${WORKDIR}/${P}"
	cd "${S}" || die "cd into target directory ${S} failed"
	unpack "${P}.tar.gz"
}

src_prepare() {
	# NOTE - by default vscodium uses open-vsx.com for extension library.
	# To revert to Microsoft markplace, use the 'ext_msm' use flag.
	# See https://github.com/VSCodium/vscodium/issues/418 for explanation.
	if $(use ext_msm); then
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
	pax-mark m "${MY_INSTALL_DIR}/${MY_EXEC}"
	insinto "${MY_INSTALL_DIR}"
	doins -r *
	dosym "${MY_INSTALL_DIR}/${MY_EXEC}" "/usr/bin/${PN}"
	make_wrapper "${PN}" "${MY_INSTALL_DIR}/${MY_EXEC}"
	domenu ${FILESDIR}/${PN}.desktop
	newicon ${S}/resources/app/resources/linux/code.png ${PN}.png

	fperms +x "${MY_INSTALL_DIR}/${MY_EXEC}"
	fperms 4755 "${MY_INSTALL_DIR}/chrome-sandbox"
	fperms +x "${MY_INSTALL_DIR}/libEGL.so"
	fperms +x "${MY_INSTALL_DIR}/libGLESv2.so"
	fperms +x "${MY_INSTALL_DIR}/libffmpeg.so"
	fperms +x "${MY_INSTALL_DIR}/resources/app/extensions/git/dist/askpass.sh"
	#fix Spawn EACESS bug #25848
	fperms +x "${MY_INSTALL_DIR}/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg"

	insinto "/usr/share/licenses/${PN}"
	for i in resources/app/LICEN*; do
		newins "${i}" "$(basename ${i})"
	done
}

pkg_postinst() {
	xdg_pkg_postinst
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	xdg_icon_cache_update
}

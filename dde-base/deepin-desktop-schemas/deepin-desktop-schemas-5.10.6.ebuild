# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="deepin-desktop-schemas"
inherit gnome2-utils golang-vcs-snapshot

DESCRIPTION="GSettings deepin desktop-wide schemas"
HOMEPAGE="https://github.com/linuxdeepin/deepin-desktop-schemas"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
LICENSE="GPL-3+"
SLOT="0"
IUSE=""

DEPEND="dev-libs/glib:2
		>=dde-base/deepin-desktop-base-2020.04.12
		>=dev-go/deepin-go-lib-5.4.5"

src_prepare() {
	export GOPATH="$(get_golibdir)"
	# fix default background url
	sed -i "s#/usr/share/backgrounds/default_background.jpg#/usr/share/backgrounds/deepin/desktop.jpg#" \
		overrides/common/com.deepin.wrap.gnome.desktop.override schemas/com.deepin.dde.appearance.gschema.xml
	# fix network checker url
	sed -i "s#'http://detect.uniontech.com', 'http://detectportal.deepin.com'#'http://www.gentoo.org/favicon.ico'#" \
		schemas/com.deepin.dde.network-utils.gschema.xml
	default_src_prepare
}

src_compile() {
	cd ${S}/src/${EGO_PN}
	emake ARCH=x86
}

src_install() {
	cd ${S}/src/${EGO_PN}/result/
	#emake DESTDIR=${D} install

	insinto /usr/share/${PN}
	doins *-override

	insinto /usr/share/glib-2.0/schemas
	doins *.xml
}

pkg_preinst() { gnome2_schemas_savelist;}
pkg_postinst() { gnome2_schemas_update; }
pkg_postrm() { gnome2_schemas_update; }

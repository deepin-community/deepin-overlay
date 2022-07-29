# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xdg-utils

DESCRIPTION="Deepin Icons"
HOMEPAGE="https://github.com/linuxdeepin/deepin-icon-theme"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""
DEPEND="dev-util/gtk-update-icon-cache"

src_prepare() {
	default_src_prepare
}

src_compile() {
	emake hicolor-links
}

src_install() {
	emake DESTDIR="$D" install
	insinto /usr/share/icons/
	doins -r Sea usr/share/icons/hicolor
}

pkg_postinst() { xdg_icon_cache_update; }
pkg_postrm() { xdg_icon_cache_update; }

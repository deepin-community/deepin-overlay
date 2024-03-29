# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Deepin theme for Plymouth"
HOMEPAGE="https://github.com/linuxdeepin/plymouth-theme-deepin"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-3+"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
SLOT="0"
IUSE=""

RDEPEND="sys-boot/plymouth"
DEPEND="${RDEPEND}"

src_install() {
	insinto /usr/share/plymouth
	doins -r themes
}

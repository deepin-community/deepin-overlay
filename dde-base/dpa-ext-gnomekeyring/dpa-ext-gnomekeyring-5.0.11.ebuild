# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="GNOME keyring extension for dde-polkit-agent"
HOMEPAGE="https://github.com/linuxdeepin/dpa-ext-gnomekeyring"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

RDEPEND="dev-qt/qtcore:5
		dev-qt/qtwidgets:5
		gnome-base/libgnome-keyring
		dde-base/dde-polkit-agent
		"
DEPEND="${RDEPEND}
		"

src_prepare() {
	LIBDIR=$(get_libdir)
	sed -i "s|lib/|${LIBDIR}/|g" CMakeLists.txt
	cmake_src_prepare
}

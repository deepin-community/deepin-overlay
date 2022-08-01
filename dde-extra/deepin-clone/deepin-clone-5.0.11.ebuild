# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Deepin Disk and Partition Backup/Restore Tool"
HOMEPAGE="https://github.com/linuxdeepin/deepin-clone"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"

RDEPEND="dev-qt/qtcore:5
		dev-qt/qtconcurrent:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtnetwork:5
		dev-qt/qtmultimedia:5[widgets]
		"

DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.5.0
		virtual/pkgconfig
		"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR=$(get_libdir)
	)
	cmake_src_configure
}

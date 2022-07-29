# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="An easy to use Calculator for Deepin"
HOMEPAGE="https://github.com/linuxdeepin/deepin-calculator"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

RDEPEND="dev-qt/qtcore:5
		 dev-qt/qtwidgets:5
		 dev-qt/qtgui:5
		 dev-qt/qtsvg:5
		 "

DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.5.0:=
		dev-qt/linguist-tools
		dev-qt/qtchooser
		virtual/pkgconfig
		"

src_prepare() {
	sed -i "/<QPainter>/a\#include <QPainterPath>" \
		src/views/simplelistdelegate.cpp || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DVERSION=${PV}
	)
	cmake_src_configure
}

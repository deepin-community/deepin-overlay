# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Color picker tool for Deepin"
HOMEPAGE="https://github.com/linuxdeepin/deepin-picker"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

RDEPEND="dev-qt/qtcore:5
		dev-qt/qtwidgets:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtx11extras:5
		dev-qt/qtdbus:5
		dev-qt/qtsvg:5
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXtst
		x11-libs/xcb-util
		x11-libs/libxcb
		"

DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.5.0:=
		dev-qt/linguist-tools
		dev-qt/qtchooser
		virtual/pkgconfig
		"

src_prepare() {
	QT_SELECT=qt5 eqmake5
	default_src_prepare
}

src_install() {
	emake INSTALL_ROOT=${D} install
}

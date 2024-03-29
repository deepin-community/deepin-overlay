# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Deepin shortcut Viewer"
HOMEPAGE="https://github.com/linuxdeepin/deepin-shortcut-viewer"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

RDEPEND="dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtnetwork:5
		media-libs/mesa
		x11-libs/libxcb
		"

DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.1.2:=
		"

src_prepare() {
	QT_SELECT=qt5 eqmake5
	default
}

src_install() {
	emake INSTALL_ROOT=${D} install
}

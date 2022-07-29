# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="A document parser library ported from document2html"
HOMEPAGE="https://github.com/linuxdeepin/docparser"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
		virtual/pkgconfig
		app-text/poppler
		dev-qt/linguist-tools:5
		"

src_prepare() {
	QT_SELECT=qt5 eqmake5 PREFIX=/usr LIB_INSTALL_DIR=/usr/$(get_libdir)/
	default_src_prepare
}

src_install() {
	emake INSTALL_ROOT=${D} install
}

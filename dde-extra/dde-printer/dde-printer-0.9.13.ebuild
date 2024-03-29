# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Deepin Printer Manager"
HOMEPAGE="https://github.com/linuxdeepin/dde-printer"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

RDEPEND="dev-qt/qtcore:5
		dev-qt/qtwidgets:5
		dev-qt/qtnetwork:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		net-fs/samba
		sys-apps/fakeroot
		net-print/cups
		dev-libs/crypto++"

DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.5.0:=
		>=dde-base/dtkgui-5.5.0:=
		"

src_prepare() {
	LIBDIR=$(get_libdir)
	sed -i "s|/usr/lib|/usr/${LIBDIR}|g" src/cppcups/cppcups.pro || die
	sed -i "s|-lcrypto++|-lcryptopp|g" src/Printer/Printer.pro || die

	sed -i '$aOnlyShowIn=Deepin' src/Printer/platform/linux/dde-printer.desktop
	sed -i "s/#include <strings.h>/#include <strings.h>\n#include <stdexcept>/g" src/cppcups/cupssnmp.cpp || die

	export QT_SELECT=qt5
	eqmake5 PREFIX=/usr  DEFINES+="VERSION=${PV}"
	default_src_prepare
}

src_install() {
	emake INSTALL_ROOT=${D} install
}

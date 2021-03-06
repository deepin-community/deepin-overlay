# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit qmake-utils

DESCRIPTION="DDE Network Utils"
HOMEPAGE="https://github.com/linuxdeepin/dde-network-utils"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtdbus:5
		 dev-qt/qtgui:5
	     "
DEPEND="${RDEPEND}
		>=dde-base/dde-qt-dbus-factory-0.3.1:=
		x11-libs/gsettings-qt
	    "

src_prepare() {
	LIBDIR=$(get_libdir)
	sed -i "s|PREFIX/lib|{PREFIX}/${LIBDIR}|g" ${PN}/${PN}.pro
	# Use our own url instead of commercial company's homepage
	sed -i '/www.uniontech.com/i \    "https://www.gentoo.org/favicon.ico",' dde-network-utils/connectivitychecker.cpp
	QT_SELECT=qt5 eqmake5	PREFIX=/usr
	default_src_prepare
}

src_install() {
	emake INSTALL_ROOT=${D} install
}


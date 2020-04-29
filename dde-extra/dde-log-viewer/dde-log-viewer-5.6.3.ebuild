# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit qmake-utils

DESCRIPTION="Deepin Log Viewer"
HOMEPAGE="https://github.com/linuxdeepin/dde_log_viewer"
MY_PN=${PN//-/_}
MY_P=${MY_PN}-${PV}
SRC_URI="https://github.com/linuxdeepin/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtcore:5
		dev-qt/qtwidgets:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtx11extras:5
		dev-qt/qtdbus:5
		dev-qt/qtsvg:5
		"

DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.1.2:=
		dev-qt/linguist-tools
		virtual/pkgconfig
		"

src_prepare() {

	sed -i "/<QList>/a\#include\ <QIODevice>" \
		thirdlib/docx/opc/packagereader.h || die

	QT_SELECT=qt5 eqmake5 DEFINES+="VERSION=${PV}"
	default_src_prepare
}

src_install() {
	emake INSTALL_ROOT=${D} install
}
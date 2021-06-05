# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit cmake-utils

DESCRIPTION="Calendar for Deepin Desktop Environment"
HOMEPAGE="https://github.com/linuxdeepin/dde-calendar"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtcore:5
		dev-qt/qtwidgets:5
		dev-qt/qtconcurrent:5
		dev-qt/qtdbus:5"

DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.1.2:=
		"

src_prepare() {
	LIBDIR=$(get_libdir)
	sed -i "s|/usr/lib/|/usr/${LIBDIR}/|g" \
		schedule-plugin/CMakeLists.txt || die
	sed -i "s|lib/deepin-daemon/|${LIBDIR}/deepin-daemon/|g" calendar-service/CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure(){
	local mycmakeargs=(             
		-DVERSION=${PV}
	)
	cmake-utils_src_configure
}


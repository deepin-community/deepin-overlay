# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit qmake-utils eutils

DESCRIPTION="Deepin Screencasting and Screenshot Application"
HOMEPAGE="https://github.com/linuxdeepin/deepin-screen-recorder/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
else
	SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="+mp4"

REQUIRED_USE="|| ( mp4 )"

RDEPEND="dev-qt/qtwidgets:5
		dev-qt/qtnetwork:5
		dev-qt/qtgui:5
		dev-qt/qtdbus:5
		dev-qt/qtx11extras:5
		x11-libs/libXtst
		mp4? ( media-video/ffmpeg[x264] )
		"

DEPEND="${RDEPEND}
		x11-libs/xcb-util
		x11-libs/libxcb
		>=dde-base/dtkwidget-5.1.2:=
		dde-base/dtkgui:=
		"

src_prepare() {
	LIBDIR=$(get_libdir)
	# sed -i "s|lib/|${LIBDIR}/|g" \
	# 	src/dde-dock-plugins/recordtime/CMakeLists.txt
	sed -i "s|lib/|${LIBDIR}/|g" \
		src/dde-dock-plugins/recordtime/recordtime.pro
	sed -i '/include <X11.extensions.XTest.h>/a #undef min' src/event_monitor.cpp
	sed -i '/#include <iostream>/d;1i #include <iostream>' src/screen_shot_event.cpp
	sed -i '/include <X11.extensions.shape.h>/a #undef None' src/utils.cpp
	default
	QT_SELECT=qt5 eqmake5 screen_shot_recorder.pro
}

src_install() {
	emake INSTALL_ROOT=${D} install
}

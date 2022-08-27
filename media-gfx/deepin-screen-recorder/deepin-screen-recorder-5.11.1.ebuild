# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Deepin Screencasting and Screenshot Application"
HOMEPAGE="https://github.com/linuxdeepin/deepin-screen-recorder/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
else
	SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
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
		media-libs/opencv
		mp4? ( media-video/ffmpeg[x264] )
		"

DEPEND="${RDEPEND}
		x11-libs/xcb-util
		x11-libs/libxcb
		>=dde-base/dtkwidget-5.5.0
		>=dde-base/dde-dock-5.5.0
		dde-base/dtkgui:=
		"

src_prepare() {
	LIBDIR=$(get_libdir)
	sed -i "s|lib/|${LIBDIR}/|g" \
		src/dde-dock-plugins/recordtime/recordtime.pro \
		src/dde-dock-plugins/shotstart/shotstart.pro || die

	sed -i '/include <X11.extensions.XTest.h>/a #undef min' src/event_monitor.cpp || die

	# https://github.com/linuxdeepin/developer-center/issues/3035
	sed -i "s^cat /etc/os-version | grep 'Community'^echo 'Community'^" src/src.pro || die

	# OpenCV 4 compatibility
	sed -i '/#include<opencv2/i #include <opencv2/imgproc/types_c.h>' src/utils/pixmergethread.h || die

	# OpenCV missing in pkg-config targets
	sed -i 's/dframeworkdbus/dframeworkdbus opencv4/' src/src.pro || die

	default
}

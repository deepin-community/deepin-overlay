# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="A lightweight memo tool to make text notes and voice recordings"
HOMEPAGE="https://github.com/linuxdeepin/deepin-voice-note"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
else
	SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtmultimedia:5
	dev-qt/qtwidgets:5
	dev-qt/qtgui:5
	dev-qt/qtsql:5
	dev-qt/qtdbus:5
	x11-libs/startup-notification
	media-video/vlc
	media-libs/gstreamer
	"

DEPEND="${RDEPEND}
		media-libs/fontconfig
		media-libs/freetype
		>=dde-base/dde-qt-dbus-factory-5.0.16
		>=dde-base/dtkwidget-5.5.0:=
		"

src_prepare() {
	sed -i "/\#include <QPainter>/a\#include <QPainterPath>" \
		src/views/middleviewdelegate.cpp \
		src/views/leftviewdelegate.cpp || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DVERSION=${PV}
	)
	cmake_src_configure
}

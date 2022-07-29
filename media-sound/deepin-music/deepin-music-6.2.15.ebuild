# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="Deepin Music Player"
HOMEPAGE="https://github.com/linuxdeepin/deepin-music"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="3"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE="+mp3 +flac +ogg +aac"

RDEPEND="dev-qt/qtmultimedia:5[gstreamer]
	dev-libs/icu
	dev-qt/qtsvg:5
	dev-qt/qtconcurrent:5
	dde-base/deepin-menu
	sys-devel/bison
	media-libs/libcue
	media-video/ffmpeg
	media-video/vlc
	>=media-libs/taglib-1.10
	media-plugins/gst-plugins-meta:1.0[mp3=,flac=,ogg=,aac=]
	x11-libs/qtmpris
	"
DEPEND="${RDEPEND}
	>=dde-base/dtkwidget-5.5:=
	"

src_prepare() {
	LIBDIR=$(get_libdir)
	sed -i '/pkg_check_modules(DBusextended/d' src/music-player/CMakeLists.txt || die
	sed -i 's/PkgConfig::DBusextended//g' src/music-player/CMakeLists.txt || die
	sed -i "s|lib/|${LIBDIR}/|g" src/libmusic-plugin/CMakeLists.txt || die
	cmake_src_prepare
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

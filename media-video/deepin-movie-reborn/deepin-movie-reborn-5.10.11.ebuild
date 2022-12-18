# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg
DESCRIPTION="Deepin Movie Player"
HOMEPAGE="https://github.com/linuxdeepin/deepin-movie-reborn"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="3"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

# dvd
DEPEND="dev-qt/qtdbus:5
		dev-qt/qtwidgets:5
		dev-qt/linguist-tools:5
		dev-qt/qtsvg:5
		dev-qt/qtmultimedia:5
		dev-qt/qtx11extras:5
		dev-libs/openssl
		media-video/mpv[libmpv]
		x11-libs/libxcb
		x11-libs/xcb-util
		x11-libs/xcb-util-wm
		x11-base/xcb-proto
		x11-base/xorg-proto
		media-video/ffmpegthumbnailer
		x11-libs/libXtst
		media-sound/pulseaudio
		media-video/ffmpeg
		media-libs/libdvdnav
		x11-libs/qtmpris
		media-libs/gstreamer
		media-libs/gst-plugins-base
		media-libs/libva
		"
RDEPEND="${DEPEND}
		>=dde-base/dtkcore-5.5.0
		>=dde-base/dtkwidget-5.5.0:=
		"
src_prepare() {
	# mpv remove qthelper.hpp since 0.33.0
	cp "$FILESDIR/qthelper.hpp" src/common/
	sed -i "s|<mpv/qthelper.hpp>|\"qthelper.hpp\"|g" \
		src/libdmr/compositing_manager.cpp \
		src/backends/mpv/mpv_glwidget.h \
		src/backends/mpv/mpv_proxy.h || die

	sed -i '/avformat.h>/i #include <libavcodec/avcodec.h>' \
		src/libdmr/playlist_model.cpp || die

	LIBDIR=$(get_libdir)
	sed -i '/pkg_check_modules(DBusextended/d' src/CMakeLists.txt || die
	sed -i 's/PkgConfig::DBusextended//g' src/CMakeLists.txt || die
	sed -i "s|lib/|${LIBDIR}/|g" src/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DVERSION=${PV}
	)
	cmake_src_configure
}

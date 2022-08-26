# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit cmake xdg

DESCRIPTION="Deepin Photo Manager"
HOMEPAGE="https://github.com/linuxdeepin/deepin-album"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE="+jpeg +png +tiff raw mng jpeg2k"

RDEPEND="dev-qt/qtsvg:5
		dev-qt/qtgui:5
		dev-qt/qtconcurrent:5
		dev-qt/qtdbus:5
		dev-qt/qtprintsupport:5
		dev-qt/qtmultimedia:5
		dev-qt/qtx11extras:5
		dev-qt/qtsql:5[sqlite]
		dev-qt/qtopengl:5
		dev-qt/qtimageformats:5
		media-libs/fontconfig
		media-libs/freetype
		media-libs/libraw
		media-libs/libexif
		media-libs/libglvnd
		media-libs/freeimage[jpeg?,png?,tiff?,raw?,mng?,jpeg2k?]
		media-libs/deepin-image-editor
		sys-libs/mtdev
		virtual/libudev
		x11-base/xorg-proto
		x11-libs/xcb-util
		x11-libs/libXrender
		"

DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.5.0:=
		dev-qt/gio-qt
		dde-base/udisks2-qt5
		"

src_prepare() {
	LIBDIR=$(get_libdir)
	sed -i "s|/lib\([/)]\)|/${LIBDIR}\1|g" libUnionImage/CMakeLists.txt || die
	sed -i '/FIF_FAXG3/d' libUnionImage/UnionImage/unionimage.cpp || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DVERSION=${PV}
	)
	cmake_src_configure
}

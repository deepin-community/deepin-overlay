# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Deepin Image Viewer"
HOMEPAGE="https://github.com/linuxdeepin/deepin-image-viewer"
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
		x11-libs/libXrender
		"

DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.5.0:=
		dev-qt/gio-qt
		dde-base/udisks2-qt5
	    "

PATCHES=(
		"${FILESDIR}"/${PN}-5.8.15-remove-unused-deps.patch
)

src_prepare() {
	cmake_src_prepare
}

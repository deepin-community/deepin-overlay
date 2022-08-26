# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Deepin Painting Tool"
HOMEPAGE="https://github.com/linuxdeepin/deepin-draw"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
else
	SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="+jpeg +png +tiff raw mng jpeg2k"

RDEPEND="dev-qt/qtsvg:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtdbus:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
		dev-qt/qtopengl:5
		media-libs/libraw
		media-libs/libexif
		media-libs/freeimage[jpeg?,png?,tiff?,raw?,mng?,jpeg2k?]
		dde-extra/deepin-picker
		"

DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.5.0:=
		"

src_prepare() {
	cmake_src_prepare
}

# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Image editor is a public library for deepin-image-viewer and deepin-album"
HOMEPAGE="https://github.com/linuxdeepin/image-editor"
SRC_URI="https://github.com/linuxdeepin/image-editor/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

RDEPEND="
		>=dde-base/dtkwidget-5.5.0:=
		media-libs/freeimage
		media-libs/opencv
		dev-qt/qtsvg:5
		dev-qt/linguist-tools:5
		"

DEPEND="${RDEPEND}"

S="${WORKDIR}/image-editor-${PV}"

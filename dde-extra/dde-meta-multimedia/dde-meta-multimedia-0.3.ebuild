# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Deepin Multimedia Softwares (meta package)"
HOMEPAGE="https://www.deepin.org"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

RDEPEND="media-sound/deepin-music
		media-video/deepin-movie-reborn
		media-gfx/deepin-screen-recorder
		dde-extra/deepin-voice-note
		media-gfx/deepin-image-viewer
		media-gfx/deepin-draw
		media-gfx/deepin-album
		"

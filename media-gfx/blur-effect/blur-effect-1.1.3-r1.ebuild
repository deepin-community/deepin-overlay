# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Off-screen image blurring utility using OpenGL ES 3.0"
HOMEPAGE="https://github.com/sonald/blur-effect"
SRC_URI="https://github.com/sonald/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

DEPEND="media-libs/mesa[gles2]
	x11-libs/gdk-pixbuf
	media-libs/glew"
RDEPEND="${DEPEND}"

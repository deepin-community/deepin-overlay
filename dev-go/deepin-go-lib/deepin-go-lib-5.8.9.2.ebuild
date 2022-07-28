# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="pkg.deepin.io/lib/"

inherit golang-vcs-snapshot

DESCRIPTION="Deepin GoLang Library"
HOMEPAGE="https://github.com/linuxdeepin/go-lib"
SRC_URI="https://github.com/linuxdeepin/go-lib/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"

src_prepare() {
	default

	sed -i "s|int connect_timeout|extern int connect_timeout|g" \
		${S}/src/${EGO_PN}/pulse/dde-pulse.h || die
}

src_install() {
	insinto $(get_golibdir)
	doins -r src
}

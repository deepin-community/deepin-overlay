# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/linuxdeepin/go-gir-generator"

inherit golang-base

DESCRIPTION="Generate static golang bindings for GObject"
HOMEPAGE="https://github.com/linuxdeepin/go-gir-generator"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

DEPEND="dev-libs/gobject-introspection
	dev-libs/libgudev[introspection]"

src_prepare() {
	export -n GOCACHE XDG_CACHE_HOME
	default_src_prepare
}

src_install() {
	dobin out/gir-generator
	insinto $(get_golibdir)
	doins -r out/src
}

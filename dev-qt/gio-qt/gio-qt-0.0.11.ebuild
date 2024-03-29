# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="Qt wrapper library of Gio"
HOMEPAGE="https://github.com/linuxdeepin/gio-qt"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
else
	SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-qt/qtcore-5.15:5
	"
DEPEND="${RDEPEND}
		doc? ( app-doc/doxygen )
		test? ( dev-qt/qttest:5 )
		dev-cpp/glibmm:2
		virtual/pkgconfig
		"

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS="$(usex doc)"
		-DBUILD_TESTS="$(usex test)"
	)

	cmake_src_configure
}

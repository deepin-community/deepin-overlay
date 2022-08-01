# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Deepin System Monitor"
HOMEPAGE="https://github.com/linuxdeepin/deepin-system-monitor/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
else
	SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="sys-process/procps
	sys-libs/libcap
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtdbus:5
	dev-qt/qtx11extras:5
	x11-libs/xcb-util
	x11-libs/libxcb
	x11-libs/libXext
	x11-libs/libXtst
	sys-libs/ncurses
	net-libs/libpcap
	dev-libs/icu
	"

DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.5.0:=
		"

PATCHES=(
	"${FILESDIR}"/${PN}-5.9.17-disable-wayland.patch
)

src_prepare() {
	# Fix icu name
	sed -i "/#undef u_errorName/d" deepin-system-monitor-main/common/han_latin.cpp || die
	sed -i "/U_DEF2_ICU_ENTRY_POINT_RENAME/d" deepin-system-monitor-main/common/han_latin.cpp || die
	sed -i "s/UERRORNAME/u_errorName/" deepin-system-monitor-main/common/han_latin.cpp || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DVERSION=${PV}
		-DWAYLAND_SESSION_SUPPORT=OFF
	)
	cmake_src_configure
}

pkg_postinst() {
	setcap cap_kill,cap_net_raw,cap_dac_read_search,cap_sys_ptrace+ep /usr/bin/${PN}
}

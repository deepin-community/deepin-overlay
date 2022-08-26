# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Deepin Device Manager"
HOMEPAGE="https://github.com/linuxdeepin/deepin-devicemanager"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE="debug"

RDEPEND="dev-qt/qtcore:5
		dev-qt/qtwidgets:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtxml:5
		net-print/cups
		net-libs/zeromq
		sys-apps/smartmontools
		sys-apps/dmidecode
		sys-apps/hwinfo
		sys-power/upower
		sys-apps/lshw
		sys-apps/util-linux
		"

DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.5.0:=
		>=dde-base/dtkgui-5.5.0:=
		>=dde-base/dde-qt-dbus-factory-5.0.16
		virtual/pkgconfig
		"

src_prepare() {
	sed -i 's|/etc/dbus-1|/usr/share/dbus-1|' \
		deepin-devicemanager-server/CMakeLists.txt || die
	sed -i '/const QString COMMUNITY_STR =/c\const QString COMMUNITY_STR = "Gentoo-DDE";' \
		deepin-devicemanager/src/MacroDefinition.h || die
	cmake_src_prepare
}

src_configure() {
	if use debug; then
		build_type=Debug
	else
		build_type=Release
	fi
	local mycmakeargs=(
		-DVERSION=${PV}
		-DCMAKE_BUILD_TYPE=${build_type}
	)
	cmake_src_configure
}

pkg_postinst() {
	elog "systemctl enable deepin-devicemanager-server.service"
}

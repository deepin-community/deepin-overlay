# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake gnome2-utils

DESCRIPTION="Deepin desktop environment - Launcher module"
HOMEPAGE="https://github.com/linuxdeepin/dde-launcher"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="dev-qt/qtsvg:5
		 dev-qt/qtx11extras:5
		 >=dde-base/deepin-menu-5.0.1
		 dde-base/dde-daemon
		 x11-misc/xdg-user-dirs
		 >=dde-base/deepin-desktop-schemas-5.5.0
		 x11-libs/gsettings-qt
	     "
DEPEND="${RDEPEND}
		x11-libs/xcb-util-wm
		x11-libs/libxcb
		>=dde-base/dtkwidget-5.5.2:=
		>=dde-base/dde-qt-dbus-factory-5.3.0.1:=
		"

src_configure() {
	local mycmakeargs=(
		-DWITHOUT_UNINSTALL_APP=1
		-DVERSION=${PV}
	)
	sed -i '/install(CODE "execute_process/d' CMakeLists.txt || die
	cmake_src_configure
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}

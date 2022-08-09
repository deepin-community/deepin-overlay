# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Deepin desktop environment - Dock module"
HOMEPAGE="https://github.com/linuxdeepin/dde-dock"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="dev-qt/qtsvg:5
		dev-qt/qtx11extras:5
		>=dde-base/deepin-menu-5.0.1
		>=dde-base/dde-daemon-5.9.0
		>=dde-base/dde-qt5integration-5.1.0
		dde-base/dde-control-center
		app-accessibility/onboard
		>=dde-base/dtkwidget-5.5.0:=
		"

DEPEND="${RDEPEND}
		virtual/pkgconfig
		x11-libs/xcb-util-image
		x11-libs/libxcb
		x11-libs/xcb-util-wm
		x11-libs/libXtst
		>=dde-base/dde-qt-dbus-factory-5.0.16
		x11-libs/gsettings-qt
		dev-libs/libdbusmenu-qt
	    "

src_prepare() {
	LIBDIR=$(get_libdir)
	sed -i "s|lib/|${LIBDIR}/|g" plugins/*/CMakeLists.txt
	sed -i "s|/usr/lib/|/usr/${LIBDIR}/|g" \
		plugins/show-desktop/showdesktopplugin.cpp \
		frame/controller/dockpluginscontroller.cpp \
		plugins/tray/system-trays/systemtrayscontroller.cpp || die
	local mycmakeargs=(
		-DDOCK_TRAY_USE_NATIVE_POPUP=YES
	)
	cmake_src_prepare
}

# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Deepin desktop environment - Session Shell module"
HOMEPAGE="https://github.com/linuxdeepin/dde-session-shell"
if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
else
	SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="systemd elogind"
REQUIRED_USE="^^ ( systemd elogind )"

RDEPEND="
		 x11-libs/gsettings-qt
		 x11-misc/lightdm[qt5]
		 x11-libs/libXext
		 x11-libs/libXtst
		 x11-libs/libX11
		 x11-libs/libXcursor
		 x11-libs/libXfixes
		 x11-apps/xrandr
		 dev-qt/qtcore:5
		 dev-qt/qtgui:5
		 dev-qt/qtdbus:5
		 dev-qt/qtx11extras:5
		 dev-qt/qtwidgets:5
		 dev-qt/qtsvg:5
		 dev-qt/qtxml:5
		 >=dde-base/dde-daemon-5.9.0[systemd?,elogind?]
		 >=dde-base/deepin-desktop-schemas-5.4.0
		 >=dde-base/startdde-5.2.1
		"
DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.5.0:=
		>=dde-base/deepin-gettext-tools-1.0.6
		>=dde-base/dde-qt-dbus-factory-5.2.0.4:=
		virtual/pkgconfig
		"

src_prepare() {
	# fix cannot auth
	sed -i 's|common-auth|system-auth|' \
		src/libdde-auth/deepinauthframework.cpp|| die

	LIBDIR=$(get_libdir)
	sed -i "s|lib/deepin-daemon|${LIBDIR}/deepin-daemon|g" \
		scripts/lightdm-deepin-greeter || die

	sed -i "s|FILES\ files\/deepin-greeter|PROGRAMS\ files\/deepin-greeter|g" \
		CMakeLists.txt || die

	sed -i '/install(CODE "execute_process/d' CMakeLists.txt || die

	sed -i 's/-Wl,--as-need//' CMakeLists.txt || die
	cmake_src_prepare
}

src_install() {
	cmake_src_install

	fperms 0755 /usr/bin/dde-lock
	fperms 0755 /usr/bin/lightdm-deepin-greeter
	fperms 0755 /usr/bin/deepin-greeter
}

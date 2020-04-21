# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="Deepin desktop environment - Session Shell module"
HOMEPAGE="https://github.com/linuxdeepin/dde-session-shell"
if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
else
	SRC_URI="https://community-packages.deepin.com/deepin/pool/main/d/${PN}/${PN}_${PV}+c2.orig.tar.xz -> ${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
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
		 >=dde-base/dde-daemon-5.9.5[systemd?,elogind?]
		 >=dde-base/deepin-desktop-schemas-5.4.9
		 >=dde-base/startdde-5.2.1
		"
DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.1.2:=
		>=dde-base/deepin-gettext-tools-1.0.6
		>=dde-base/dde-qt-dbus-factory-1.1.5:=
		virtual/pkgconfig
		"

S="${WORKDIR}/${P}+c2"
PATCHES=(
	"${FILESDIR}/1.0.23-gen-moc.patch"
)

src_prepare() {

	LIBDIR=$(get_libdir)
	sed -i "s|lib/deepin-daemon|${LIBDIR}/deepin-daemon|g" scripts/lightdm-deepin-greeter

	sed -i "s|FILES\ files\/deepin-greeter|PROGRAMS\ files\/deepin-greeter|g" \
		CMakeLists.txt || die

	cmake-utils_src_prepare
}


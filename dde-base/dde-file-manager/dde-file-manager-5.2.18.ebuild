# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit qmake-utils xdg-utils systemd gnome2-utils

DESCRIPTION="Deepin File Manager and Desktop module for DDE"
HOMEPAGE="https://github.com/linuxdeepin/dde-file-manager"
if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
	EGIT_BRANCH="develop2.0"
else
	SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="samba avfs screensaver"

RDEPEND="sys-apps/file
		sys-fs/cryptsetup
		x11-libs/gsettings-qt
		dev-qt/qtcore:5
		dev-qt/qtgui:5[jpeg]
		dev-qt/qtwidgets:5
		dev-qt/qtdbus:5
		dev-qt/qtsvg:5
		dev-qt/qtx11extras:5
		dev-qt/qtconcurrent:5
		dev-qt/qtmultimedia:5[widgets]
		dev-qt/qtdeclarative:5
		dev-qt/gio-qt
		dev-cpp/lucene++
		dev-cpp/htmlcxx
		dev-libs/mimetic
		gnome-extra/libgsf
		sys-auth/polkit-qt[qt5(+)]
		app-crypt/libsecret
		>=dev-libs/disomaster-0.2.0
		x11-libs/libxcb
		x11-base/xorg-proto
		x11-libs/xcb-util
		x11-libs/xcb-util-wm
		>=dde-base/udisks2-qt5-5.0.3
		app-text/poppler
		media-video/ffmpegthumbnailer[png]
		media-libs/taglib
		media-libs/libmediainfo
		media-video/deepin-movie-reborn
		dde-extra/deepin-shortcut-viewer
		kde-frameworks/kcodecs:5
		net-misc/socat
		>=dde-base/dde-dock-5.0.27:=
		>=dde-base/dde-qt-dbus-factory-5.0.16
		>=dde-base/dde-qt5integration-5.1.0
		>=dde-base/dtkwidget-5.1.2:=
		screensaver? ( dde-extra/deepin-screensaver )
		samba? ( net-fs/samba )
		avfs? ( sys-fs/avfs )
		"
DEPEND="${RDEPEND}
		dev-libs/jemalloc
		dde-base/deepin-anything
		dde-base/deepin-gettext-tools
		"
# PATCHES=(                          
#     "${FILESDIR}"/5.1.0-disable-screensaver.patch
# )

src_prepare() {
	sed -i "s|\ systemd_service||g" src/dde-file-manager-daemon/dde-file-manager-daemon.pro

	LIBDIR=$(get_libdir)
	sed -i "s|{PREFIX}/lib/|{PREFIX}/${LIBDIR}/|g" src/dde-dock-plugins/disk-mount/disk-mount.pro
	sed -i "s|/usr/lib/|/usr/${LIBDIR}/|g" \
		src/dde-file-manager-lib/gvfs/networkmanager.cpp \
		src/dde-file-manager-lib/shutil/fileutils.cpp \
		src/dde-desktop/main.cpp \
		src/dde-zone/mainwindow.h || die
	export QT_SELECT=qt5
	eqmake5 PREFIX=/usr VERSION=${PV} DEFINES+="VERSION=${PV} OF=_Z_OF" LIB_INSTALL_DIR=/usr/$(get_libdir) DISABLE_SCREENSAVER=$(use screensaver || echo YES) filemanager.pro || die
	default_src_prepare
}

src_install() {
		systemd_dounit ${S}/src/dde-file-manager-daemon/dbusservice/dde-filemanager-daemon.service

		emake INSTALL_ROOT=${D} install

		dobin ${FILESDIR}/dfmterm
		dobin ${FILESDIR}/x-terminal-emulator
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_schemas_update
	einfo "${PN} needs x-terminal-emulator command to make OpenInTermial"
	einfo "function work. A command dfmterm is added to generate it. For"
	einfo "example, use 'dfmterm xterm' to set xterm as the terminal when"
	einfo "click 'Open In Terminal'"
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_schemas_update
}

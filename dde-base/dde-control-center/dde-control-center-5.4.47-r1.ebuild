# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit cmake-utils gnome2-utils

DESCRIPTION="Control Center of Deepin Desktop Environment"
HOMEPAGE="https://github.com/linuxdeepin/dde-control-center"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-3"
SLOT="0"
IUSE="systemd redshift"

RDEPEND="dev-qt/qtsvg:5
		dev-qt/qtsql:5
		dev-qt/qtx11extras:5
		dev-qt/qtdeclarative:5
		dev-qt/qtmultimedia:5
		dev-qt/qtconcurrent:5
		dev-qt/qtnetwork:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-libs/libqtxdg
		kde-frameworks/networkmanager-qt
		x11-libs/startup-notification
		>=dde-base/dde-daemon-5.9.0
		>=dde-base/dde-api-5.1.1
		dde-base/dde-account-faces
		>=dde-base/dde-dock-5.0.27
		>=dde-base/startdde-5.2.1
		>=dde-base/dde-network-utils-5.0.4
		dev-util/desktop-file-utils
		dev-libs/geoip
		dev-libs/libpwquality
		>=dde-base/deepin-desktop-base-2020.04.12
		>=dde-base/dde-qt5integration-5.1.0
		redshift? ( x11-misc/redshift )
		!systemd? ( app-admin/openrc-settingsd )
		dde-base/deepin-pw-check
		"
DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.2.2.2:=
		>=dde-base/dde-qt-dbus-factory-5.2.0.1:=
		"

src_prepare() {
	# remove after they obey -DDISABLE_SYS_UPDATE properly
	sed -i '/new UpdateModule/i#ifndef DISABLE_SYS_UPDATE' src/frame/window/mainwindow.cpp || die
	sed -i '/new UpdateModule/a#endif' src/frame/window/mainwindow.cpp || die
	# remove end user license
	sed -i '/GSettingWatcher::instance()->insertState("endUserLicenseAgreement");/d' \
		src/frame/window/modules/systeminfo/systeminfomodule.cpp || die
	
	# fix qt error
	sed -i '/#include <QPointer>/i #include <QDBusMetaType>' src/frame/window/modules/network/connectioneditpage.h || die
	LIBDIR=$(get_libdir)
	sed -i "s|DESTINATION\ lib|DESTINATION\ ${LIBDIR}|g" \
		src/develop-tool/CMakeLists.txt \
		src/frame/CMakeLists.txt \
		src/reboot-reminder-dialog/CMakeLists.txt || die
	sed -i "s|/usr/lib/|/usr/${LIBDIR}/|g" \
		src/frame/modules/update/updatework.cpp || die

	sed -i '/execute_process(COMMAND glib-compile-schemas/d' CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DDISABLE_SYS_UPDATE_SOURCE_CHECK=YES
		-DDISABLE_SYS_UPDATE_MIRRORS=YES
		-DDISABLE_SYS_UPDATE=YES
		-DCVERSION=${PV}
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}

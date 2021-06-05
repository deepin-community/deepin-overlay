# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit cmake-utils gnome2-utils xdg-utils

DESCRIPTION="Deepin Disk and Partition Backup/Restore Tool"
HOMEPAGE="https://github.com/linuxdeepin/deepin-clone"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-qt/qtcore:5
		dev-qt/qtconcurrent:5
		dev-qt/qtgui:5 
		dev-qt/qtwidgets:5
		dev-qt/qtnetwork:5
		dev-qt/qtmultimedia:5[widgets]
		"

DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.4.16
		virtual/pkgconfig
	    "

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	# sed -i "/^MimeType=/d" app/deepin-clone.desktop
	# sed -i "/^NoDisplay=/d" app/deepin-clone.desktop
	local mycmakeargs=(
		-DVERSION=${PV}
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

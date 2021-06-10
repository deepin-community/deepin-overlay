# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit qmake-utils gnome2-utils

DESCRIPTION="A public project for building DTK Library"
HOMEPAGE="https://github.com/linuxdeepin/dtkcommon"

if [[ "${PV}" == *9999* ]] ; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
else
   	SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="GPL-3"
SLOT="0/${PV}"
IUSE=""

RDEPEND="dev-libs/glib:2
        virtual/pkgconfig
        dev-qt/qtcore:5
        dev-cpp/gtest
	    "
DEPEND="${RDEPEND}"

src_prepare() {
	CORE_VERSION=$(echo ${PV}| awk -F'.' '{print $1"."$2}')
	LIBDIR=$(get_libdir)
    sed -i "/^prf.path/cprf.path = /usr/$LIBDIR/qt5/mkspecs/features" dtkcommon.pro || die
    sed -i "/^cmake_dtk.path/ccmake_dtk.path = /usr/$LIBDIR/cmake/Dtk" dtkcommon.pro || die
    sed -i "/^dtkcommon_module.path/cdtkcommon_module.path = /usr/$LIBDIR/qt5/mkspecs/modules" dtkcommon.pro || die
	sed -i 's|/etc/dbus-1|/usr/share/dbus-1|' dtkcommon.pro || die
	QT_SELECT=qt5 eqmake5 PREFIX=/usr LIB_INSTALL_DIR=/usr/$(get_libdir) VERSION=${CORE_VERSION}
	default_src_prepare
}

src_install() {
	emake INSTALL_ROOT=${D} install
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}

# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit qmake-utils

DESCRIPTION="Deepin Toolkit - Gui modules for DDE look and feel"
HOMEPAGE="https://github.com/linuxdeepin/dtkgui"

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

RDEPEND="dev-qt/qtgui:5
		"
DEPEND="${RDEPEND}
		>=dde-base/dtkcore-5.4:=
		"

src_prepare() {
	CORE_VERSION=$(echo ${PV}| awk -F'.' '{print $1"."$2}')
	# Patch out 5.5 suffix. The version number in dtkcore & friends never matched their tags,
	# and current version of dde-session-shell requires 5.5 explicitly. Let's make qmake and
	# cmake happy while upstream didn't react on this matter.
	find . -name '*.pro' -exec sed -i 's/dtkcore5.5/dtkcore/g;s/dtkgui5.5/dtkgui/g' {} \;
	QT_SELECT=qt5 eqmake5 PREFIX=/usr LIB_INSTALL_DIR=/usr/$(get_libdir) VERSION=${CORE_VERSION}
	default_src_prepare
}

src_install() {
	emake INSTALL_ROOT=${D} install
}

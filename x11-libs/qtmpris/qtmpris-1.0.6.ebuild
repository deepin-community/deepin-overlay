# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit qmake-utils gnome2-utils

DESCRIPTION="Qt and QML MPRIS interface and adaptor"
HOMEPAGE="https://git.sailfishos.org/mer-core/qtmpris"
# https://git.sailfishos.org/mer-core/qtmpris/-/archive/1.0.6/qtmpris-1.0.6.tar.gz
if [[ "${PV}" == *9999* ]] ; then
     inherit git-r3
     EGIT_REPO_URI="https://git.sailfishos.org/mer-core/${PN}.git"
else
     SRC_URI="https://git.sailfishos.org/mer-core/${PN}/-/archive/${PV}/${PN}-${PV}.tar.gz -> ${P}.tar.gz"
	 KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
		dev-qt/qtdeclarative:5
		"
DEPEND="${RDEPEND}"


src_prepare() {
	export QT_SELECT=qt5
	eqmake5 PREFIX=/usr
	default_src_prepare
}

src_install() {
	emake INSTALL_ROOT=${D} install
}

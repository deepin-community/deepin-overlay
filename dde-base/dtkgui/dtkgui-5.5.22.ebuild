# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Deepin Toolkit - Gui modules for DDE look and feel"
HOMEPAGE="https://github.com/linuxdeepin/dtkgui"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
else
	SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
fi
LICENSE="GPL-3"
SLOT="0/${PV}"
IUSE=""

RDEPEND="dev-qt/qtgui:5
		"
DEPEND="${RDEPEND}
		>=dde-base/dtkcore-5.5:=
		"

src_prepare() {
	CORE_VERSION=$(echo ${PV}| awk -F'.' '{print $1"."$2"')
	QT_SELECT=qt5 eqmake5 PREFIX=/usr LIB_INSTALL_DIR=/usr/$(get_libdir) VERSION=${CORE_VERSION}
	default_src_prepare
}

src_install() {
	emake INSTALL_ROOT=${D} install
}

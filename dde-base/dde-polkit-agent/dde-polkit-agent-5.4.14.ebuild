# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="PolicyKit agent for DDE"
HOMEPAGE="https://github.com/linuxdeepin/dde-polkit-agent"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtdbus:5
		dev-qt/qtwidgets:5
		sys-auth/polkit-qt[qt5(+)]
		"
DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.5.0:=
		"

src_prepare() {
	LIBDIR=$(get_libdir)
	# https://github.com/linuxdeepin/developer-center/issues/1721
	sed -i 's/bool is_deepin = true/bool is_deepin = false/' policykitlistener.cpp || die
	# https://github.com/linuxdeepin/dde-polkit-agent/issues/26
	sed -i '/setCancel/d' policykitlistener.cpp || die
	sed -i "s|/usr/lib/|/usr/${LIBDIR}/|g" \
		polkit-dde-authentication-agent-1.desktop \
		pluginmanager.cpp \
		${PN}.pro || die
	QT_SELECT=qt5 eqmake5 PREFIX=/usr
	default_src_prepare
}

src_install() {
	emake INSTALL_ROOT=${D} install
}

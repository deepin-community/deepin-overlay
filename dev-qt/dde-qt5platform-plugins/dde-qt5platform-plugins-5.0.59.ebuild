# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit qmake-utils

DESCRIPTION="XCB Qt5 platform plugin for DDE"
HOMEPAGE="https://github.com/linuxdeepin/qt5platform-plugins"
MY_PN=${PN#*-}
MY_P=${MY_PN}-${PV}

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linuxdeepin/${MY_PN}.git"
else
	SRC_URI="https://github.com/linuxdeepin/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
	S=${WORKDIR}/${MY_P}
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtdbus:5
	dev-qt/qtx11extras:5
	dev-qt/qtmultimedia:5[widgets]
	dev-qt/qtsvg:5
	dev-qt/qtopengl
	dev-qt/qtxcb-private-headers:5=
	dev-libs/dde-wayland
	kde-frameworks/kwayland
	x11-libs/libxcb[xkb]
	x11-libs/xcb-util-renderutil
	x11-libs/xcb-util-image
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-keysyms
	"

DEPEND="${RDEPEND}
	app-portage/portage-utils
	"

src_prepare() {
	rm -r xcb/libqt5xcbqpa-dev wayland/qtwayland-dev
	# Disable wayland for now: https://github.com/linuxdeepin/qt5platform-plugins/issues/47
	sed -i '/wayland/d' ${MY_PN}.pro

	sed -i 's/active\ =\ VtableHook::overrideVfptrFun.*/active\ =\ 1;/' xcb/dhighdpi.cpp || die
	private_header=$(q list qtxcb-private-headers | head -n 1 | xargs dirname)
	sed -i "s|error(Not support Qt Version: .*)|INCLUDEPATH += ${private_header} |" xcb/linux.pri
	QT_SELECT=qt5 eqmake5 ${MY_PN}.pro
	default_src_prepare
}

src_install() {
	emake INSTALL_ROOT=${D} install
}

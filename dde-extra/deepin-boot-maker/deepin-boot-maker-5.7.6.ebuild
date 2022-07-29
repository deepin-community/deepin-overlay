# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )

inherit qmake-utils python-any-r1

DESCRIPTION="A Tool to create a bootable usb stick quick and easy"
HOMEPAGE="https://github.com/linuxdeepin/deepin-boot-maker"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

RDEPEND="dev-qt/qtcore:5
		dev-qt/qtconcurrent:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtnetwork:5
		dev-qt/qtmultimedia:5[widgets]
		dev-qt/qtsvg:5
		dev-qt/qtdbus:5
		dev-qt/qtx11extras:5
		x11-libs/libxcb
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/xcb-util
		x11-libs/startup-notification
		app-arch/p7zip
		sys-fs/mtools
		amd64? ( sys-boot/syslinux )
		"

DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.5.0:=
		virtual/pkgconfig
		dev-lang/python
		"

src_prepare() {
	eapply_user
	LIBDIR=$(get_libdir)
	sed -i "s|{PREFIX}/lib/|{PREFIX}/${LIBDIR}/|g" src/vendor/src/libxsys/libxsys.pro src/service/service.pro || die
	sed -i "s|/usr/lib|/usr/${LIBDIR}|g" src/libdbm/libdbm.pro src/service/data/com.deepin.bootmaker.service || die
	export QT_SELECT=qt5
	eqmake5 PREFIX=/usr DEFINES+="VERSION=${PV}"
}

src_install() {
	emake INSTALL_ROOT=${D} install
}

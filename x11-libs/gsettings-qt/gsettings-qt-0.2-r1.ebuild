# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Qml bindings for GSettings."
HOMEPAGE="https://gitlab.com/ubports/development/core/gsettings-qt"
SRC_URI="https://gitlab.com/ubports/development/core/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
RESTRICT="!test? ( test )"
IUSE="test"

DEPEND="dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	test? ( dev-qt/qttest:5 )"

S=${WORKDIR}/${PN}-v${PV}

#unset QT_QPA_PLATFORMTHEME
#MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	default
	# Fix relocation error when rebuild with different Qt version
	#sed -i 's|LD_PRELOAD=../src/libgsettings-qt.so.1|LD_PRELOAD=../src/libgsettings-qt.so.1\:./libGSettingsQmlPlugin.so|g' ${S}/GSettings/gsettings-qt.pro

	# Don't pre-strip
	#echo "CONFIG+=nostrip" >> "${S}"/GSettings/gsettings-qt.pro
	#echo "CONFIG+=nostrip" >> "${S}"/src/gsettings-qt.pro
	#echo "CONFIG+=nostrip" >> "${S}"/tests/tests.pro

	#use test || \
		sed -e 's:tests/tests.pro tests/cpptest.pro::g' \
			-i "${S}"/gsettings-qt.pro
}

src_configure() {
	QT_SELECT=qt5 eqmake5
}

src_install () {
	emake INSTALL_ROOT="${ED}" install
}

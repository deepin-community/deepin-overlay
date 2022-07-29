# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Base components for Deepin Desktop"
HOMEPAGE="https://github.com/linuxdeepin/deepin-desktop-base"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

DEPEND="dde-base/deepin-wallpapers
		>=dde-base/deepin-icon-theme-2020.04.13
		dde-base/deepin-gtk-theme
		dde-base/deepin-sound-theme"

src_prepare() {
	LIBDIR=$(get_libdir)
	sed -i "s|/usr/lib/|/usr/${LIBDIR}/|g" Makefile || die
	sed -i 's|$(shell uname -m)|x86_64|g' Makefile || die
	default_src_prepare
}

src_install() {
	emake DESTDIR=${D} install
	install -Dm644 files/os-version ${D}/etc/os-version
	rm -r ${D}/etc/appstore.json ${D}/etc/lsb-release ${D}/etc/systemd ${D}/usr/share/python-apt

	insinto /usr/share/deepin
	doins -r distribution distribution.info

	dosym /usr/$(get_libdir)/deepin/desktop-version /etc/deepin-version
}

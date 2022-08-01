# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Deepin User Manual"
HOMEPAGE="https://github.com/linuxdeepin/deepin-manual"
if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
else
	SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
fi

LICENSE="GPL-3+"
SLOT="2"
IUSE=""

DEPEND="dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtwebengine:5[widgets]
		dev-qt/linguist-tools:5
		dde-base/dde-qt5integration
		>=dde-base/dtkwidget-5.5.0:=
		dde-base/dtkgui
		virtual/pkgconfig
	    "

src_prepare() {
	sed -i "/Painter>/a#include <QPainterPath>" \
		src/view/widget/search_button.cpp \
		src/view/widget/search_completion_window.cpp || die
	sed -i "/include </a#include <QPainterPath>" \
		src/view/widget/search_completion_delegate.cpp || die

	cp src/resources/themes/common/images/deepin-manual.svg manual-assets/deepin-manual.svg

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DVERSION=${PV}
		-DCMAKE_BUILD_TYPE=Release
	)

	cmake_src_configure
}

src_install() {
	${BUILD_DIR}/src/generate-search-db
	cmake_src_install
}

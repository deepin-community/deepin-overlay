# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit cmake-utils

DESCRIPTION="Deepin Terminal"
HOMEPAGE="https://github.com/linuxdeepin/deepin-terminal"
if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
else
	SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtconcurrent:5
	>=dde-base/dtkcore-5.1.2
	dde-base/dtkgui
	!dde-extra/deepin-terminal-old
	"
DEPEND="${RDEPEND}
	dev-cpp/gtest
	dev-util/lxqt-build-tools
	>=dde-base/dtkwidget-5.1.2:=
	virtual/pkgconfig
	app-portage/gentoolkit
	"

src_prepare() {
	# ninja: error: '/build/deepin-terminal/src/deepin-terminal-5.4.0.6/default-config.json', needed by '/build/deepin-terminal/src/deepin-terminal-5.4.0.6/settings_translation.cpp', missing and no known rule to make it
  	sed -i 's|default-config.json|src/assets/other/default-config.json|' CMakeLists.txt

  	# ‘QString& QString::operator=(const char*)’ is private within this context
  	sed -i '/LXQtCompilerSettings/a remove_definitions(-DQT_NO_CAST_FROM_ASCII -DQT_NO_CAST_TO_ASCII)' 3rdparty/terminalwidget/CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DVERSION=${PV}
		-DDTKCORE_TOOL_DIR=/usr/lib/libdtk-$(equery w dtkcore | sed 's/.*dtkcore-\(.*\).ebuild$/\1/' | awk -F'-' '{ print $1 }' | awk -F'.' '{print $1"."$2".0"}')/DCore/bin
	)
	cmake-utils_src_configure
}

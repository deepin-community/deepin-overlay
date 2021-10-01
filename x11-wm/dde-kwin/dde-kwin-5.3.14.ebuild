# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="KWin configures on DDE"
HOMEPAGE="https://github.com/linuxdeepin/dde-kwin"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
elif [[ "${PV}" == *5.3.19* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://hub.fastgit.org/linuxdeepin/${PN}.git"
	EGIT_COMMIT="5deecde5a8facff76a50006484278671bbadedda"
	KEYWORDS="~amd64 ~x86"
else
	SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi


LICENSE="GPL-3"
SLOT="0"
IUSE="debug"

RDEPEND="x11-libs/gsettings-qt
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtdbus:5
		dev-qt/qtx11extras:5
		kde-frameworks/kconfig:5
		kde-frameworks/kcoreaddons:5
		kde-frameworks/kwindowsystem:5
		kde-frameworks/kglobalaccel:5
		x11-libs/libxcb
		media-libs/fontconfig
		media-libs/freetype
		dev-libs/glib
		x11-libs/libXrender
		sys-libs/mtdev
		kde-plasma/kwin:5
		dde-base/dde-qt5integration
		>=dde-base/dtkcore-5.4.0
		"
DEPEND="${RDEPEND}
		app-portage/gentoolkit
		"

PATCHES=(
	"${FILESDIR}"/rename_thumbnail_grid.patch
	"${FILESDIR}"/deepin-kwin-crash.patch
)

src_prepare() {
	LIBDIR=$(get_libdir)
	sed -i "s|/usr/lib/|/usr/${LIBDIR}/|g" deepin-wm-dbus/deepinwmfaker.cpp || die
	find . | grep CMakeLists.txt | xargs -n 1 sed -i '/cmake_minimum_required/d'
	find . | grep CMakeLists.txt | xargs -n 1 sed -i '1 icmake_minimum_required(VERSION 3.21)\n'
	sed -i 's/kwin-xcb)/PUBLIC kwin-xcb)/' plugins/kdecoration/CMakeLists.txt || die
	sed -i 's/kwin-xcb)/PUBLIC kwin-xcb)/' plugins/kwineffects/scissor-window/CMakeLists.txt || die
	sed -i '/-DPROJECT_NAME=/c-DPROJECT_NAME=\"${PROJECT_NAME}\"' CMakeLists.txt || die
	sed -i '/-DPROJECT_VERSION=/c-DPROJECT_VERSION=\"${PROJECT_VERSION}\"' CMakeLists.txt || die
	sed -i '/add_definitions(-DTARGET_NAME=/cadd_definitions(-DTARGET_NAME="${TARGET_NAME}")' plugins/kdecoration/CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	if use debug; then
		build_type=Debug
	else
		build_type=RelWithDebInfo
	fi
	local mycmakeargs=(
		-DPROJECT_VERSION=${PV}
		-DKWIN_VERSION=$(equery w kwin | sed 's/.*kwin-\(.*\).ebuild$/\1/' | awk -F'-' '{ print $1 }')
		-DCMAKE_BUILD_TYPE=${build_type}
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	fperms 755 /usr/bin/kwin_no_scale
}

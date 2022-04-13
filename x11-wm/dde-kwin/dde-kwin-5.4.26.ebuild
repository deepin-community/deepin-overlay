# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="KWin configures on DDE"
HOMEPAGE="https://github.com/linuxdeepin/dde-kwin"

DDE_KWIN_PATCH="https://raw.githubusercontent.com/archlinux/svntogit-community/packages/deepin-kwin/trunk/dde-kwin.5.4.26.patch"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
else
	SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
			$DDE_KWIN_PATCH"
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
	"${DISTDIR}"/dde-kwin.5.4.26.patch
	"${FILESDIR}"/tabbox-chameleon-rename.patch
)

src_prepare() {
	LIBDIR=$(get_libdir)
	sed -i "s|/usr/lib/|/usr/${LIBDIR}/|g" deepin-wm-dbus/deepinwmfaker.cpp || die
#	sed -i 's/kwin-xcb)/PUBLIC kwin-xcb)/' plugins/kdecoration/CMakeLists.txt || die
#	sed -i 's/kwin-xcb)/PUBLIC kwin-xcb)/' plugins/kwineffects/scissor-window/CMakeLists.txt || die
#  sed -i '/-DPROJECT_NAME=/c-DPROJECT_NAME=\"${PROJECT_NAME}\"' CMakeLists.txt || die
#  sed -i '/-DPROJECT_VERSION=/c-DPROJECT_VERSION=\"${PROJECT_VERSION}\"' CMakeLists.txt || die
#  sed -i '/-DKWIN_VERSION_STR=/c-DKWIN_VERSION_STR=\"${KWIN_VERSION}\"' CMakeLists.txt || die
#  sed -i '/add_definitions(-DTARGET_NAME=/cadd_definitions(-DTARGET_NAME="${TARGET_NAME}")' plugins/kdecoration/CMakeLists.txt || die

	sed -i 's|/usr/share/backgrounds/default_background.jpg|/usr/share/backgrounds/deepin/desktop.jpg|' plugins/kwineffects/multitasking/background.cpp || die
	cmake_src_prepare
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
		-DUSE_WINDOW_TOOL=OFF
		-DENABLE_BUILTIN_BLUR=OFF
		-DENABLE_KDECORATION=OFF
		-DENABLE_BUILTIN_MULTITASKING=OFF
		-DENABLE_BUILTIN_BLACK_SCREEN=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	fperms 755 /usr/bin/kwin_no_scale
}

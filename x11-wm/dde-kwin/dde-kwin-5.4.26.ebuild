# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="KWin configures on DDE"
HOMEPAGE="https://github.com/linuxdeepin/dde-kwin"

DDE_KWIN_PATCH="https://raw.githubusercontent.com/archlinux/svntogit-community/6569e8f227a739b625164cbc549b1b54b2b7812c/trunk/dde-kwin.5.4.26.patch"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
else
	SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
					${DDE_KWIN_PATCH} -> dde-kwin-5.4.26-fix-build.patch"
	KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

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
	"${DISTDIR}"/dde-kwin-5.4.26-fix-build.patch
	"${FILESDIR}"/tabbox-chameleon-rename.patch
)

src_prepare() {
	LIBDIR=$(get_libdir)
	sed -i "s|/usr/lib/|/usr/${LIBDIR}/|g" deepin-wm-dbus/deepinwmfaker.cpp || die
	sed -i 's|/usr/share/backgrounds/default_background.jpg|/usr/share/backgrounds/deepin/desktop.jpg|' plugins/kwineffects/multitasking/background.cpp || die
	cmake_src_prepare
}

src_configure() {
	sed -i 's/kwin 5.21.5/kwin 5.24.4/' configures/kwin_no_scale.in
	# Fix kwin 5.25
	sed -i 's|LanczosCacheRole|WindowBackgroundContrastRole|g' \
		plugins/kwineffects/scissor-window/scissorwindow.h \
		plugins/kwineffects/scissor-window/scissorwindow.cpp \
		plugins/kdecoration/chameleonconfig.h || die
	sed -i 's|GLRenderTarget|GLFramebuffer|g' plugins/kwineffects/scissor-window/scissorwindow.cpp || die
	sed -i '/(!w->isPaintingEnabled() || (mask & PAINT_WINDOW_LANCZOS)/,+2d' plugins/kwineffects/scissor-window/scissorwindow.cpp || die

	# Fix kdecoration plugins
	sed -i 's/CONFIG REQUIRED COMPONENTS Core/COMPONENTS Core Widgets REQUIRED/' plugins/kdecoration/CMakeLists.txt || die
	sed -i '/add_subdirectory(kdecoration)/d' plugins/CMakeLists.txt || die

	local mycmakeargs=(
		-DPROJECT_VERSION=${PV}
		-DKWIN_VERSION=$(equery w kwin | sed 's/.*kwin-\(.*\).ebuild$/\1/' | awk -F'-' '{ print $1 }')
		-DUSE_WINDOW_TOOL=OFF
		-DENABLE_BUILTIN_BLUR=OFF
		-DENABLE_KDECORATION=OFF
		-DENABLE_BUILTIN_MULTITASKING=OFF
		-DENABLE_BUILTIN_BLACK_SCREEN=OFF
		-DUSE_DEEPIN_WAYLAND=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	fperms 755 /usr/bin/kwin_no_scale
}

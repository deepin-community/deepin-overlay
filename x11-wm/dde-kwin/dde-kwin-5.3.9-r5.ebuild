# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit cmake-utils

DESCRIPTION="KWin configures on DDE"
HOMEPAGE="https://github.com/linuxdeepin/dde-kwin"

if [[ "${PV}" == *9999* ]] ; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
elif [[ "${PV}" == *5.3.14* ]] ; then
	inherit git-r3
    EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
	EGIT_COMMIT="8f68adda0c05dbe81f5ccc06d0bcb704efb3836e"
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
		>=dde-base/dtkcore-2.0.9
		"
DEPEND="${RDEPEND}
		"

PATCHES=(                          
    "${FILESDIR}"/deepin-kwin-crash.patch
	"${FILESDIR}"/rename_thumbnail_grid.patch
)

src_prepare() {
	LIBDIR=$(get_libdir)
	sed -i "s|/usr/lib/|/usr/${LIBDIR}/|g" deepin-wm-dbus/deepinwmfaker.cpp || die

	# fix: Crashing when open multitasking view
	# sed -i "/m_multitaskingModel->deleteLater();/d" \
	# 	plugins/kwineffects/multitasking/multitasking.cpp || die
	# sed -i "s/m_thumbManager->deleteLater();/m_multitaskingView->deleteLater();\nm_multitaskingModel->deleteLater();\nm_thumbManager->deleteLater();\n/" \
	# 	plugins/kwineffects/multitasking/multitasking.cpp || die

	# sed -i '570/d' \
	# 	plugins/kwineffects/multitasking/windowthumbnail.cpp
	# sed -i '570 i\auto *context = glXGetCurrentContext();' \
	# 	plugins/kwineffects/multitasking/windowthumbnail.cpp
	# sed -i 's/auto \*context = window()->openglContext();/auto\* context = new QOpenGLContext();\n/g'\
	# 	plugins/kwineffects/multitasking/windowthumbnail.cpp || die
	
	# sed -i 's/window()->openglContext()/QOpenGLContext::globalShareContext()/g' \
	# 	plugins/kwineffects/multitasking/windowthumbnail.cpp
	# sed -i 's/set(HAVE_GLX ${HAVE_X11})/set(HAVE_GLX 0)/' \
	# 	plugins/kwineffects/multitasking/CMakeLists.txt
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
		-DCMAKE_BUILD_TYPE=${build_type}
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	fperms 755 /usr/bin/kwin_no_scale
}

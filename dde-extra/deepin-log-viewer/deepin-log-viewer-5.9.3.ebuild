# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Deepin Log Viewer"
HOMEPAGE="https://github.com/linuxdeepin/deepin-log-viewer"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE="elogind systemd"
REQUIRED_USE="^^ ( systemd elogind )"

RDEPEND="dev-qt/qtcore:5
		dev-qt/qtwidgets:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtx11extras:5
		dev-qt/qtdbus:5
		dev-qt/qtsvg:5
		dev-libs/rapidjson
		dev-libs/xerces-c
		"

DEPEND="${RDEPEND}
		>=dde-base/dtkwidget-5.5.0:=
		dev-qt/linguist-tools
		virtual/pkgconfig
		"

src_prepare() {
	LIBDIR=$(get_libdir)
	sed -i "s|lib/deepin-daemon/|${LIBDIR}/deepin-daemon/|g" logViewerService/CMakeLists.txt

	sed -i "/<QPainter>/a\#include\ <QPainterPath>" \
		application/logperiodbutton.cpp || die
	sed -i "/<QDebug>/a\#include\ <QPainterPath>" \
		application/displaycontent.cpp \
		application/logtreeview.cpp \
		application/logviewheaderview.cpp \
		application/logviewitemdelegate.cpp \
		application/logdetailinfowidget.cpp \
		application/filtercontent.cpp || die

	if use elogind && ! use systemd ; then
		sed -i "s/-lsystemd/-lelogind/" \
			application/CMakeLists.txt || die
		sed -i "s|systemd/|elogind/systemd/|" \
			application/journalwork.h || die
	fi

	sed -i '1 i\#define OF(args)  args' 3rdparty/minizip/zip.h
	sed -i '1 i\#define OF(args)  args' 3rdparty/minizip/unzip.h
	sed -i '1 i\#define OF(args)  args' 3rdparty/minizip/ioapi.h
	sed -i '1 i\#define OF(args)  args' 3rdparty/libxlsxwriter/include/xlsxwriter/third_party/zip.h
	sed -i 's#stub.set(ADDR(QThreadPool, start)#stub.set(static_cast<void (QThreadPool::*)(QRunnable*, int)>(ADDR(QThreadPool, start))#g' \
		tests/src/displaycontent_test.cpp
	sed -i 's#stub.set(ADDR(QThreadPool, start)#stub.set(static_cast<void (QThreadPool::*)(QRunnable*, int)>(ADDR(QThreadPool, start))#g' \
		tests/src/logfileparser_test.cpp

	# Fix mold
	sed -i "s/as-need/as-needed/" application/CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DVERSION=${PV}
	)
	cmake_src_configure
}

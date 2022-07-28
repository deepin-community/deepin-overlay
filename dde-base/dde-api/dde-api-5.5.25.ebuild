# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/linuxdeepin/dde-api"
EGO_VENDOR=(
"golang.org/x/image f315e440302883054d0c2bd85486878cb4f8572c github.com/golang/image"
"golang.org/x/net aaf60122140d3fcf75376d319f0554393160eb50 github.com/golang/net"
"gopkg.in/alecthomas/kingpin.v2 947dcec5ba9c011838740e680966fd7087a71d0d github.com/alecthomas/kingpin"
"github.com/alecthomas/units 2efee857e7cfd4f3d0138cc3cbb1b4966962b93a"
"github.com/alecthomas/template a0175ee3bccc567396460bf5acd36800cb10c49c"
"github.com/cryptix/wav 8bdace674401f0bd3b63c65479b6a6ff1f9d5e44"
"github.com/fogleman/gg 0403632d5b905943a1c2a5b2763aaecd568467ec"
"github.com/golang/freetype e2365dfdc4a05e4b8299a783240d4a7d5a65d4e4"
"github.com/disintegration/imaging 5362c131d56305ce787e79a5b94ffc956df00d62"
"github.com/nfnt/resize 83c6a9932646f83e3267f353373d47347b6036b2"
"github.com/mattn/go-sqlite3 98a44bc"
"github.com/rickb777/date 2248ec4"
"github.com/rickb777/plural 7589705"
"github.com/gosexy/gettext 74466a0"
"github.com/godbus/dbus e0a146e"
"github.com/fsnotify/fsnotify 7f4cf4d"
"golang.org/x/sys cc9327a github.com/golang/sys"
"github.com/stretchr/testify acba37e"
"github.com/davecgh/go-spew 87df7c6"
"github.com/pmezard/go-difflib 792786c"
"github.com/stretchr/objx 35313a9"
"gopkg.in/yaml.v3 496545a github.com/go-yaml/yaml"
)

inherit golang-vcs-snapshot golang-build xdg-utils

DESCRIPTION="Go-lang bingdings for dde-daemon"
HOMEPAGE="https://github.com/linuxdeepin/dde-api"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
${EGO_VENDOR_URI}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

RDEPEND="x11-libs/libXi
		dev-libs/glib:2
		x11-libs/gtk+:3
		x11-libs/gdk-pixbuf:2
		x11-libs/gdk-pixbuf-xlib
		media-libs/libcanberra[pulseaudio]
		x11-libs/libXfixes
		|| ( net-wireless/rfkill
		>=sys-apps/util-linux-2.31 )
		app-text/poppler[cairo]
		x11-libs/libXcursor
		x11-apps/xcur2png
		gnome-base/librsvg:2
		media-gfx/blur-effect
		"

DEPEND="${RDEPEND}
		>=dev-go/deepin-go-lib-5.4.5
		>=dev-go/go-gir-generator-2.0.0
		dev-go/go-dbus-factory
		dev-go/go-x11-client
		dde-base/deepin-gettext-tools
		"

src_prepare() {
	cd ${S}/src/${EGO_PN}
	LIBDIR=$(get_libdir)
	sed -i "s|/usr/lib/|/usr/${LIBDIR}/|g" \
		misc/services/*.service \
		misc/system-services/*.service \
		misc/systemd/system/*.service \
		theme_thumb/gtk/gtk.go \
		thumbnails/gtk/gtk.go \
		lunar-calendar/main.go || die

	default_src_prepare
}
src_compile() {
	mkdir -p "${T}/golibdir/"
	cp -r  "${S}/src/${EGO_PN}/vendor"  "${T}/golibdir/src"

	rm -r "${S}/src/${EGO_PN}/vendor/github.com/godbus" || die

	export -n GOCACHE XDG_CACHE_HOME
	export GOPATH="${S}:${T}/golibdir/:$(get_golibdir)"
	cd ${S}/src/${EGO_PN}
	emake
}

src_install() {
	cd ${S}/src/${EGO_PN}
	emake DESTDIR=${D} libdir=/$(get_libdir) SYSTEMD_LIB_DIR=/lib GOSITE_DIR=$(get_golibdir) install
}

pkg_postinst() { xdg_icon_cache_update; }
pkg_postrm() { xdg_icon_cache_update; }

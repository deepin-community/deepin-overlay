# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="."
EGO_VENDOR=(
"github.com/godbus/dbus e0a146e"
"github.com/fsnotify/fsnotify 7f4cf4d"
"golang.org/x/sys 6c1b26c5 github.com/golang/sys"
"github.com/stretchr/testify acba37e"
"github.com/davecgh/go-spew 87df7c6"
"github.com/pmezard/go-difflib 792786c"
"github.com/stretchr/objx 35313a9"
"gopkg.in/yaml.v3 496545a github.com/go-yaml/yaml"
)

inherit golang-vcs-snapshot pam

DESCRIPTION="Provide password check for dde-control-center"
HOMEPAGE="https://github.com/linuxdeepin/deepin-pw-check"
SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
${EGO_VENDOR_URI}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

RDEPEND="
		virtual/libcrypt:=
		"

DEPEND="${RDEPEND}
		dde-base/deepin-gettext-tools
		dev-go/go-dbus-factory
		dev-libs/iniparser
		"

src_prepare() {
	cd ${S}/src/${EGO_PN}
	LIBDIR=$(get_libdir)
	sed -i "s|/usr/lib|/usr/${LIBDIR}|g" \
		misc/system-services/com.deepin.daemon.PasswdConf.service \
		misc/pkgconfig/libdeepin_pw_check.pc || die
	sed -i "s|0.0.0.1|${PN}|" misc/pkgconfig/libdeepin_pw_check.pc || die

	sed -i 's|iniparser/iniparser.h|iniparser4/iniparser.h|' tool/pwd_conf_update.c lib/deepin_pw_check.c || die
	sed -i 's|iniparser/dictionary.h|iniparser4/dictionary.h|' tool/pwd_conf_update.c lib/deepin_pw_check.c  || die
	sed -i 's|-liniparser|-liniparser4|' Makefile || die

	sed -i "s|{PREFIX}/lib|{PREFIX}/${LIBDIR}|" Makefile || die

	default_src_prepare
}

src_compile() {
	mkdir -p "${T}/golibdir/"
	cp -r  "${S}/src/${EGO_PN}/vendor"  "${T}/golibdir/src"
	rm -rf ${S}/src/${EGO_PN}/vendor
	export -n GOCACHE XDG_CACHE_HOME
	export GOPATH="${S}:$(get_golibdir):${T}/golibdir/"
	cd ${S}/src/${EGO_PN}
	emake all
	cd out
	ln -s libdeepin_pw_check.so libdeepin_pw_check.so.1
}

src_install() {
	cd ${S}/src/${EGO_PN}
	emake DESTDIR=${D} PKG_FILE_DIR=/usr/$(get_libdir)/pkgconfig PAM_MODULE_DIR=$(getpam_mod_dir) install
	#dosym /usr/$(get_libdir)/libdeepin_pw_check.so /usr/$(get_libdir)/libdeepin_pw_check.so.1
}

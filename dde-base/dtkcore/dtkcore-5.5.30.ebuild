# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils gnome2-utils

DESCRIPTION="Base development tool of all C++/Qt Developer work on Deepin - Core modules"
HOMEPAGE="https://github.com/linuxdeepin/dtkcore"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linuxdeepin/${PN}.git"
else
	SRC_URI="https://github.com/linuxdeepin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
fi

LICENSE="GPL-3"
SLOT="0/${PV}"
IUSE=""

RDEPEND=">=dev-qt/qtcore-5.15:5
		>=dev-qt/qtconcurrent-5.15:5
		dev-qt/qtdbus
		dev-qt/qttest
		x11-libs/gsettings-qt
		>=dde-base/dtkcommon-5.5
	    "
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-5.5.30-add-gentoo-define.patch
)

src_prepare() {
	LIBDIR=$(get_libdir)
	# sed -i "s|/lib/|/${LIBDIR}/|g" tools/settings/settings.pro || die
	sed -i "s/UosEdition ospt = UosEditionUnknown;/UosEdition ospt = UosCommunity;/" \
		src/dsysinfo.cpp || die
	CORE_VERSION=$(echo ${PV}| awk -F'.' '{print $1"."$2}')
	QT_SELECT=qt5 eqmake5 PREFIX=/usr LIB_INSTALL_DIR=/usr/$LIBDIR VERSION=${CORE_VERSION}
	default_src_prepare
}

src_install() {
	emake INSTALL_ROOT=${D} install
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}

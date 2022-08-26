# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Deepin Extra Applications (meta package)"
HOMEPAGE="https://www.deepin.org"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE="+calendar +boot +calculator +editor +font +picker +voice +compressor +reader +log +devicemanager +printer"

RDEPEND="
	calendar? ( dde-extra/dde-calendar )
	boot? ( dde-extra/deepin-boot-maker )
	calculator? ( dde-extra/deepin-calculator )
	editor? ( dde-extra/deepin-editor )
	font? ( dde-extra/deepin-font-manager )
	picker? ( dde-extra/deepin-picker )
	voice? ( dde-extra/deepin-voice-note )
	dde-extra/deepin-system-monitor
	compressor? ( dde-extra/deepin-compressor )
	reader? ( dde-extra/deepin-reader )
	log? ( dde-extra/deepin-log-viewer )
	devicemanager? ( dde-extra/deepin-devicemanager )
	printer? ( dde-extra/dde-printer )
	"

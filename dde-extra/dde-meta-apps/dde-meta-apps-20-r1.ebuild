# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

DESCRIPTION="Deepin Extra Applications (meta package)"
HOMEPAGE="https://www.deepin.org"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+calendar +boot +calculator +editor +font +picker +voice +topbar +compressor +reader +log +devicemanager +printer"

RDEPEND="
	calendar? ( dde-extra/dde-calendar )
	boot? ( dde-extra/deepin-boot-maker )
	calculator? ( dde-extra/deepin-calculator )
	editor? ( dde-extra/deepin-editor )
	font? ( dde-extra/deepin-font-manager )
	picker? ( dde-extra/deepin-picker )
	voice? (dde-extra/deepin-voice-note )
	dde-extra/deepin-system-monitor
	topbar? ( dde-extra/deepin-topbar )
	compressor? ( dde-extra/deepin-compressor )
	reader? ( dde-extra/deepin-reader )
	log? ( dde-extra/deepin-log-viewer )
	devicemanager? ( dde-extra/deepin-devicemanager )
	printer? ( dde-extra/dde-printer )
	"

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV#9999} != ${PV} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.linuxtv.org/dtv-scan-tables.git"
else
	COMMIT="57ed29822750"
	SRC_URI="https://linuxtv.org/downloads/dtv-scan-tables/dtv-scan-tables-${PV:3:4}-${PV:7:2}-${PV:9:2}-${COMMIT}.tar.bz2"
	KEYWORDS="amd64 arm arm64 ppc x86"
	S="${WORKDIR}/usr/share/dvb"
fi

DESCRIPTION="Digital TV scan tables in v3 and v5 format"
HOMEPAGE="https://linuxtv.org/"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"

BDEPEND="media-libs/libv4l[dvb,utils(-)]"

DOCS=( README )

src_compile() {
	emake dvbv3 dvbv5
}

src_install() {
	emake PREFIX="${ED}/usr" install install_v3
	einstalldocs
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Various desktop menu items and icons for wine"
HOMEPAGE="
	https://github.com/NP-Hardass/wine-desktop-common
	https://bazaar.launchpad.net/~ubuntu-wine/wine/ubuntu-debian-dir/files/head:/debian/
"
SRC_URI="
	https://github.com/NP-Hardass/${PN}/archive/${PV//./}.tar.gz
		-> ${P}.tar.gz
"
S=${WORKDIR}/${PN}-${PV//./}

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

PDEPEND="app-eselect/eselect-wine"

# These use a non-standard "Wine" category, which is provided by
# /etc/xdg/applications-merged/wine.menu
QA_DESKTOP_FILE="
	usr/share/applications/wine-browsedrive.desktop
	usr/share/applications/wine-notepad.desktop
	usr/share/applications/wine-uninstaller.desktop
	usr/share/applications/wine-winecfg.desktop
"

src_install() {
	emake install DESTDIR="${D}" EPREFIX="${EPREFIX}"
}

# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

declare -A GIT_CRATES=(
	[nusb]='https://github.com/kevinmehall/nusb;0fd3db60893ce7e49a217d1c868c2a3cab822249;nusb-%commit%'
)

inherit cargo

DESCRIPTION="List system USB buses and devices; a modern cross-platform \`lsusb\`"
HOMEPAGE="https://github.com/tuna-f1sh/cyme/"
SRC_URI="
	https://github.com/tuna-f1sh/cyme/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
	https://github.com/gentoo-crate-dist/cyme/releases/download/v${PV}/cyme-v${PV}-crates.tar.xz
"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+=" Apache-2.0 LGPL-2+ MIT MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED="/usr/bin/cyme"

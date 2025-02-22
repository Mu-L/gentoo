# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Manage multiple terminal buffers in Emacs"
HOMEPAGE="https://www.emacswiki.org/emacs/MultiTerm"
# Taken from http://www.emacswiki.org/emacs/download/${PN}.el
SRC_URI="https://dev.gentoo.org/~mjo/distfiles/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

SITEFILE="50${PN}-gentoo.el"

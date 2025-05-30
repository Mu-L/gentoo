# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Python bindings for wc(s)width"
HOMEPAGE="
	https://github.com/sebastinas/cwcwidth/
	https://pypi.org/project/cwcwidth/
"
SRC_URI="
	https://github.com/sebastinas/cwcwidth/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

BDEPEND="
	>=dev-python/cython-3[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

src_test() {
	cd tests || die
	distutils-r1_src_test
}

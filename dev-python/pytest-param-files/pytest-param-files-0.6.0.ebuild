# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1

DESCRIPTION="Pytest parametrize decorators from external files."
HOMEPAGE="
	https://github.com/chrisjsewell/pytest-param-files/
	https://pypi.org/project/pytest_param_files/
"
SRC_URI="
	https://github.com/chrisjsewell/pytest-param-files/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.15[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Django LDAP authentication backend"
HOMEPAGE="
	https://github.com/django-auth-ldap/django-auth-ldap/
	https://pypi.org/project/django-auth-ldap/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/django-3.2[${PYTHON_USEDEP}]
	>=dev-python/python-ldap-3.1[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		$(python_gen_impl_dep sqlite)
		net-nds/openldap[-minimal]
	)
"

distutils_enable_sphinx docs --no-autodoc

python_test() {
	# for slapd and slapdtest
	local -x SBIN=/usr/sbin:/usr/$(get_libdir)/openldap
	"${EPYTHON}" -m django test -v 2 --settings tests.settings ||
		die "Tests failed with ${EPYTHON}"
}

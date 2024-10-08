# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Rate-limited autoresponder for qmail"
HOMEPAGE="https://untroubled.org/qmail-autoresponder/"
SRC_URI="https://untroubled.org/qmail-autoresponder/archive/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~mips ~sparc x86"
IUSE="mysql"

DEPEND="
	>=dev-libs/bglibs-2.04
	mysql? ( dev-db/mysql-connector-c:0= )
"
RDEPEND="
	${DEPEND}
	virtual/qmail
	mysql? ( virtual/mysql )
"

PATCHES=(
	"${FILESDIR}/${P}-clear-struct.patch"
	"${FILESDIR}/${P}-drop-mysql.patch"
)

src_configure() {
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
}

src_compile() {
	emake qmail-autoresponder
	if use mysql; then
		emake qmail-autoresponder-mysql
	fi
}

src_install() {
	dobin qmail-autoresponder
	doman qmail-autoresponder.1
	if use mysql; then
		dobin qmail-autoresponder-mysql
		doman qmail-autoresponder-mysql.1
		dodoc schema.mysql
	fi

	dodoc ANNOUNCEMENT NEWS README TODO ChangeLog procedure.txt
}

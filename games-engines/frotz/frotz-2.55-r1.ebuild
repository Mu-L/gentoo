# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Interpreter for Z-code based text games"
HOMEPAGE="https://661.org/proj/if/frotz/"
SRC_URI="https://gitlab.com/DavidGriffith/frotz/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86"
IUSE="ncurses sdl sound unicode"
REQUIRED_USE="sound? ( || ( ncurses sdl ) )"

DEPEND="
	ncurses? (
		sys-libs/ncurses:=[unicode(+)?]
		sound? (
			media-libs/libao
			media-libs/libmodplug
			media-libs/libsamplerate
			media-libs/libsndfile[-minimal]
			media-libs/libvorbis
		)
	)
	sdl? (
		media-libs/freetype:2
		media-libs/libjpeg-turbo:=
		media-libs/libpng:0=
		media-libs/libsdl2[sound,threads(+),video]
		media-libs/sdl2-mixer[mod,vorbis,wav]
		sys-libs/zlib
	)
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-makefile-ordering.patch"
	"${FILESDIR}/${P}-which.patch"
)

src_compile() {
	filter-lto

	emake \
		dumb \
		$(use ncurses && echo ncurses) \
		$(use sdl && echo sdl) \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		RANLIB="$(tc-getRANLIB)" \
		CURSES=$(usex unicode ncursesw ncurses) \
		USE_UTF8=$(usex unicode yes "") \
		SOUND_TYPE=$(usex sound ao none) \
		PREFIX="${EPREFIX}/usr" \
		SYSCONFDIR="${EPREFIX}/etc"
}

src_install() {
	emake \
		install_dumb \
		$(use ncurses && echo install) \
		$(use sdl && echo install_sdl) \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		RANLIB="$(tc-getRANLIB)" \
		CURSES=$(usex unicode ncursesw ncurses) \
		USE_UTF8=$(usex unicode yes "") \
		SOUND_TYPE=$(usex sound ao none) \
		PREFIX="${EPREFIX}/usr" \
		SYSCONFDIR="${EPREFIX}/etc" \
		DESTDIR="${D}"

	dodoc \
		AUTHORS ChangeLog CONTRIBUTORS DUMB HOW_TO_PLAY README README.md \
		doc/frotz.conf-{big,small}
}

pkg_postinst() {
	echo
	elog "Global config file can be installed in ${EPREFIX}/etc/frotz.conf"
	elog "Sample config files are in ${EPREFIX}/usr/share/doc/${PF}"
	echo
}

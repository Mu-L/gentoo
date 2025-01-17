# Copyright 2002-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools flag-o-matic pax-utils toolchain-funcs

P_FD="dosemu-freedos-1.0-bin"
COMMIT="15cfb41ff20a052769d753c3262c57ecb050ad71"
# snapshot is downloaded as:
# https://sourceforge.net/code-snapshots/git/d/do/dosemu/code.git/dosemu-code-${COMMIT}.zip

DESCRIPTION="DOS Emulator"
HOMEPAGE="http://www.dosemu.org/"
SRC_URI="https://downloads.sourceforge.net/dosemu/${P_FD}.tgz
	https://dev.gentoo.org/~sam/distfiles/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="X alsa debug fluidsynth gpm svga"

BDEPEND="app-arch/unzip
	sys-devel/bison
	X? (
		x11-apps/bdftopcf
		>=x11-apps/mkfontscale-1.2.0
	)"
COMMON_DEPEND="media-libs/libsdl
	>=sys-libs/slang-1.4
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXxf86vm
	)
	alsa? ( media-libs/alsa-lib )
	fluidsynth? (
		media-sound/fluid-soundfont
		media-sound/fluidsynth
	)
	gpm? ( sys-libs/gpm )
	svga? ( media-libs/svgalib )"
#	sndfile? ( media-libs/libsndfile )
DEPEND="${COMMON_DEPEND}
	X? ( x11-base/xorg-proto )"
RDEPEND="${COMMON_DEPEND}
	X? ( x11-apps/xset )"

S="${WORKDIR}/${PN}-code-${COMMIT}"

PATCHES=(
	"${FILESDIR}"/${P}-fortify.patch
	"${FILESDIR}"/${PN}-1.4.1_pre20091009-dash.patch
	"${FILESDIR}"/${P}-no-glibc.patch
	"${FILESDIR}"/${P}-flex-2.6.3.patch
	"${FILESDIR}"/${P}-ia16-ldflags.patch
	"${FILESDIR}"/${P}-fix-inline.patch
	"${FILESDIR}"/${P}-lto.patch
	"${FILESDIR}"/${P}-as.patch
	"${FILESDIR}"/${P}-nm.patch
	"${FILESDIR}"/${P}-pcm_write_interleaved-incompatiible-pointer-type.patch
	"${FILESDIR}"/${P}-gcc10-const.patch
)

pkg_pretend() {
	if tc-is-clang; then
		die "${P} does not work on clang due to missing 16-bit assembly support: https://bugs.gentoo.org/729240. Please try gcc."
	fi
}

src_prepare() {
	default

	# Has problems with -O3 on some systems
	replace-flags -O[3-9] -O2

	# This one is from media-sound/fluid-soundfont (bug #479534)
	sed "s,/usr/share/soundfonts/default.sf2,${EPREFIX}/usr/share/sounds/sf2/FluidR3_GM.sf2,"\
		-i src/plugin/fluidsynth/mid_o_flus.c || die

	eautoreconf
}

src_configure() {
	unset YACC

	# workaround binutils ld.gold bug #618366
	local nopie_flag=
	if tc-enables-pie; then
		if gcc-specs-pie; then
			# before gcc got upstream support for '-no-pie'
			nopie_flag=-nopie
		else
			nopie_flag=-no-pie
		fi
	fi

	# sndfile support is unconditionally disabled in src/plugin/sndfile/snd_o_wav.c
	# CPP has to be set explicitly to workaround autoconf-2.69
	# CPP detection (fixed in 2.70). bug #762748.
	econf $(use_with X x) \
		$(use_with svga svgalib) \
		$(use_enable debug) \
		$(use_with gpm) \
		$(use_with alsa) \
		$(use_with fluidsynth) \
		--without-sndfile \
		--with-fdtarball="${DISTDIR}"/${P_FD}.tgz \
		--sysconfdir="${EPREFIX}"/etc/dosemu/ \
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF} \
		IA16_LDFLAGS_EXTRA=${nopie_flag} \
		CPP="$(tc-getCPP)"
}

src_compile() {
	# src/makefile.common is written manually, uses AR=ar
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	# r - randmmap: dosemu tries to get address mapping
	#     exactly where asked, loops otherwise.
	# m - allow RWX mapping: as it's an emulator / code loader
	pax-mark -mr "${ED}/usr/bin/dosemu.bin"
}

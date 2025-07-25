# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake flag-o-matic llvm.org python-single-r1

DESCRIPTION="The LLVM debugger"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0/${LLVM_SOABI}"
KEYWORDS="~amd64 ~arm ~arm64 ~loong x86"
IUSE="debug debuginfod +libedit lzma ncurses +python test +xml"
RESTRICT="test"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

DEPEND="
	debuginfod? (
		net-misc/curl:=
		dev-cpp/cpp-httplib:=
	)
	libedit? ( dev-libs/libedit:0= )
	lzma? ( app-arch/xz-utils:= )
	ncurses? ( >=sys-libs/ncurses-5.9-r3:0= )
	xml? ( dev-libs/libxml2:= )
	~llvm-core/clang-${PV}
	~llvm-core/llvm-${PV}[debuginfod=]
"
RDEPEND="
	${DEPEND}
	python? (
		${PYTHON_DEPS}
	)
"
BDEPEND="
	${PYTHON_DEPS}
	python? (
		>=dev-lang/swig-3.0.11
	)
	test? (
		$(python_gen_cond_dep "
			~dev-python/lit-${PV}[\${PYTHON_USEDEP}]
			dev-python/psutil[\${PYTHON_USEDEP}]
		")
		llvm-core/lld
	)
"

LLVM_COMPONENTS=( lldb cmake llvm/utils )
LLVM_TEST_COMPONENTS=( llvm/lib/Testing/Support third-party )
LLVM_USE_TARGETS=llvm+eq
llvm.org_set_globals

src_configure() {
	# bug #858389 (https://github.com/llvm/llvm-project/issues/83636)
	filter-lto

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	local mycmakeargs=(
		-DLLVM_ROOT="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}"
		-DClang_ROOT="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}"

		-DLLDB_ENABLE_CURSES=$(usex ncurses)
		-DLLDB_ENABLE_LIBEDIT=$(usex libedit)
		-DLLDB_ENABLE_PYTHON=$(usex python)
		-DLLDB_ENABLE_LUA=OFF
		-DLLDB_ENABLE_LZMA=$(usex lzma)
		-DLLDB_ENABLE_LIBXML2=$(usex xml)
		-DLLVM_ENABLE_TERMINFO=$(usex ncurses)

		-DLLDB_INCLUDE_TESTS=$(usex test)

		-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"

		-DCLANG_LINK_CLANG_DYLIB=ON
		# TODO: fix upstream to detect this properly
		-DHAVE_LIBDL=ON
		-DHAVE_LIBPTHREAD=ON

		# normally we'd have to set LLVM_ENABLE_TERMINFO, HAVE_TERMINFO
		# and TERMINFO_LIBS... so just force FindCurses.cmake to use
		# ncurses with complete library set (including autodetection
		# of -ltinfo)
		-DCURSES_NEED_NCURSES=ON

		-DCLANG_RESOURCE_DIR="../../../clang/${LLVM_MAJOR}"

		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
		-DPython3_EXECUTABLE="${PYTHON}"
	)
	use test && mycmakeargs+=(
		-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
	)

	cmake_src_configure
}

src_test() {
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-lldb-{shell,unit}
	# failures + hangs
	#use python && cmake_build check-lldb-api
}

src_install() {
	cmake_src_install
	find "${D}" -name '*.a' -delete || die

	use python && python_optimize
}

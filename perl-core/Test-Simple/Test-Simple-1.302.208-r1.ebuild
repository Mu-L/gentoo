# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=EXODIST
DIST_VERSION=1.302208
DIST_EXAMPLES=("examples/*")
# Avoid circular dependency in eclass on virtual/perl-Test-Simple
GENTOO_DEPEND_ON_PERL=no
inherit perl-module

DESCRIPTION="Basic utilities for writing tests"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	dev-lang/perl:=
	!<dev-perl/Test-Tester-0.114.0
	!<dev-perl/Test-use-ok-0.160.0
	!<=dev-perl/Log-Dispatch-Config-TestLog-0.20.0
	!<=dev-perl/Net-BitTorrent-0.52.0
	!<=dev-perl/Moose-2.120.900
	!<=dev-perl/Test-Able-0.110.0
	!<=dev-perl/Test-Aggregate-0.373.0
	!<=dev-perl/Test-Alien-0.40.0
	!<=dev-perl/Test-Builder-Clutch-0.70.0
	!<=dev-perl/Test-Clustericious-Cluster-0.300.0
	!<=dev-perl/Test-Dist-VersionSync-1.1.4
	!<=dev-perl/Test-Exception-0.420.0
	!<=dev-perl/Test-Flatten-0.110.0
	!<=dev-perl/Test-Group-0.200.0
	!<=dev-perl/Test-Modern-0.12.0
	!<=dev-perl/Test-More-Prefix-0.5.0
	!<=dev-perl/Test-ParallelSubtest-0.50.0
	!<=dev-perl/Test-Pretty-0.320.0
	!<=dev-perl/Test-SharedFork-0.340.0
	!<=dev-perl/Test-Wrapper-0.3.0
	!<=dev-perl/Test-UseAllModules-0.140.0
	!<=dev-perl/Test2-Harness-0.0.13
	!<=dev-perl/Test2-Tools-EventDumper-0.0.7
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	>=virtual/perl-Scalar-List-Utils-1.130.0
	virtual/perl-Storable
"
BDEPEND="
	${RDEPEND}
	dev-lang/perl:=
	virtual/perl-ExtUtils-MakeMaker
"

if (__setup_distribution_build_included)
	return ()
endif ()
set ( __setup_distribution_build_included YES )

# simpler packages: provide -DPACK=1, and DISTR_BUILD will be set from env $DISTR, easier in dockers
if (PACK)
	set ( DISTR_BUILD "$ENV{DISTR}" )
endif ()

# Make release build for the pointed distr
# That will override defaults and give possibility to build
# the distribution with minimal command line
if (NOT DISTR_BUILD)
	return ()
endif ()

# set default options to be included into build
set ( DISTR "${DISTR_BUILD}" CACHE STRING "Choose the distr." )
set ( WITH_MYSQL 1 CACHE BOOL "Forced Mysql" FORCE )
set ( WITH_EXPAT 1 CACHE BOOL "Forced Expat" FORCE )
set ( WITH_POSTGRESQL 1 CACHE BOOL "Forced Pgsql" FORCE )
set ( WITH_RE2 1 CACHE BOOL "Forced RE2" FORCE )
set ( WITH_STEMMER 1 CACHE BOOL "Forced Stemmer" FORCE )
set ( WITH_SSL 1 CACHE BOOL "Forced OpenSSL" FORCE )
set ( WITH_SYSTEMD 1 CACHE BOOL "Forced Systemd" FORCE )
SET ( BUILD_TESTING 0 CACHE BOOL "Forced no testing" FORCE )
infomsg ( "DISTR_BUILD applied.
Package will be set to ${DISTR_BUILD},
also option forced to ON values: WITH_MYSQL, WITH_EXPAT, WITH_POSTGRESQL, WITH_RE2, WITH_STEMMER, WITH_SSL, WITH_SYSTEMD.
Also LIBS_BUNDLE is automatically set to folder 'bundle' placed one level above the sources" )

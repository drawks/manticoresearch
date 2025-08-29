# FindSystemd.cmake
# Usage:
#   find_package(Systemd REQUIRED)
#   target_link_libraries(myapp PRIVATE SYSTEMD::SYSTEMD)
#
# Provides:
#   SYSTEMD::SYSTEMD (imported target)
#   SYSTEMD_FOUND (boolean)
#   SYSTEMD_VERSION
#   SYSTEMD_INCLUDE_DIRS
#   SYSTEMD_LIBRARIES

# --- Try pkg-config first -----------------------------------------------------
find_package(PkgConfig QUIET)
if (PkgConfig_FOUND)
  # Canonical name is "libsystemd"
  pkg_check_modules(SYSTEMD_PKG QUIET IMPORTED_TARGET libsystemd)
endif()

# --- If pkg-config worked, take its data; otherwise, manual search ------------
if (TARGET PkgConfig::SYSTEMD_PKG)
  set(SYSTEMD_INCLUDE_DIRS "${SYSTEMD_PKG_INCLUDE_DIRS}")
  set(SYSTEMD_LIBRARIES    "${SYSTEMD_PKG_LIBRARIES}")
  set(SYSTEMD_VERSION      "${SYSTEMD_PKG_VERSION}")
else()
  # Look for common systemd headers (any one will do)
  find_path(SYSTEMD_INCLUDE_DIR
    NAMES systemd/sd-daemon.h systemd/sd-bus.h systemd/sd-journal.h
  )
  find_library(SYSTEMD_LIBRARY
    NAMES systemd libsystemd
    NAMES_PER_DIR
  )
  set(SYSTEMD_INCLUDE_DIRS "${SYSTEMD_INCLUDE_DIR}")
  set(SYSTEMD_LIBRARIES    "${SYSTEMD_LIBRARY}")
endif()

# --- Report result in the standard CMake way ----------------------------------
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SYSTEMD
  REQUIRED_VARS SYSTEMD_LIBRARIES SYSTEMD_INCLUDE_DIRS
  VERSION_VAR  SYSTEMD_VERSION
)

# Also provide the widely-seen upper-case *_FOUND for convenience
set(SYSTEMD_FOUND "${SYSTEMD_FOUND}")

mark_as_advanced(SYSTEMD_LIBRARY SYSTEMD_INCLUDE_DIR SYSTEMD_INCLUDE_DIRS SYSTEMD_LIBRARIES)

# --- Create a uniform imported target -----------------------------------------
if (SYSTEMD_FOUND AND NOT TARGET SYSTEMD::SYSTEMD)
  if (TARGET PkgConfig::SYSTEMD_PKG)
    add_library(SYSTEMD::SYSTEMD INTERFACE IMPORTED)
    target_link_libraries(SYSTEMD::SYSTEMD INTERFACE PkgConfig::SYSTEMD_PKG)
  else()
	  add_library(SYSTEMD::SYSTEMD UNKNOWN IMPORTED)
    set_target_properties(SYSTEMD::SYSTEMD PROPERTIES
      IMPORTED_LOCATION              "${SYSTEMD_LIBRARIES}"
      INTERFACE_INCLUDE_DIRECTORIES  "${SYSTEMD_INCLUDE_DIRS}"
    )
  endif()
endif()


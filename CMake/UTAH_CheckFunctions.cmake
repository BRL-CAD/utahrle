include(CheckLibraryExists)
include(ResolveCompilerPaths)

macro(UTAH_CHECK_LIBRARY targetname lname func)
  if(NOT ${targetname}_LIBRARY)
    CHECK_LIBRARY_EXISTS(${lname} ${func} "" HAVE_${targetname}_${lname})
    if(HAVE_${targetname}_${lname})
      RESOLVE_LIBRARIES (${targetname}_LIBRARY "-l${lname}")
      set(${targetname}_LINKOPT "-l${lname}" CACHE STRING "${targetname} link option")
      mark_as_advanced(${targetname}_LINKOPT)
    endif(HAVE_${targetname}_${lname})
  endif(NOT ${targetname}_LIBRARY)
endmacro(UTAH_CHECK_LIBRARY lname func)

# Local Variables: 
# tab-width: 8 
# mode: cmake 
# indent-tabs-mode: t 
# End: 
# ex: shiftwidth=2 tabstop=8

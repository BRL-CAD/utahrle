#        F I N D D O C B O O K 5 R E S O U R C E S . C M A K E
# BRL-CAD
#
# Copyright (c) 2010-2012 United States Government as represented by
# the U.S. Army Research Laboratory.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following
# disclaimer in the documentation and/or other materials provided
# with the distribution.
#
# 3. The name of the author may not be used to endorse or promote
# products derived from this software without specific prior written
# permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
# GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
###
# - Find resources files needed to process DocBook 5 files
#
#  The module defines the following variables:
#  DB5_XSL_HTML
#  DB5_XSL_XHTML
#  DB5_XSL_XHTML_1_1
#  DB5_XSL_MANPAGES
#  DB5_XSL_FO
#
#  DB5_SCHEMA_XSD
#  DB5_SCHEMA_RNG

if(NOT DEFINED DB5_ROOT_PATHS)
  set(DB5_ROOT_PATHS
    /usr/share
    )
endif(NOT DEFINED DB5_ROOT_PATHS)

# Locate stylesheets
if(NOT DEFINED STYLESHEETS_RELATIVE)
  set(STYLESHEETS_RELATIVE
    sgml/docbook
    )
endif(NOT DEFINED STYLESHEETS_RELATIVE)
set(stylesheet_paths)
foreach(root_dir ${DB5_ROOT_PATHS})
  foreach(relative_dir ${STYLESHEETS_RELATIVE})
    set(xsl_paths)
    file(GLOB xsl_paths RELATIVE ${root_dir} ${root_dir}/${relative_dir}/*xsl*stylesheets*)
    list(SORT xsl_paths)
    list(REVERSE xsl_paths)
    set(stylesheet_paths ${stylesheet_paths} ${xsl_paths})
  endforeach(relative_dir ${STYLESHEETS_RELATIVE})
endforeach(root_dir ${DB5_ROOT_PATHS})

find_file(DB5_XSL_HTML html/docbook.xsl
  PATHS ${DB5_ROOT_PATHS}
  PATH_SUFFIXES ${stylesheet_paths})

find_file(DB5_XSL_MANPAGES manpages/docbook.xsl
  PATHS ${DB5_ROOT_PATHS} 
  PATH_SUFFIXES ${stylesheet_paths})

find_file(DB5_XSL_FO fo/docbook.xsl
  PATHS ${DB5_ROOT_PATHS} 
  PATH_SUFFIXES ${stylesheet_paths})

find_file(DB5_XSL_XHTML xhtml/docbook.xsl
  PATHS ${DB5_ROOT_PATHS} 
  PATH_SUFFIXES ${stylesheet_paths})

find_file(DB5_XSL_XHTML_1_1 xhtml-1_1/docbook.xsl
  PATHS ${DB5_ROOT_PATHS} 
  PATH_SUFFIXES ${stylesheet_paths})


# Locate schema
if(NOT DEFINED SCHEMA_RELATIVE)
  set(SCHEMA_RELATIVE
    xml/docbook5
    )
endif(NOT DEFINED SCHEMA_RELATIVE)
set(schema_paths)
foreach(root_dir ${DB5_ROOT_PATHS})
  foreach(relative_dir ${SCHEMA_RELATIVE})
    set(xsl_paths)
    file(GLOB xsl_paths RELATIVE ${root_dir} ${root_dir}/${relative_dir}/*schema*)
    list(SORT xsl_paths)
    list(REVERSE xsl_paths)
    set(schema_paths ${schema_paths} ${xsl_paths})
  endforeach(relative_dir ${SCHEMA_RELATIVE})
endforeach(root_dir ${DB5_ROOT_PATHS})

find_file(DB5_SCHEMA_XSD xsd/docbook.xsd 
  PATHS ${DB5_ROOT_PATHS}
  PATH_SUFFIXES ${schema_paths})

find_file(DB5_SCHEMA_RNG rng/docbook.rng
  PATHS ${DB5_ROOT_PATHS}
  PATH_SUFFIXES ${schema_paths})

# Local Variables:
# tab-width: 8
# mode: cmake
# indent-tabs-mode: t
# End:
# ex: shiftwidth=2 tabstop=8

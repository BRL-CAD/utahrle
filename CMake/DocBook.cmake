#                   D O C B O O K . C M A K E
# BRL-CAD
#
# Copyright (c) 2011-2012 United States Government as represented by
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
#
# DocBook conversion and validation can be accomplished
# with multiple programs.  The key to using a given tool is
# defining the proper instructions for CMake to launch it
# correctly.

# These instructions are defined in <exec_name>.cmake.in templates.
# To work, the cmake.in files will need to produce standard 
# validity "stamp"a files and fatal errors in a consistent manner 
# for any given a processing tool.  See already defined
# <exec_name>.cmake.in files in DocBook_scripts for examples.

# There are several steps when processing DocBook files - the
# variables defined for each stage allow full control of the
# tool chain:

# 1. Validation (optional) - this step checks that XML input
#    files fully satisfy their schema.  The option DB_VALIDATE
#    can be set to on or off to control this step.
#
#    Executable variable:  DB_VALIDATION_EXECUTABLE
#    Pre-defined <exec_name>.cmake.in files:  msv, rnv, xmllint
#
# 2. XSLT translation - the most common and core operation, that
#    (for example) prcesses DocBook input into HTML.
#
#    Executable variable:  DB_XSLT_EXECUTABLE
#    Pre-defined <exec_name>.cmake.in files:  xsltproc
#
# 3. PDF translation (optional) - Portable Document Format
#    output is one of the supported output options for a DocBook
#    processing toolchain.  These macros use the technique of
#    staging through an FO intermediate stage, then to PDF.
#    Executable variable:  DB_PDF_EXECUTABLE
#    Pre-defined <exec_name>.cmake.in files:  fop

# For a worked example, see rnv.cmake.in - to test it, install rnv from
# http://sourceforge.net/projects/rnv/ and configure BRL-CAD as follows:
#
# cmake .. -DDB_VALIDATION=ON -DDB_VALIDATION_EXECUTABLE=rnv
#
# Note that rnv must be in the system path for this to work.


# TODO!!! Need a way to group docbook targets into batches that are all
# triggered with a single target, e.g.
# 
# make doc_man1_man
# make doc_man1_html
# 
# perhaps could optionally make individual targets too, but would default
# to OFF on Windows/MSVC - group targets only.
# 
# Can probably build lists of output files, and then make one target
# depend on all the files in the list.  Need to do some experimenting.

# This toplevel setting can completely enable or disable all DocBook
# processing.
if(NOT DEFINED ENABLE_DOCBOOK_PROCESSING)
  set(ENABLE_DOCBOOK_PROCESSING ON)
endif(NOT DEFINED ENABLE_DOCBOOK_PROCESSING)

# Enable/Disable strict XML validation.
if(NOT DEFINED DB_VALIDATION)
  set(DB_VALIDATION ON)
endif(NOT DEFINED DB_VALIDATION)

# DocBook controls for globally enabling/disabling output types.
# Currently, there is logic for Unix man page, HTML, and
# pdf output.
if(NOT DEFINED DB_MAN_OUTPUT)
  set(DB_MAN_OUTPUT ON)
endif(NOT DEFINED DB_MAN_OUTPUT)
if(NOT DEFINED DB_HTML_OUTPUT)
  set(DB_HTML_OUTPUT ON)
endif(NOT DEFINED DB_HTML_OUTPUT)
if(NOT DEFINED DB_PDF_OUTPUT)
  set(DB_PDF_OUTPUT ON)
endif(NOT DEFINED DB_PDF_OUTPUT)

# xmllint and xsltproc are the default tools, so we want to be sure
# we know how to handle them. These variables hold the contents of
# what would be xmllint.cmake.in and xsltproc.cmake.in  Apache FOP
# is the default PDF output tool, so add that too.
set(xmllint_script "
execute_process(COMMAND \"\@CMAKE_COMMAND\@\" -E remove -f \"\@db_outfile\@\")
execute_process(COMMAND \"\@XMLLINT_EXECUTABLE\@\"  --xinclude --schema \"\@BRLCAD_BINARY_DIR\@/doc/docbook/resources/other/docbook-schema/xsd/docbook.xsd\" --noout --nonet \"\@CMAKE_CURRENT_SOURCE_DIR\@/\@filename\@\" RESULT_VARIABLE CMDRESULT)
if(CMDRESULT)
  message(FATAL_ERROR \"xmllint failure: \${CMDRESULT}\")
else(CMDRESULT)
  execute_process(COMMAND \"\@CMAKE_COMMAND\@\" -E touch \"\@db_outfile\@\")
endif(CMDRESULT)
")

set(xsltproc_script "
set(ENV{XML_DEBUG_CATALOG} 1)
# It is necessary to ensure that the target directory exists *before* calling xsltproc
# when building in parallel, due to a bug/limitation in xsltproc
get_filename_component(output_dir \"\@outfile\@\" PATH)
execute_process(COMMAND \"\@CMAKE_COMMAND\@\" -E make_directory \"\${output_dir}/\")
execute_process(COMMAND \"\@XSLTPROC_EXECUTABLE\@\" -nonet -xinclude -o \"\@outfile\@\" \"\@CURRENT_XSL_STYLESHEET\@\" \"\@CMAKE_CURRENT_SOURCE_DIR\@/\@filename\@\" RESULT_VARIABLE CMDRESULT)

# For some reason, xsltproc doesn't always seem to respect the
# output variable when doing man pages.  Add a backup check
# to move the man page to the right location if xsltproc insists
# on putting it in the current directory.
get_filename_component(base_output_name \"\@outfile\@\" NAME)
get_filename_component(base_output_path \"\@outfile\@\" PATH)
set(output_names \${base_output_name} \@EXTRA_OUTPUTS\@)
foreach(output_name \${output_names})
  if(NOT \"\@CMAKE_CURRENT_BINARY_DIR\@/\${output_name}\" STREQUAL \"\${base_output_path}/\${output_name}\")
    if(EXISTS \"\@CMAKE_CURRENT_BINARY_DIR\@/\${output_name}\")
      execute_process(COMMAND \"\@CMAKE_COMMAND\@\" -E copy \"\@CMAKE_CURRENT_BINARY_DIR\@/\${output_name}\" \"\${base_output_path}/\${output_name}\")
      execute_process(COMMAND \"\@CMAKE_COMMAND\@\" -E remove \"\@CMAKE_CURRENT_BINARY_DIR\@/\${output_name}\" )
    endif(EXISTS \"\@CMAKE_CURRENT_BINARY_DIR\@/\${output_name}\")
  endif(NOT \"\@CMAKE_CURRENT_BINARY_DIR\@/\${output_name}\" STREQUAL \"\${base_output_path}/\${output_name}\")
endforeach(output_name \${output_names})
if(CMDRESULT)
  message(FATAL_ERROR \"xsltproc build failure: \${CMDRESULT}\")
endif(CMDRESULT)
")

set(fop_script "
# Apache FOP version from parent CMake build system
set(APACHE_FOP_VERSION \@APACHE_FOP_VERSION\@)

# fop hyphenation path (fop version >= 1.0)
# need v2 hyphenation
set(FOP_HYP \"\@FOP_HYP_PATH\@\")

# log4j properties file
set(LOG4J \"\@LOG4J_PROPERTIES_PATH\@\")

# classpath
set(FOP_CLASSPATH \"\@FOP_CLASSPATH\@\")

# fop xconf file
set(FOP_XCONF \"\@FOP_XCONF_PATH\@\")

# FOP uses environment variables - set them.
set(ENV{FOP_HYPHENATION_PATH} \"\${FOP_HYPH}\")

set(ENV{CLASSPATH} \"\${FOP_CLASSPATH}\")

# Keep FOP headless on OSX and specify the log4j config
set(ENV{FOP_OPTS} \"-Djava.awt.headless=true  -Dlog4j.configuration=\"\${LOG4J}\"\")

# Make sure the target directory exists
get_filename_component(output_dir \"\@outfile\@\" PATH)
execute_process(COMMAND \"\@CMAKE_COMMAND\@\" -E make_directory \"\${output_dir}\")

# Run FOP to actually generate the PDF
execute_process(COMMAND \"\@APACHE_FOP\@\" -c \"\${FOP_XCONF}\" \"\@fo_outfile\@\" -pdf \"\@outfile\@\" RESULT_VARIABLE CMDRESULT)

# Fatal error if FOP didn't succeed, so the parent CMake build knows something went wrong and can halt.
if(CMDRESULT)
  message(FATAL_ERROR \"Apache FOP build failure: \${CMDRESULT}\")
endif(CMDRESULT)

")

set(default_log4j_settings "
#set the level of the root logger and set its appender
# as an appender named X
#log4j.rootLogger = WARN, X
#log4j.rootLogger = ERROR, X
log4j.rootLogger = FATAL, X

#set the appender named X to be a console appender
log4j.appender.X=org.apache.log4j.ConsoleAppender

#set the layout for the appender X
log4j.appender.X.layout=org.apache.log4j.PatternLayout
log4j.appender.X.layout.conversionPattern=%-5p - %m%n
")

# If we aren't using default tools, we need to find the scripts that
# tell use how to run them. Potentially, CMAKE_MODULE_PATH may hold 
# multiple paths that contain local modules - this macro sorts through them.
macro(FIND_LAUNCH_SCRIPT execname returnval)
  set(${returnval})
  foreach(dir ${CMAKE_MODULE_PATH})
    if(NOT ${returnval})
      if(EXISTS "${dir}/DocBook_scripts/${execname}.cmake.in")
	set(${returnval} "${dir}/DocBook_scripts/${execname}.cmake.in")
      endif(EXISTS "${dir}/DocBook_scripts/${execname}.cmake.in")
    endif(NOT ${returnval})
  endforeach(dir ${CMAKE_MODULE_PATH})
endmacro(FIND_LAUNCH_SCRIPT)

# Handle default exec and sanity checking for XML validation
if(DB_VALIDATION AND ENABLE_DOCBOOK_PROCESSING)
  if(NOT DEFINED DB_VALIDATION_EXECUTABLE OR "${DB_VALIDATION_EXECUTABLE}" STREQUAL "xmllint")
    find_program(XMLLINT_EXECUTABLE xmllint)
    if(XMLLINT_EXECUTABLE)
      set(DB_VALIDATION_EXECUTABLE "xmllint")
      file(WRITE ${CMAKE_BINARY_DIR}/CMakeFiles/DocBook/xmllint.cmake.in "${xmllint_script}")
      set(VALIDATION_LAUNCH_SCRIPT_TEMPLATE "${CMAKE_BINARY_DIR}/CMakeFiles/DocBook/xmllint.cmake.in")
    else(XMLLINT_EXECUTABLE)
      message(WARNING "DocBook validation enabled, but no validation tool specified and xmllint was not found.  Disabling validation.")
      set(DOCBOOK_VALIDATION OFF)
    endif(XMLLINT_EXECUTABLE)
  else(NOT DEFINED DB_VALIDATION_EXECUTABLE OR "${DB_VALIDATION_EXECUTABLE}" STREQUAL "xmllint")
    FIND_LAUNCH_SCRIPT("${DB_VALIDATION_EXECUTABLE}" VALIDATION_LAUNCH_SCRIPT_TEMPLATE)
    if(NOT VALIDATION_LAUNCH_SCRIPT_TEMPLATE)
      message(FATAL_ERROR "Specified ${DB_VALIDATION_EXECUTABLE} for DocBook validation, but ${DB_VALIDATION_EXECUTABLE}.cmake.in does not exist.  To use ${DB_VALIDATION_EXECUTABLE} for validation a ${DB_VALIDATION_EXECUTABLE}.cmake.in file must be present in the DocBook_scripts subdirectory of a valid CMake modules directory.")
    endif(NOT VALIDATION_LAUNCH_SCRIPT_TEMPLATE)
  endif(NOT DEFINED DB_VALIDATION_EXECUTABLE OR "${DB_VALIDATION_EXECUTABLE}" STREQUAL "xmllint")
endif(DB_VALIDATION AND ENABLE_DOCBOOK_PROCESSING)

# Handle default exec and sanity checking for XSLT
if(ENABLE_DOCBOOK_PROCESSING)
  if(NOT DEFINED DB_XSLT_EXECUTABLE OR "${DB_XSLT_EXECUTABLE}" STREQUAL "xsltproc")
    find_program(XSLTPROC_EXECUTABLE xsltproc)
    if(XSLTPROC_EXECUTABLE)
      set(DB_XSLT_EXECUTABLE "xsltproc")
      file(WRITE ${CMAKE_BINARY_DIR}/CMakeFiles/DocBook/xsltproc.cmake.in "${xmllint_script}")
      set(XSLT_LAUNCH_SCRIPT_TEMPLATE "${CMAKE_BINARY_DIR}/CMakeFiles/DocBook/xsltproc.cmake.in")
    else(XSLTPROC_EXECUTABLE)
      message(FATAL_ERROR "DocBook processing enabled, but no XSLT tool specified and xsltproc was not found.  Options include setting ENABLE_DOCBOOK_PROCESSING to OFF, specifying the location of xsltproc via XSLTPROC_EXECUTABLE or specify another validation tool with the DB_XSLT_EXECUTABLE variable.  To use DB_XSLT_EXECUTABLE for DocBook input processing a <DB_XSLT_EXECUTABLE>.cmake.in file corrsponding to the specified program must be present in the DocBook_scripts subdirectory of a valid CMake modules directory.")
    endif(XSLTPROC_EXECUTABLE)
  else(NOT DEFINED DB_XSLT_EXECUTABLE OR "${DB_XSLT_EXECUTABLE}" STREQUAL "xsltproc")
    FIND_LAUNCH_SCRIPT("${DB_XSLT_EXECUTABLE}" XSLT_LAUNCH_SCRIPT_TEMPLATE)
    if(NOT XSLT_LAUNCH_SCRIPT_TEMPLATE)
      message(FATAL_ERROR "Specified ${DB_XSLT_EXECUTABLE} for DocBook XSLT processing, but ${DB_XSLT_EXECUTABLE}.cmake.in does not exist.  To use ${DB_XSLT_EXECUTABLE} for DocBook input processing a ${DB_XSLT_EXECUTABLE}.cmake.in file must be present in the DocBook_scripts subdirectory of a valid CMake modules directory.")
    endif(NOT XSLT_LAUNCH_SCRIPT_TEMPLATE)
  endif(NOT DEFINED DB_XSLT_EXECUTABLE OR "${DB_XSLT_EXECUTABLE}" STREQUAL "xsltproc")
endif(ENABLE_DOCBOOK_PROCESSING)

# Handle default exec and sanity checking for XSL-FO to PDF conversion
if(DB_PDF_OUTPUT AND ENABLE_DOCBOOK_PROCESSING)
  if(NOT DEFINED DB_PDF_EXECUTABLE OR "${FOP_EXECUTABLE}" STREQUAL "fop")
    find_program(FOP_EXECUTABLE fop)
    if(FOP_EXECUTABLE)
      set(DB_PDF_EXECUTABLE "fop")
      file(WRITE "${CMAKE_BINARY_DIR}/CMakeFiles/DocBook/fop.cmake.in" "${fop_script}")
      set(PDF_LAUNCH_SCRIPT_TEMPLATE "${CMAKE_BINARY_DIR}/CMakeFiles/DocBook/xmllint.cmake.in")
      file(WRITE "${CMAKE_BINARY_DIR}/CMakeFiles/DocBook/log4j.properties" "${default_log4j_settings}" )
    else(FOP_EXECUTABLE)
      message("DocBook PDF output enabled, but no XSL-FO -> PDF conversion tool specified and Apache FOP was not found.  Disabling pdf output.")
      set(DB_PDF_OUTPUT OFF)
    endif(FOP_EXECUTABLE)
  else(NOT DEFINED DB_PDF_EXECUTABLE OR "${FOP_EXECUTABLE}" STREQUAL "fop")
    FIND_LAUNCH_SCRIPT("${DB_PDF_EXECUTABLE}" PDF_LAUNCH_SCRIPT_TEMPLATE)
    if(NOT PDF_LAUNCH_SCRIPT_TEMPLATE)
      message(FATAL_ERROR "Specified ${DB_PDF_EXECUTABLE} for DocBook XSL-FO -> PDF translation, but ${DB_PDF_EXECUTABLE}.cmake.in does not exist.  To use ${DB_PDF_EXECUTABLE} for XSL-FO -> PDF processing a ${DB_PDF_EXECUTABLE}.cmake.in file must be present in the DocBook_scripts subdirectory of a valid CMake modules directory.")
    endif(NOT PDF_LAUNCH_SCRIPT_TEMPLATE)
  endif(NOT DEFINED DB_PDF_EXECUTABLE OR "${FOP_EXECUTABLE}" STREQUAL "fop")
endif(DB_PDF_OUTPUT AND ENABLE_DOCBOOK_PROCESSING)

# Get our root path
if(CMAKE_CONFIGURATION_TYPES)
  set(bin_root "${CMAKE_BINARY_DIR}/${CMAKE_CFG_INTDIR}")
else(CMAKE_CONFIGURATION_TYPES)
  set(bin_root "${CMAKE_BINARY_DIR}")
endif(CMAKE_CONFIGURATION_TYPES)

# xsltproc is finicky about slashes in names - do some
# sanity scrubbing of the full root path string in
# preparation for generating DocBook scripts
string(REGEX REPLACE "/+" "/" bin_root "${bin_root}")
string(REGEX REPLACE "/$" "" bin_root "${bin_root}")

# Local Variables:
# tab-width: 8
# mode: cmake
# indent-tabs-mode: t
# End:
# ex: shiftwidth=2 tabstop=8

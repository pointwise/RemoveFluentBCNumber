#
# Copyright 2014 (c) Pointwise, Inc.
# All rights reserved.
# 
# This sample Pointwise script is not supported by Pointwise, Inc.
# or CFD Technologies.  It is provided freely for demonstration purposes
# only.  
#
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#

package require PWI_Glyph 2
pw::Script loadTk

###############################################################
#
#-- This script takes a .cas file exported as either CAE: 
#-- Ansys Fluent or Ansys Fluent (legacy) from PointwiseV17.1R4
#-- and removes the number tagged on the end of each bc name.
#-- It applies to all bc types except interior and symmetry.
#-- If the bc spans multiple VCs, then the tagged number
#-- is left to avoid duplicate bc names occuring.
#
#-- Written by John Stone, CFD Technologies, 10-March-2014
###############################################################

#-- Get the input Fluent .cas file
wm withdraw .
set ftype {Fluent Case Files}
set cas_file [tk_getOpenFile \
    -filetypes {{{Fluent Case Files} {.cas}} {{All Files} *}} \
    -typevariable ftype \
    -title "Select Fluent Case File" -parent .]

if { [string length $cas_file] == 0 } {
  puts "No file was selected"
  exit
}

#-- generate a new .cas file name
set new_file [file join [file dirname $cas_file] "new-[file tail $cas_file]"]

while { ! [file writable [file dirname $new_file]] } {
  puts "File $new_file is not writable"
  set new_file [tk_getSaveFile \
      -title "Select Modified Fluent Case File Name and Location" \
      -initialdir [file dirname $new_file] \
      -initialfile [file tail $new_file]]
  if { [string length $new_file] == 0 } {
    puts "Cancelled"
    exit
  }
}

#-- open files
set in [open $cas_file r]
set out [open $new_file w+]

set bc_re "BC *: *(\[^\"\]*)"
set scan_bc 0
set skip_bc [list "interior " "symmetry"]
set all_bc [list]

#-- Do search until end of file is reached
while { [gets $in inLine] >= 0 } {
  if { [regexp $bc_re $inLine bc bc_type] && \
       [lsearch $skip_bc $bc_type] < 0 } {
    # we found a starting BC line that is not interior or symmetry
    set scan_bc 1
    set scan_re "($bc_type *)(\[^)\]*)(-\\d+)"
    puts $out $inLine
  } elseif { $scan_bc && [regexp $scan_re $inLine bc x1 bc_base x2] } {
    # we found the matching end BC line

    # Ensure that the stripped BC name is unique. If it isn't, then keep
    # the original name. Fluent requires BCs that span VCs have unique names.
    if { [lsearch $all_bc $bc_base] < 0} {
      lappend all_bc $bc_base
      puts ". replaced $bc_base$x2 with $bc_base"
      puts $out [regsub $scan_re $inLine "\\1\\2"]
    } else {
      puts ". retained $bc_base$x2"
      puts $out $inLine
    }
    set scan_bc 0
  } else {
    # we found neither a begin nor end BC line, just copy it to the output
    puts $out $inLine
  }
}

close $in
close $out

exit

#
# DISCLAIMER:
#
# TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, POINTWISE or
# CFD TECHNOLOGIES DISCLAIMS ALL WARRANTIES, EITHER EXPRESS OR IMPLIED,
# INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS FOR A PARTICULAR PURPOSE, WITH REGARD TO THIS SCRIPT.
# TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, IN NO EVENT SHALL
# POINTWISE or CFD TECHNOLOGIES BE LIABLE TO ANY PARTY 
# FOR ANY SPECIAL, INCIDENTAL, INDIRECT, OR CONSEQUENTIAL DAMAGES 
# WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF 
# BUSINESS INFORMATION, OR ANY OTHER PECUNIARY LOSS) ARISING OUT OF THE 
# USE OF OR INABILITY TO USE THIS SCRIPT EVEN IF POINTWISE HAS BEEN 
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGES AND REGARDLESS OF THE 
# FAULT OR NEGLIGENCE OF POINTWISE or CFD TECHNOLOGIES.
#

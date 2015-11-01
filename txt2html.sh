     #!/bin/bash
	# txt2html
	# L. J. Jaeckel
	# March 5, 2011
	#
	# Convert any plain text file to a HTML file that, when viewed,
	# will show what the original file had.  The input can even
	# be a HTML file.
	
	# Usage:
	# ------
	# As currently written, this script is strictly a simple
	# stdin --> stdout filter.  It will not take input from
	# a named file argument on the command line.  It only
	# reads from stdin.  It will take one argument, -n
	# to produce a line numbered listing.
	#
	#    Right:  txt2html < infile > outfile
	#    Right:  txt2html -n < infile > outfile
	#
	#    Wrong:  txt2html infile > outfile
	#    Wrong:  txt2html -n infile > outfile
	#
	# The output file has some template header lines (including
	# the <title>xxxxx</title> line) that you will probably want
	# to edit manually.
	
	lnums=''
	indarg1='s/^/    /'
	if [ "$1" = "-n" ]
	then
	  lnums=-n
	  indarg1='1s/x/x/'
	fi
	
	cat $lnums | sed -e '1i\
	<html>\
	  <head>\
	    <title>hacksaw v1.1</title>\
	    <style type="text/css">\
	      cmnt {color:green; font-style:italic}\
	      cmnd {font-family:Courier; text-decoration:underline}\
	      inp  {color:red; font-weight:bold; text-decoration:underline}\
	      badd {color:red; font-weight:bold}\
	      look {background-color:yellow}\
	    </style>\
	  </head>\
	  <body>\
	    <strong>hacksaw v1.1, by Kevin Gilstrap (bully)</strong><br />\
	    <strong>'"`date '+%B %-e, %Y'`"'</strong><br /><br />\
	    <hr />\
	    <pre>'     -e \
	's/&/\&amp;/g' -e \
	's/</\&lt;/g'  -e \
	's/>/\&gt;/g'  -e \
	"$indarg1"     -e \
    '$a\
    <hr />\
    </pre>\
    </body>\
    </html>\
    '

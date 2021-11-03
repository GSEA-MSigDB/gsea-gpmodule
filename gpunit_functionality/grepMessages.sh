# Copyright (c) 2003-2021 Broad Institute, Inc., Massachusetts Institute of Technology, and Regents of the University of California.  All rights reserved.
#!/bin/sh

# The file passed in $1 should be a list of fixed strings, one per line, to be checked if they are found in the $2 file.
# We verify by checking the count of matches against the count of fixed strings/ 
# This is an imperfect check but should be good enough provided the fixed strings are sufficiently detailed to appear
# only *once* in the $2 file.
grepOut=`grep -c -F -f $1 $2`
numChecks=`cat $1 | wc -l`
exit $(( numChecks - grepOut ))

# Copyright (c) 2003-2017 Broad Institute, Inc., Massachusetts Institute of Technology, and Regents of the University of California.  All rights reserved.
#!/bin/sh
execDir=`dirname $0`

zip1=$1
zip2=$2

base1=`basename $1`
base2=`basename $2`
bare1=${base1%%.zip}
bare2=${base2%%.zip}
diffDir1=`mktemp -d $bare1.XXXXXX`
diffDir2=`mktemp -d $bare2.XXXXXX`

unzip -q $zip1 -d $diffDir1
unzip -q $zip2 -d $diffDir2

# Diff only selected files out of the ZIP
diff -i --strip-trailing-cr -q $diffDir1/edb/$bare1.rnk $diffDir2/edb/$bare2.rnk
status=$?
diff -i --strip-trailing-cr -q $diffDir1/edb/results.edb $diffDir2/edb/results.edb
status=$(( $? + status ))
diff -i --strip-trailing-cr -q $diffDir1/edb/gene_sets.gmt $diffDir2/edb/gene_sets.gmt
status=$(( $? + status ))

rm -rf $diffDir1 $diffDir2
exit $status

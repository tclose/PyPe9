#!/bin/sh

if test "$NRNIV" = "" ; then
	NRNIV=nrniv
fi

f=splitbal
ncell=`sed -n '2p' $f.dat`
echo "1" > cx.dat
echo "$ncell" >> cx.dat
sed -n 's/[0-9][0-9]* \([0-9][0-9]*\) \([0-9][0-9]*\) [0-9][0-9]*/\1 \2 0/p' $f.dat >> cx.dat

for i in $* ; do
$NRNIV << here
{load_file("../common/binfo.hoc")}
mymetis3("cx", $i)
here
done



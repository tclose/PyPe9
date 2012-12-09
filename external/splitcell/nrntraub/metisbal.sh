#!/bin/sh

if test "$NRNIV" = "" ; then
	NRNIV=nrniv
fi

for i in $* ; do
$NRNIV << here
{load_file("hoc/binfo.hoc")}
mymetis2("cxwhole", $i)
here
done



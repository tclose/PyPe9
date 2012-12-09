#!/bin/sh
rm -f mkdll.result
a="`pwd`/$1"
echo "$a"
cd $1
if test "$3" = "3" ; then
	mknrndll $2
	if test -r nrnmech.dll ; then
		echo "$1/nrnmech.dll" > ../mkdll.result
	fi
else
	nrnivmodl $2
	b=`find . -name special -print`
	echo $b
	if test -r $b ; then
		c=`sed -n '/'$1'/s/.*'$1.'\([^"]*\)".*/\1/p' < $b`
		if test -r $c ; then
			echo $1/$c > ../mkdll.result
		fi
	fi
fi


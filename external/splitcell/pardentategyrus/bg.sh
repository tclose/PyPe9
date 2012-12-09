#!/bin/sh


R=`waitforfree`
allocpart $R

if false ; then

bgnoalloc $R 1 -c "load_balance_phase=1" init.hoc
bgnoalloc $R 1 -c "load_balance_phase=2" init.hoc
bgnoalloc $R 5 ../common/balcomp.hoc

NRNIV=/home/hines/neuron/nrnobj/powerpc64/bin/nrniv sh ../common/metisbal.sh \
	32 64 128 256 512 > metisbal.stdout

fi

if true ; then

for i in 32 64 128 256 ; do
	for phase in 0 3 4 ; do
		rm out$i.dat
		bgnoalloc VN $R $i -c "load_balance_phase=$phase" init.hoc
		sortspike out$i.dat temp
		cmp temp out.std
		mv temp.$i stdout.$i.$phase
	done
done

fi

freepart $R

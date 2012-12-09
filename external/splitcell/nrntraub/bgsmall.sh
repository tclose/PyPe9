#!/bin/sh

# sh small.sh 6 # to create cx6_2048.dat and cx6_2048.2048.dat , etc.
# sh small.sh 7 # to run the small multisplit sims
# sh small.sh 4 # to create cx5.dat
if test "$1" = "" ; then
	exit 0
fi

if test "$2" = "" ; then
	MSOPT="8"
else
	MSOPT="$2"
fi

PHASE=$1

SIMDIR=/bglscratch/hines/nrntraub
RESULTDIR=small${PHASE}
BINDIR=/home/hines/bin
STD=stdout

NRNIV=/home/hines/neuron/nrnobj/powerpc64/bin/nrniv

echo wait for partition
date
PART=`waitforfree`
echo "$PART is free"
/bgl/bin/allocpart $PART


run() {
echo $*
(time mpirun -noallocate -partition $PART -np $1 -mode VN \
 -cwd $SIMDIR \
 -exe $SIMDIR/powerpc64/special \
 -env "BLG_CHKPT_ENABLED=0" -args "_init.hoc" \
 )>& $SIMDIR/$RESULTDIR/$STD.$2
}

phase() {
  nhost="$3"
  sed "
    /default_var.*wholecell_prefix/s/cxwhole/cxsmall_whole/
    /default_var.*multisplit_prefix/s/cx/$prefix/
    /default_var.*multisplit_nhost/s/256/$nhost/
    /default_var.*load_balance_phase/s/0/$1/
    /default_var.*msoptfactor/s/8/$MSOPT/
  " init.hoc > _init.hoc
  run $2 $3
}

if test "$PHASE" = 6 ; then
for i in 256 512 1024 2048 ; do
  nhost=$i
  prefix=cxsmall${MSOPT}_$nhost
  STD=stdout$MSOPT
  phase $PHASE 256 $nhost
  $NRNIV -c "{load_file(\"hoc/binfo.hoc\")}" -c "mymetis3(\"$prefix\",$nhost)" \
    >> $SIMDIR/$RESULTDIR/$STD.$i
done
fi

if test "$PHASE" = 7 ; then
for i in 256 512 1024 2048 ; do
rm -f out$i.dat
  nhost=$i
  prefix=cxsmall${MSOPT}_$nhost
  STD=stdout$MSOPT
  phase $PHASE $i $nhost
  sortspike out$i.dat $SIMDIR/$RESULTDIR/out${MSOPT}.$i
done
fi

if test "$PHASE" = 4 ; then
  i=256
  nhost=$i
  prefix=cxsmall_$nhost
  phase $PHASE 256 $nhost
  for nhost in 32 64 128 256 512 ; do
  $NRNIV -c "{load_file(\"hoc/binfo.hoc\")}" -c "mymetis2(\"cxsmall_whole\",$nhost)" \
    >> $SIMDIR/$RESULTDIR/stdout.$i
  done
fi

if test "$PHASE" = 5 ; then
for i in 32 64 128 256 ; do
  rm -f out$i.dat
  nhost=$i
  prefix=cxsmall_$nhost
  phase $PHASE $nhost $nhost
  sortspike out$i.dat $SIMDIR/$RESULTDIR/out.$i
done
fi

freepart $PART

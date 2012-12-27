#!/bin/sh

NRNIV=/home/hines/neuron/nrnmpi/x86_64/bin/nrniv

np=1
PHASE=0
if test "$1" != "" ; then
	PHASE="$1"
fi

run() {
  np=$1
  shift
  echo "mpiexec -n $np $NRNIV -mpi $*"
  mpiexec -n $np $NRNIV -mpi $*
}

phase() {
 np=$1
 p=$2
 shift
 shift
 run $np -c "load_balance_phase=$p" $*
}

# create mcomplex.dat
if test "$PHASE" = "1" ; then
phase 1 $PHASE init.hoc
fi

# whole cell load balance with specified prefix and nhost
if test "$PHASE" = "4" ; then
prefix=cxwhole
nhost=256
sed "
/default_var.*wholecell_prefix/s/cxwhole/$prefix/
" init.hoc > _init.hoc
phase 4 $PHASE _init.hoc
run 1 -c "{load_file(\"hoc/binfo.hoc\")}" -c "mymetis2(\"$prefix\",$nhost)"
fi

#whole cell load balance run with specified prefix
if test "$PHASE" = "5" ; then
prefix=cxwhole
nhost=256
if test "$2" != "" ; then
  nhost="$2"
fi

sed "
/default_var.*wholecell_prefix/s/cxwhole/$prefix/
" init.hoc > _init.hoc
phase $nhost $PHASE _init.hoc
sortspike out$nhost.dat out$nhost.$PHASE
rm out$nhost.dat
fi

# base round robin run
if test "$PHASE" = "0" ; then
nhost=256
if test "$2" != "" ; then
  nhost="$2"
fi
phase $nhost $PHASE init.hoc
sortspike out$nhost.dat out$nhost.$PHASE
rm out$nhost.dat
fi

# multisplit load balance with specified prefix and nhost
if test "$PHASE" = "6" ; then
prefix=cx
nhost=256
if test "$2" != "" ; then
  nhost="$2"
fi
sed "
/default_var.*multisplit_prefix/s/cx/$prefix/
/default_var.*multisplit_nhost/s/256/$nhost/
" init.hoc > _init.hoc
phase 4 $PHASE _init.hoc
run 1 -c "{load_file(\"hoc/binfo.hoc\")}" -c "mymetis3(\"$prefix\",$nhost)"
#run 1 -c "{load_file(\"hoc/binfo.hoc\")}" -c "mkbalinfo(\"$prefix\",$nhost)"
fi


# multisplit load balance run
if test "$PHASE" = "7" ; then
prefix=cx
nhost=256
if test "$2" != "" ; then
  nhost="$2"
fi
sed "
/default_var.*multisplit_prefix/s/cx/$prefix/
" init.hoc > _init.hoc
phase $nhost $PHASE _init.hoc
sortspike out$nhost.dat out$nhost.$PHASE
rm out$nhost.dat
fi




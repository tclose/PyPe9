#! /bin/sh

# This script runs all testscripts that use the unittest library.
# unittest provides functions that quit NEST with a non-zero exit
# code upon errors. This is checked here and used to print a nice
# summary after all tests have been run.

print_help="false"
test_pynest="false"
exit_code=0
last_arg=

while [ $# -gt 0 ]
do
    case "$1" in
        --help)         print_help=true;;
	--test-pynest)  test_pynest=true;;
	*)              print_help=true; exit_code=1; last_arg=$1
                        break;;  # terminate while loop
    esac
    shift
done

if [ $print_help = "true" ]; then
  echo
  if [ $exit_code -eq 1 ]; then
    echo "Unknown option: $last_arg" 
  fi
  echo "Usage: do_tests.sh [options ...]"
  echo
  echo "Options:"
  echo "  --help               Print program options and exit"
  echo "  --test-pynest        Test the PyNEST installation and APIs"
  echo
  exit $exit_code
fi

# For testing this script, these files may be handy:
# they return a specific exit code.
#  exitcode0.sli
#  exitcode1.sli
#  exitcode2.sli
#  exitcode3.sli
#  exitcode126.sli
#  exitcode99.sli

nestbinary=nest_serial
logfile=$PWD/installcheck.log
testsuite_basedir=/usr/local/share/doc/nest

python_exec=/usr/bin/python
python_testscript=/usr/local/share/nest/extras/do_tests.py
pythonpath_prefix=/usr/local/lib/python2.6
pythonpath=$pythonpath_prefix/site-packages/:$pythonpath_prefix/dist-packages/
export PYTHONPATH=$pythonpath:$PYTHONPATH

TMPDIR=`mktemp -d -t nest.XXXX`
export NEST_DATA_PATH=$TMPDIR

#########################
# function run_testscript
#
#   Synopsis: run_testscript <scriptname>
#
#   Description:
#     The function runs the NEST binary with the SLI script
#     <scriptname>.
#     The exit code is then transformed into a human readable string
#     (if possible) using the global variables (successcodes) and
#     (failcodes) which contain a comma separated list of exit codes
#     and strings describing the the exit code.
#     If either (successcodes) or (failcodes) contain an entry for the
#     exit code, the respective string is logged, and the test is
#     either counted as passed or failed.
#     If neither (successcodes) nor (failcodes) contains an entry !=
#     "" for the returned exit code, the pass is counted as failed,
#     too, and "unexpected exit code is logged).
#     
#   Parameters:
#     <scriptname>: Name of a .sli script in $testsuite_basedir/tests/
#
#   Used global variables:
#     result: string that records all test results.
#     (successcodes): variable that contains an explanation string for 
#                     all exit codes that are to be regarded as a success.
#     (failcodes): variable that contains an explanation string for 
#                  all exit codes that are to be regarded as a failure.
#     Examples:
#       successcodes=" 0 Success"
#       failcodes=" 1 Failed: missed assertion,"\
#       " 2 Failed: error in tested code block,"\
#       " 3 Failed: tested code block failed to fail,"\
#       " 126 Failed: error in test script"
#
#   First Version: Ruediger Kupper, 07-jul-2008
#   Modified by Jochen Eppler and Markus Diesmann
#
#########################
run_testscript()
{
    numtests=$(($numtests + 1))
    printf "  Running test '$1'... "
    echo  >>$logfile "Running '$1'... "
    
    local outfile=output.log

    echo $1 | grep -q \.sli
    if [ $? -eq 0 ]; then
      $nestbinary $testsuite_basedir/$1 >$outfile 2>&1
    else
      $python_exec $testsuite_basedir/$1 >$outfile 2>&1
    fi
    local exitcode=$?

    sed 's/^/   > /g' $outfile >>$logfile

    local errormsg=""
    temp=${successcodes##* ${exitcode} }
    message=${temp%%,*}
    if [ "$temp" != "$successcodes" ]; then
        numpassed=$(($numpassed+1))
        explanation=${message}
    else
        temp=${failcodes##* ${exitcode} }
        message=${temp%%,*}
        if [ "$temp" != "$failcodes" ]; then
            numfailed=$(($numfailed+1))
            explanation=${message}
        else
            numfailed=$(($numfailed+1))
            explanation="Failed: unexpected exit code $exitcode"
            errormsg=`cat $outfile`
        fi
    fi

    echo "$explanation"
    rm $outfile

    result="$result$1:*$explanation\n"
    echo >>$logfile "-> $exitcode ($explanation)"
    echo >>$logfile "----------------------------------------"

    # exit on "unexpected" exit code
    if [ -n "$errormsg" ]; then
      echo "$errormsg"
      echo "*** An unexpected exit code usually hints at a bug in the testsuite."
      echo "*** Please send the file installcheck.log to bugs@nest-initiative.org."
      echo
      exit 2
    fi
}

# Under OSX, suppress crash reporter dialogs. Restore old state at end.
if [ `uname -s` = Darwin ] ; then
    CRSTATE=`defaults read com.apple.CrashReporter DialogType`
    defaults write com.apple.CrashReporter DialogType server   # means no logging
fi

numtests=0
numpassed=0
numfailed=0
result=""

echo > $logfile "NEST v. 2.0.0-rc4 Testsuite log"
echo >>$logfile "======================"
echo >>$logfile "Running tests from $testsuite_basedir"

echo
echo "Phase 1: Testing if SLI can execute scripts and report errors."
echo "---------------------------------------------------------------"

successcodes=" 0 Success"
failcodes=""
for test in test_pass.sli test_goodhandler.sli test_lazyhandler.sli; do
    run_testscript selftests/$test
done

successcodes=" 126 Success"
failcodes=""
for test in test_fail.sli test_stop.sli test_badhandler.sli; do
    run_testscript selftests/$test
done

# At this point, we are sure that
#  * NEST will return 0 after finishing a script
#  * NEST will return 126 when a script raises an unhandled error
#  * error handling in stopped contexts works 

echo
echo "Phase 2: Testing SLI's unittest library."
echo "----------------------------------------"

# assert_or_die uses pass_or_die, so pass_or_die should be tested first.

successcodes=" 2 Success"
failcodes=" 126 Failed: error in test script"
run_testscript selftests/test_pass_or_die.sli

successcodes=" 1 Success"
failcodes=" 2 Failed: error in tested code block,"\
" 126 Failed: error in test script"
run_testscript selftests/test_assert_or_die_b.sli
run_testscript selftests/test_assert_or_die_p.sli

successcodes=" 3 Success"
failcodes=" 1 Failed: missed assertion,"\
" 2 Failed: error in tested code block,"\
" 126 Failed: error in test script"
run_testscript selftests/test_fail_or_die.sli

successcodes=" 3 Success"
failcodes=" 1 Failed: missed assertion,"\
" 2 Failed: error in tested code block,"\
" 126 Failed: error in test script"
run_testscript selftests/test_crash_or_die.sli

# At this point, we are sure that
#  * unittest::pass_or_die works
#  * unittest::assert_or_die works
#  * unittest::fail_or_die works
#  * unittest::crash_or_die works

# These are the default exit codes and their explanations.
successcodes=" 0 Success"
failcodes=" 1 Failed: missed SLI assertion,"\
" 2 Failed: error in tested code block,"\
" 3 Failed: tested code block failed to fail,"\
" 4 Failed: re-run serial,"\
" 10 Failed: unknown error,"\
" 125 Failed: unknonw C++ exception,"\
" 126 Failed: error in test script,"\
" 127 Failed: fatal error,"\
" 134 Failed: missed C++ assertion,"\
" 139 Failed: segmentation fault,"

echo
echo "Phase 3: Running NEST unit tests."
echo "---------------------------------"
for ext in sli py; do
    for test in $(ls $testsuite_basedir/unittests/ | grep ".*\.$ext\$"); do
	run_testscript unittests/$test
    done
done

echo
echo "Phase 4: Running regression tests."
echo "---------------------------------"
for ext in sli py; do
    for test in $(ls $testsuite_basedir/regressiontests/ | grep ".*\.$ext$"); do
	run_testscript regressiontests/$test
    done
done

echo
echo "Phase 5: Running MPI tests."
echo "---------------------------"
if [ `sli -c "statusdict/have_mpi :: ="` = "true" ]; then
  nestbinary=nest_indirect
  for test in $(ls $testsuite_basedir/mpitests/ | grep ".*\.sli$"); do
      run_testscript mpitests/$test
  done
else
  echo "  Not running MPI tests because NEST was compiled without support"
  echo "  for distributed computing. See the file README for details."
fi


if [ $test_pynest = "true" ]; then
  $python_exec $python_testscript >> $logfile
  pynest_numtests=`cat pynest_test_numbers | cut -d" " -f1`
  pynest_numpassed=`cat pynest_test_numbers | cut -d" " -f3`
  pynest_numfailed=`cat pynest_test_numbers | cut -d" " -f2`
  rm -f pynest_test_numbers
  numtests=$(( $numtests + $pynest_numtests ))
  numpassed=$(( $numpassed + $pynest_numpassed ))
  numfailed=$(( $numfailed + $pynest_numfailed ))
  result="${result}PyNEST Tests:*Passed: $pynest_numpassed/$pynest_numtests\n"
else
  echo
  echo "Phase 6: Running PyNEST tests."
  echo "------------------------------"
  echo "  Not running PyNEST tests because NEST was compiled without support"
  echo "  for Python. See the file README for details."
fi

echo
echo "NEST Testsuite Summary"
echo "----------------------"
echo "  NEST Executable: "`which nest`
echo "  SLI Executable : "`which sli`
echo "  Total number of tests: $numtests"
echo "     Passed: $numpassed"
echo "     Failed: $numfailed"
echo

if [ $numfailed -gt 0 ]; then
  echo "*** There were errors during the run of the NEST testsuite. Please"
  echo "*** send the file installcheck.log and the content of the directory"
  echo "*** $TMPDIR to bugs@nest-initiative.org."
  echo
else
  rm -rf $TMPDIR
fi

# OSX: Restore old crash reporter state
if [ `uname -s` = Darwin ] ; then
    defaults write com.apple.CrashReporter DialogType $CRSTATE
fi

exit 0
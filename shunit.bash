#!/bin/bash

########################################################################
# DOCUMENTATION
########################################################################

# A functions starting with 'test' will be executed.
#
# 1) Write testcases
#
#     :
#     testHelloWorld() {
#         assertEqual "foo" "foo"
#     }
#     :
#
# 2) Include this script at the end of your test script
#
#    :
#    source $(dirname $0)/shunit
#
# Dependencies are: Bash (BASH_LINENO), Shell colors.

########################################################################
# GLOBALS
########################################################################

verbose=

shunit_passed=0
shunit_failed=0
shunit_skipped=0

########################################################################
# ASSERT FUNCTIONS
########################################################################

runTests() {
    local test_pattern="test[a-zA-Z0-9_]\+"
    local testcases=$(grep "^ *\(function \)*$test_pattern *\\(\\)" $0 | grep -o $test_pattern)

    for tc in $testcases ; do $tc ; done

    echo "Done. $shunit_passed passed. $shunit_failed failed. $shunit_skipped skipped."
    exit $shunit_failed
}

# $1: Output
# $2: Expected
assertEqual() {
    echo $1 | grep -E "^$2$" > /dev/null
    if [ $? -eq 0 ] ; then _passed ; else _failed "$1" "$2" ; fi
}

# $1: Output
# $2: Expected
assertNotEqual() {
    echo $1 | grep -E "^$2$" > /dev/null
    if [ $? -ne 0 ] ; then _passed ; else _failed "$1" "$2" ; fi
}

# $1: Output
# $2: Expected
assertStartsWith() {
    echo $1 | grep -E "^$2" > /dev/null
    if [ $? -eq 0 ] ; then _passed ; else _failed "$1" "$2" ; fi
}

# $1: Output
# $2: Expected
# $?: Provided
assertReturn() {
    local code=$?
    if [ $code -eq $2 ] ; then _passed ; else _failed "$code" "$2" ; fi
}

# $1: Output
# $2: Expected
# $?: Provided
assertNotReturn() {
    local code=$?
    if [ $code -ne $2 ] ; then _passed ; else _failed "$code" "$2" ; fi
}

skip() {
    _skipped
}

_failed() {
    shunit_failed=$((shunit_failed+1))

    local tc=${FUNCNAME[2]}
    local line=${BASH_LINENO[1]}
    echo -e "\033[37;1m$tc\033[0m:$line:\033[31mFailed\033[0m"
    if [ $verbose ] ; then
        echo -e "\033[31mExpected\033[0m: $2"
        echo -e "\033[31mProvided\033[0m: $1"
    fi
}

_passed() {
    shunit_passed=$((shunit_passed+1))

    local tc=${FUNCNAME[2]}
    local line=${BASH_LINENO[1]}

    echo -e "\033[37;1m$tc\033[0m:$line:\033[32mPassed\033[0m"
}

_skipped() {
    shunit_skipped=$((shunit_skipped+1))

    local tc=${FUNCNAME[2]}
    local line=${BASH_LINENO[1]}
    echo -e "\033[37;1m$tc\033[0m:$line:\033[33mSkipped\033[0m"
}

########################################################################
# RUN
########################################################################

# Arguments
while [ $# -gt 0 ]; do
    arg=$1; shift
    case $arg in
        "-v"|"--verbose") verbose=1;;
        *) shift;;
    esac
done

runTests

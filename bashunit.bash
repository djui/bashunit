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
#    source $(dirname $0)/bashunit.bash
#
# Dependencies are: Bash (BASH_LINENO), Shell colors.

########################################################################
# GLOBALS
########################################################################

verbose=

bashunit_passed=0
bashunit_failed=0
bashunit_skipped=0

########################################################################
# ASSERT FUNCTIONS
########################################################################

runTests() {
    local test_pattern="test[a-zA-Z0-9_]\+"
    local testcases=$(grep "^ *\(function \)*$test_pattern *\\(\\)" $0 | grep -o $test_pattern)

    for tc in $testcases ; do $tc ; done

    echo "Done. $bashunit_passed passed. $bashunit_failed failed. $bashunit_skipped skipped."
    exit $bashunit_failed
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
    bashunit_failed=$((bashunit_failed+1))

    local tc=${FUNCNAME[2]}
    local line=${BASH_LINENO[1]}
    echo -e "\033[37;1m$tc\033[0m:$line:\033[31mFailed\033[0m"
    if [ $verbose ] ; then
        echo -e "\033[31mExpected\033[0m: $2"
        echo -e "\033[31mProvided\033[0m: $1"
    fi
}

_passed() {
    bashunit_passed=$((bashunit_passed+1))

    local tc=${FUNCNAME[2]}
    local line=${BASH_LINENO[1]}

    echo -e "\033[37;1m$tc\033[0m:$line:\033[32mPassed\033[0m"
}

_skipped() {
    bashunit_skipped=$((bashunit_skipped+1))

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

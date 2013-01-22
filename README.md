# Introduction

`bashunit` is a unit testing framework for Bash scripts based on xUnit principles.

This is similar to the [ShUnit](http://shunit.sourceforge.net/) and its
successor [shUnit2](https://code.google.com/p/shunit2/).

# Usage

Functions starting with 'test' will be automatically evaluated.

1. Write test cases

    :
    testEcho() {
        assertEqual "$(echo foo)" "foo"
        assertReturn "$(echo foo)" 0
    }
    :

2. Include this script at the end of your test script

    :
    source $(dirname $0)/bashunit.bash
    # eof

3. Run test suite

    $ test_example
    testEcho:4:Passed
    testEcho:5:Passed
    Done. 2 passed. 0 failed. 0 skipped.

# Dependencies

* Bash (BASH_LINENO)
* Shell colours

# API

* `assertEqual($1, $2)`
    `$1`: Output
    `$2`: Expected

    Assert that a given output string is equal to an expected string.

* `assertNotEqual($1, $2)`
    `$1`: Output
    `$2`: Expected

    Assert that a given output string is not equal to an expected
    string.

* `assertStartsWith($1, $2)`
    `$1`: Output
    `$2`: Expected

    Assert that a given output string starts with an expected string.

* `assertReturn($1, $2)`
    `$1`: Output
    `$2`: Expected
    `$?`: Provided

    Assert that the last command's return code is equal to an expected
    integer.

* `assertNotReturn($1, $2)`
    `$1`: Output
    `$2`: Expected
    `$?`: Provided

    Assert that the last command's return code is not equal to an
    expected integer.

* `skip()`

    Skip the current test case.

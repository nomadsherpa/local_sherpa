#!/bin/bash

run_single_test() {
  _tests_passed=true

  echo "== Running $1"
  zsh $1 || _tests_passed=false
  echo ""

  if $_tests_passed; then
    echo -e "\033[32mTest passed successfully!\033[0m"
  else
    echo -e "\033[31mTest failed.\033[0m"
  fi
}

run_all_tests() {
  _test_files=(tests/**/*_test.sh)
  _all_tests_passed=true

  for file in "${_test_files[@]}" ; do
    echo "== Running $file"
    zsh $file || _all_tests_passed=false
    echo ""
  done

  if $_all_tests_passed; then
    echo -e "\033[32mAll tests passed successfully!\033[0m"
  else
    echo -e "\033[31mSome tests failed.\033[0m"
  fi
}



if [ -n "$1" ]; then
  _test_file=$1
  run_single_test "$_test_file"
else
  run_all_tests
fi

source tests/support/init.sh

plan_no_plan

# Setup
cd playground
source .bash_profile # Imitate global env

# When the user goes to a project with an untrusted local env file
actual_warning_message=$(SHERPA_LOG_LEVEL='info' ; cd project_1)
expected_warning_message="The local env file is not trusted."

# Sherpa warns the user
like "$actual_warning_message" "$expected_warning_message" 'It warns when the local env file is not trusted'

# And it doesn't load the local env
cd project_1
is "$var_1" "GLOBAL VAR" "Untrusted local env is not loaded (var)"
is "$(alias_1)" "GLOBAL ALIAS" "Untrusted local env is not loaded (alias)"
is "$(function_1)" "GLOBAL FUNCTION" "Untrusted local env is not loaded (function)"

# When the user trusts the local env file
sherpa trust

# Sherpa loads the local env
is "$var_1" "LOCAL VAR PROJECT 1" "Local env is loaded (var)"
is "$(alias_1)" "LOCAL ALIAS PROJECT 1" "Local env is loaded (alias)"
is "$(function_1)" "LOCAL FUNCTION PROJECT 1" "Local env is loaded (function)"


# Tear down
rm -rf $SHERPA_CHECKSUM_DIR

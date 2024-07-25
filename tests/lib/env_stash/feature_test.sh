source tests/support/test_helper.sh
source "$SHERPA_DIR/lib/env_stash/utils.sh"
source "$SHERPA_DIR/lib/env_stash/aliases.sh"
source "$SHERPA_DIR/lib/env_stash/functions.sh"

# 〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰
#                      Stashing and unstashing environment
# 〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰〰

# ==============================================================================
# ++++ We can stash and unstash aliases

alias existing_alias1="echo existing_alias1 original content"
alias existing_alias2="echo existing_alias2 original content"

sherpa::env_stash.stash_aliases "$PWD" "existing_alias1" \
                                       "existing_alias2" \
                                       "not_yet_existing_alias1" \
                                       "not_yet_existing_alias2"

alias existing_alias1="echo CHANGED 1"
alias existing_alias2="echo CHANGED 2"
alias not_yet_existing_alias1="echo not_yet_existing_alias1 content"
alias not_yet_existing_alias2="echo not_yet_existing_alias2 content"

# Senety check
is "$(existing_alias1)" "CHANGED 1" "The existed alias1 changed"
is "$(existing_alias2)" "CHANGED 2" "The existed alias2 changed"
is "$(not_yet_existing_alias1)" "not_yet_existing_alias1 content" "The new alias1 is set"
is "$(not_yet_existing_alias2)" "not_yet_existing_alias2 content" "The new alias2 is set"

sherpa::env_stash.unstash_aliases "$PWD"

# ++++ It restores the overwritten aliases
is "$(existing_alias1)" "existing_alias1 original content" "The existed alias1 is restored"
is "$(existing_alias2)" "existing_alias2 original content" "The existed alias2 is restored"
# ++++ It removes the aliases which did not exist at the time of stashing
is_undefined "not_yet_existing_alias1" "The new alias1 is removed"
is_undefined "not_yet_existing_alias2" "The new alias2 is removed"


# ==============================================================================
# ++++ We can stash and unstash functions

# shellcheck disable=SC2317
existing_function1() { echo "existing_function1 original content"; }
# shellcheck disable=SC2317
existing_function2() { echo "existing_function2 original content"; }

sherpa::env_stash.stash_functions "$PWD" "existing_function1" \
                                         "existing_function2" \
                                         "not_yet_existing_function1" \
                                         "not_yet_existing_function2"


existing_function1() { echo "CHANGED 1"; }
existing_function2() { echo "CHANGED 2"; }

not_yet_existing_function1() { echo "not_yet_existing_function1 content"; }
not_yet_existing_function2() { echo "not_yet_existing_function2 content"; }

# Senety check
is "$(existing_function1)" "CHANGED 1" "The existing_function1 changed"
is "$(existing_function2)" "CHANGED 2" "The existing_function2 changed"
is "$(not_yet_existing_function1)" "not_yet_existing_function1 content" "The new function 1 is set"
is "$(not_yet_existing_function2)" "not_yet_existing_function2 content" "The new function 2 is set"

sherpa::env_stash.unstash_functions "$PWD"

# ++++ It restores the overwritten functiones
is "$(existing_function1)" "existing_function1 original content" "The existed function1 is restored"
is "$(existing_function2)" "existing_function2 original content" "The existed function2 is restored"
# ++++ It removes the functiones which did not exist at the time of stashing
is_undefined "not_yet_existing_function1" "The new function 1 is removed"
is_undefined "not_yet_existing_function2" "The new function 2 is removed"

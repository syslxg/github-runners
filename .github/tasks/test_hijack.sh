set -x
echo step 1
export lvar3=foobar
source $GITHUB_WORKSPACE/.github/tasks/start_tmate.sh
hijack
echo step2
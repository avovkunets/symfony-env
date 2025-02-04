function check_status() {
  if [ $? -eq 0 ]; then
    ok
  else
    if [ ! -z "$1" ]; then
      fail "$1"
    else
      fail "Process failed"
    fi
    exit
  fi
}

function check_git_branch() {
  # check if remote branch exists
    if ! git ls-remote --exit-code --quiet --heads ${repo} "${GIT_BRANCH}" >/dev/null; then
        error "Remote branch doesn't exist — ${YELLOW}${GIT_BRANCH}${NORM}"
        exit
    fi
}
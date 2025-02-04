NORM=$(tput sgr0)
BOLD=$(tput bold)
REV=$(tput smso)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)

function ok() {
  echo "${GREEN}✔${NORM} $1"
}
function info() {
  echo "${YELLOW}$1${NORM}"
}
function task() {
  echo -n "➤ ${YELLOW}$1${NORM} "
}
function ask() {
    echo "${CYAN}$1${NORM}"
}
function fail() {
  echo "${RED}✖${NORM} $1"
}
function error() {
  HAS_ERRORS=true
  echo "${RED}✖ $1${NORM}"
}
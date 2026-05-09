#!/bin/sh
# install.sh — Cross-platform skill installation script for browser-auto
# POSIX-compatible (works in bash, dash, zsh, ash, etc.)

set -eu

SKILL_NAME="browser-auto"
VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Colors
if [ -t 1 ]; then
    RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
    BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'
else
    RED=''; GREEN=''; YELLOW=''; BLUE=''; BOLD=''; NC=''
fi

info()    { printf "${BLUE}[INFO]${NC}  %s\n" "$1"; }
success() { printf "${GREEN}[OK]${NC}    %s\n" "$1"; }
warn()    { printf "${YELLOW}[WARN]${NC}  %s\n" "$1"; }
error()   { printf "${RED}[ERROR]${NC} %s\n" "$1" >&2; }

show_help() {
    cat <<EOF
${BOLD}install.sh${NC} — Install the ${BOLD}${SKILL_NAME}${NC} skill (v${VERSION})

USAGE
    ./install.sh [OPTIONS]

OPTIONS
    --platform PLATFORM   claude-code, cursor, copilot, etc.
    --project             Install at project level (current directory)
    --path PATH           Custom install path
    --all                 Install to ALL detected tools
    --dry-run             Preview without changes
    -h, --help            Show help

EXAMPLES
    ./install.sh                          # Auto-detect
    ./install.sh --platform cursor        # Force Cursor
    ./install.sh --all                    # All detected platforms
EOF
}

PLATFORM=""; PROJECT_LEVEL=false; CUSTOM_PATH=""; DRY_RUN=false; INSTALL_ALL=false

parse_args() {
    while [ $# -gt 0 ]; do
        case "$1" in
            --platform) [ $# -ge 2 ] || { error "Missing value for --platform"; exit 1; }; PLATFORM="$2"; shift 2 ;;
            --project) PROJECT_LEVEL=true; shift ;;
            --path) [ $# -ge 2 ] || { error "Missing value for --path"; exit 1; }; CUSTOM_PATH="$2"; shift 2 ;;
            --all) INSTALL_ALL=true; shift ;;
            --dry-run) DRY_RUN=true; shift ;;
            -h|--help) show_help; exit 0 ;;
            *) error "Unknown option: $1"; show_help; exit 1 ;;
        esac
    done
}

validate_skill_md() {
    skill_md="${SCRIPT_DIR}/SKILL.md"
    if [ ! -f "$skill_md" ]; then error "SKILL.md not found"; exit 1; fi
    first_line="$(head -n 1 "$skill_md")"
    if [ "$first_line" != "---" ]; then error "SKILL.md must start with ---"; exit 1; fi
    success "SKILL.md validated"
}

detect_platform() {
    if [ -n "$PLATFORM" ]; then return 0; fi
    if [ -d "${HOME}/.claude" ]; then PLATFORM="claude-code"
    elif [ -d ".cursor" ] || [ -d "${HOME}/.cursor" ]; then PLATFORM="cursor"
    elif [ -d ".windsurf" ] || [ -d "${HOME}/.codeium/windsurf" ]; then PLATFORM="windsurf"
    elif [ -d ".github" ] || [ -d "${HOME}/.copilot" ]; then PLATFORM="copilot"
    elif [ -d "${HOME}/.agents" ]; then PLATFORM="universal"
    else error "No platform detected. Use --platform."; exit 2; fi
    info "Detected platform: ${PLATFORM}"
}

resolve_install_path() {
    if [ -n "$CUSTOM_PATH" ]; then INSTALL_DIR="$CUSTOM_PATH"; return 0; fi
    base=""
    if $PROJECT_LEVEL; then
        case "$PLATFORM" in claude-code) base=".claude/skills" ;; copilot) base=".github/skills" ;; cursor) base=".cursor/rules" ;; windsurf) base=".windsurf/rules" ;; *) base=".agents/skills" ;; esac
        INSTALL_DIR="$(pwd)/${base}/${SKILL_NAME}"
    else
        case "$PLATFORM" in claude-code) base="${HOME}/.claude/skills" ;; copilot) base="${HOME}/.copilot/skills" ;; cursor) base="${HOME}/.cursor/rules" ;; windsurf) base="${HOME}/.codeium/windsurf/skills" ;; *) base="${HOME}/.agents/skills" ;; esac
        INSTALL_DIR="${base}/${SKILL_NAME}"
    fi
    info "Install to: ${INSTALL_DIR}"
}

install_files() {
    install_script_name="$(basename "$0")"
    if $DRY_RUN; for f in "${SCRIPT_DIR}"/*; do [ -e "$f" ] || continue; fn="$(basename "$f")"; [ "$fn" = "$install_script_name" ] && continue; info "Would copy: $fn"; done; return 0; fi
    if [ -d "$INSTALL_DIR" ]; then rm -rf "$INSTALL_DIR"; fi
    mkdir -p "$INSTALL_DIR"
    for f in "${SCRIPT_DIR}"/*; do [ -e "$f" ] || continue; fn="$(basename "$f")"; [ "$fn" = "$install_script_name" ] && continue; cp -R "$f" "${INSTALL_DIR}/"; done
    success "Installed to ${INSTALL_DIR}"
}

print_activation_instructions() {
    if $DRY_RUN; return 0; fi
    printf "\n${GREEN}${BOLD}Installation complete!${NC}\n\n"
    printf "To use it, open a new session and type:\n\n"
    printf "  ${BOLD}/browser-auto${NC} Open baidu, search weather, take screenshot\n\n"
    printf "Installed at: ${INSTALL_DIR}/SKILL.md\n"
}

main() {
    printf "${BOLD}Installing skill: ${SKILL_NAME}${NC}\n"
    printf "%.40s\n" "----------------------------------------"
    parse_args "$@"
    validate_skill_md
    if $INSTALL_ALL; then
        detect_platform; resolve_install_path; install_files; print_activation_instructions
    else
        detect_platform; resolve_install_path; install_files; print_activation_instructions
    fi
    exit 0
}

main "$@"

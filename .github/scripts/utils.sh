#!/usr/bin/env bash

set_output() {
  local name="$1"
  local value="$2"
  local fallback="${3:-_not provided_}"
  if [[ -z "$value" ]]; then
    value="$fallback"
  fi

  echo "::notice title=Output::$name::${value}"
  echo "${name}<<EOF" >> "$GITHUB_OUTPUT"
  echo "$value" >> "$GITHUB_OUTPUT"
  echo "EOF" >> "$GITHUB_OUTPUT"
}

# Get the path to the cached issue JSON file (always returns the same path)
get_issue_json_path() {
  echo "/tmp/gh_issue.json"
}

# Store issue JSON in a temp file under /tmp (reuses get_issue_json_path)
cache_issue_json() {
  local issue_number="$1"
  local repo="$2"
  local cache_file
  cache_file=$(get_issue_json_path)

  gh issue view "$issue_number" --repo "$repo" --json title,state,assignees,comments,labels > "$cache_file"
}

# 🔎 Find an issue number by label (most recently updated), prints the number to stdout
# Usage: find_issue_number_by_label "<repo>" "<label>" ["state"]
find_issue_number_by_label() {
  local repo="$1"
  local label="$2"
  local state="${3:-all}"

  local number
  number=$(gh issue list \
    --repo "$repo" \
    --label "$label" \
    --state "$state" \
    --limit 100 \
    --json number,updatedAt \
    --jq 'sort_by(.updatedAt) | reverse | .[0].number')

  if [[ -z "$number" || "$number" == "null" ]]; then
    return 1
  fi

  echo "$number"
}

# 🧊 Convenience: find + cache the issue JSON by label. Prints the number to stdout.
# Usage: cache_issue_by_label "<label>" "<repo>" ["state"]
cache_issue_by_label() {
  local label="$1"
  local repo="$2"
  local state="${3:-all}"

  local issue_number
  if ! issue_number=$(find_issue_number_by_label "$repo" "$label" "$state"); then
    set_output "message" "❌ **No issue labeled \`$label\` found**"
    return 1
  fi

  cache_issue_json "$issue_number" "$repo"
  echo "$issue_number"
}

validate_issue() {
  local required_label="${1:-}"  # optional third argument

  echo "🔎 Validating issue..."

  local json_file
  json_file=$(get_issue_json_path)

  if [[ ! -f "$json_file" ]]; then
    echo "❌ Cached issue JSON not found at $json_file"
    set_output "message" "❌ **Internal error: Issue JSON not cached.**"
    return 1
  fi

  # Check if issue is open
  local state
  state=$(jq -r '.state' "$json_file")
  if [[ "$state" != "OPEN" ]]; then
    set_output "message" "❌ **Issue must be open. Current state: $state**"
    return 1
  fi

  # Check if issue is assigned
  local assignee_count
  assignee_count=$(jq -r '.assignees | length' "$json_file")
  if [[ "$assignee_count" -eq 0 ]]; then
    set_output "message" "❌ **Issue must be assigned to at least one user.**"
    return 1
  fi

  # Check for required label if provided
  if [[ -n "$required_label" ]]; then
    local label_found
    label_found=$(jq -r --arg lbl "$required_label" '.labels[].name | select(. == $lbl)' "$json_file")
    if [[ -z "$label_found" ]]; then
      set_output "message" "❌ **Issue must be labeled with \`$required_label\`**"
      return 1
    fi
  fi

  echo "✅ Issue validated."
}

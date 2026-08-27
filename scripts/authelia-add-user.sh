#!/usr/bin/env bash
# Add a user to the Authelia users database
#
# Usage: ./scripts/authelia-add-user.sh <username> <email> <password> [group1,group2,...]

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

USERS_DB="$PROJECT_DIR/authelia/users_database.yml"

AUTH_USERNAME="${1:-}"
AUTH_EMAIL="${2:-}"
AUTH_PASSWORD="${3:-}"
AUTH_GROUPS="${4:-admin}"

[[ -n "$AUTH_USERNAME" ]] || error "Usage: $0 <username> <email> <password> [groups]"
[[ -n "$AUTH_EMAIL" ]]    || error "Usage: $0 <username> <email> <password> [groups]"
[[ -n "$AUTH_PASSWORD" ]] || error "Usage: $0 <username> <email> <password> [groups]"

# Create the file with the YAML header if it doesn't exist
if [[ ! -f "$USERS_DB" ]]; then
  info "Creating users database..."
  printf '%s\n' "---" "users:" > "$USERS_DB"
fi

# Check if user already exists
if grep -q "^  ${AUTH_USERNAME}:" "$USERS_DB" 2>/dev/null; then
  error "User '$AUTH_USERNAME' already exists in $USERS_DB"
fi

info "Generating password hash for '$AUTH_USERNAME'..."
AUTH_HASH=$(docker run --rm authelia/authelia:latest authelia crypto hash generate argon2 --password "$AUTH_PASSWORD" 2>/dev/null | sed 's/^Digest: //')

[[ "$AUTH_HASH" == \$* ]] || error "Failed to generate password hash"

# Build groups YAML list
IFS=',' read -ra AUTH_GROUP_ARRAY <<< "$AUTH_GROUPS"
AUTH_GROUPS_YAML=""
for g in "${AUTH_GROUP_ARRAY[@]}"; do
  AUTH_GROUPS_YAML="${AUTH_GROUPS_YAML}      - ${g}"$'\n'
done

# Append user to the database
{
  printf '  %s:\n' "$AUTH_USERNAME"
  printf '    disabled: false\n'
  printf '    displayname: %s\n' "$AUTH_USERNAME"
  printf '    email: %s\n' "$AUTH_EMAIL"
  printf '    password: "%s"\n' "$AUTH_HASH"
  printf '    groups:\n'
  printf '%s' "$AUTH_GROUPS_YAML"
} >> "$USERS_DB"

chmod 600 "$USERS_DB"

info "User '$AUTH_USERNAME' added. Restart authelia to apply: make recreate s=authelia"

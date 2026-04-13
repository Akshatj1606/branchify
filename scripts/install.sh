#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TARGET_REPO=$1

if [ -z "$TARGET_REPO" ]; then
    echo "Usage: ./install.sh <target-repo-path>"
    exit 1
fi

if [ ! -d "$TARGET_REPO/.git" ]; then
    echo "Error: Target is not a git repository"
    exit 1
fi

echo "Installing Branchify into $TARGET_REPO"

BRANCHIFY_DIR="$TARGET_REPO/.branchify"
SCRIPTS_DIR="$BRANCHIFY_DIR/scripts"

# Create directory structure
mkdir -p "$BRANCHIFY_DIR/environments/dev"
mkdir -p "$BRANCHIFY_DIR/environments/staging"
mkdir -p "$BRANCHIFY_DIR/environments/prod"
mkdir -p "$SCRIPTS_DIR"

# Copy scripts
cp "$SCRIPT_DIR/switch-env.sh" "$SCRIPTS_DIR/"
cp "$SCRIPT_DIR/branchify.sh" "$SCRIPTS_DIR/branchify"

chmod +x "$SCRIPTS_DIR/switch-env.sh"
chmod +x "$SCRIPTS_DIR/branchify"

# Create environment configs
if [ ! -f "$BRANCHIFY_DIR/environments/dev/.env" ]; then
    echo "ENV=development" > "$BRANCHIFY_DIR/environments/dev/.env"
fi

if [ ! -f "$BRANCHIFY_DIR/environments/staging/.env" ]; then
    echo "ENV=staging" > "$BRANCHIFY_DIR/environments/staging/.env"
fi

if [ ! -f "$BRANCHIFY_DIR/environments/prod/.env" ]; then
    echo "ENV=production" > "$BRANCHIFY_DIR/environments/prod/.env"
fi

# Install Git hook
HOOK="$TARGET_REPO/.git/hooks/post-checkout"

cat << 'EOF' > "$HOOK"
#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

cd "$REPO_ROOT"

bash ".branchify/scripts/switch-env.sh"
EOF

chmod +x "$HOOK"

# Ensure .gitignore exists
if [ ! -f "$TARGET_REPO/.gitignore" ]; then
    touch "$TARGET_REPO/.gitignore"
fi

# Add .branchify to gitignore
if ! grep -q "^.branchify/" "$TARGET_REPO/.gitignore"; then
    echo ".branchify/" >> "$TARGET_REPO/.gitignore"
fi

echo ""
echo "Branchify installed successfully."
echo "Files installed in: $BRANCHIFY_DIR"
echo ""
echo "Run commands using:"
echo "./.branchify/scripts/branchify status"
echo "./.branchify/scripts/branchify create <branch>"
echo "./.branchify/scripts/branchify delete <branch>"
echo ""
echo "Switch branches to trigger automatic environment provisioning."

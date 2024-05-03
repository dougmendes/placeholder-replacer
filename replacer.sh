#!/bin/bash

# Start message
echo "Starting placeholder substitution in the pom.xml file..."

# Check operating system
OS="$(uname)"
echo "Operating System detected: $OS"

# Parse YAML file and substitute placeholders
while IFS=: read -r placeholder value || [ -n "$placeholder" ]; do
    # Remove leading/trailing whitespace from placeholder and value
    placeholder=$(echo "$placeholder" | sed 's/^[ \t]*//;s/[ \t]*$//')
    value=$(echo "$value" | sed 's/^[ \t]*//;s/[ \t]*$//')

    # Check if operating system is macOS, use sed with empty string for -i
    if [[ "$OS" == "Darwin" ]]; then
        sed -i '' "s|{{$placeholder}}|$value|g" pom.xml
    else
        sed -i "s|{{$placeholder}}|$value|g" pom.xml
    fi
done < <(yq eval 'map(select(. != null)) | .[] | "\(.placeholder):\(.value)"' config.yaml)

# Completion message
echo "Placeholder substitution completed."

# Exit the script
exit 0

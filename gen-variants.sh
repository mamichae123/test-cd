#!/bin/bash

readonly TEMPLATE="variant-temp.yaml"
readonly DEFAULT_VARIANTS=2000
readonly DEFAULT_REWRITE=false

NUM_FILES=$DEFAULT_VARIANTS
REWRITE=$DEFAULT_REWRITE

print_help() {
  echo "usage: ./gen-variants.sh num-variants-arg rewrite"
  echo "  - num-variants-arg (int) is the number of variants you would like to generate, default ($DEFAULT_VARIANTS), set to ($NUM_FILES)"
  echo "  - rewrite (bool) is if you wish to rewrite files that are already generated, default ($DEFAULT_REWRITE), set to ($REWRITE)"
}
if [ -n "$1" ]; then
  NUM_FILES=$1
fi 

if [ -n "$2" ]; then
  if [[ $2 == 1 || $2 == true || $2 == "1" || $2 == "true" || $2 == "TRUE" ]]; then
    REWRITE=true
  fi
fi
print_help
# Check if the template file exists
if [ ! -f "$TEMPLATE" ]; then
   echo "Error: Template file '$TEMPLATE' not found."
   exit 1
fi

# Loop through the number of files
for i in $(seq -f "%04g" 1 $NUM_FILES); do
  # Create the new file name
  NEW_FILE="variant-$i.yaml"

  if [ -e "$NEW_FILE" ]; then
    continue
  fi

  # Copy the template to the new file
  cp "$TEMPLATE" "$NEW_FILE"
  sed -e "s/\${name}/variant-${i}/" "$NEW_FILE"

  # Print a message
  echo "Created file: $NEW_FILE"
done

echo "Finished creating $NUM_FILES files."

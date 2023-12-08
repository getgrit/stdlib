#!/bin/bash

# test.sh should be run from the current directory: hcl/.grit/patterns/test_edit_module

set -e
cp input/main.tf input/main.tf.bak                      # 1. Backup input.tf
grit apply ../edit_module.md --force --suppress-output  # 2. Apply pattern
diff input/main.tf expected/main.tf                     # 3. Check that the modified input.tf equals expect.tf
mv input/main.tf.bak input/main.tf                      # 4. Restore input.tf from the backup
echo "Test successful"

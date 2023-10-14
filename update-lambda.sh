#!/bin/bash

# Loop through Lambda function directories
for dir in lambda-*; do
  lambda_name="${dir}"

  # Check for code changes in the Git repo
  if git diff --quiet "$dir"; then
    echo "No changes detected in $dir."
  else
    # New code detected; create a new ZIP file
    cd "$dir"
    zip -r "../$lambda_name.zip" .

    # Update the Lambda function
    if aws lambda update-function-code --function-name "$lambda_name" --zip-file "fileb://../$lambda_name.zip"; then
      echo "Command succeeded, clean up the ZIP file"
      rm "../$lambda_name.zip"
      echo "Updated $lambda_name."
    else
      # Command failed, print an error message and exit
      echo "Error updating $lambda_name."
      exit 1
    fi

    cd ..
  fi
done

#!/bin/bash

git diff --name-only ${{ github.sha }} ${{ github.sha }}^ | while read -r file
do
    dir=$(dirname "$file")
    lambda_name="${dir##*/}"
    cd "$dir"
    zip -r "../$lambda_name.zip" .
    aws lambda update-function-code --function-name "$lambda_name" --zip-file "fileb://../$lambda_name.zip"
    rm "../$lambda_name.zip"
    cd ..
done



      

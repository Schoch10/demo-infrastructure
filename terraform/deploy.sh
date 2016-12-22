#!/bin/bash
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
set -e

geo=$GEO
stack=$STACK
target=$TARGET
action=$ACT

while getopts ':g:t:s:a:' opt; do
  case $opt in
    g)
      geo="$OPTARG"
      ;;
    t)
      target="$OPTARG"
      ;;
    s)
      stack="$OPTARG"
      ;;
    a)
      ACTION="$OPTARG"
      ;;
  esac
done

# Set up the AWS Region basd on the geo
case $geo in
  us)
    region="us-east-1"
    ;;
  uk)
    region="eu-central-1"
    ;;
esac

# Set up variables for Terraform remote config
bucket="foodtruck-$geo"
BUCKET_KEY="state/$target-$stack.tfstate"

# Check to make sure the stack exists
if [[ ! -d $SOURCE_DIR/stacks/$stack ]]; then
  echo "ERROR: The stack [$stack] does not exist at $SOURCE_DIR/stacks"
  echo "Try one of the following: "
  for i in $(find $SOURCE_DIR/stacks/ -type d -mindepth 1 -maxdepth 1); do
    echo "  - $(basename $i)"
  done
  exit 1
fi

# Set the base directory for variables
VAR_DIR=$SOURCE_DIR/vars
VARS_FILE_LIST=""

# Read appropriate variable files from default to most granular
for var_file in "default" "$stack" "$target" "$geo/default" "$geo/$stack" "$geo/$target/default" "$geo/$target/$stack" ; do
  [[ -f "$VAR_DIR/$var_file.tfvars" ]] && echo "Found: [$var_file.tfvars]" && VARS_FILE_LIST="$VARS_FILE_LIST -var-file $VAR_DIR/$var_file.tfvars"
done

# Set up TMP dir to run Terraform commands in
TMP_DIR=$SOURCE_DIR/../tmp/$target-$geo-$stack-$(date "+%Y-%m-%d-%H%M%S")
mkdir -p $TMP_DIR

# Initialize terraform backend
cd $TMP_DIR
terraform -version
echo "Initializing Terraform backend for s3://$bucket/$BUCKET_KEY in $region"
terraform init $SOURCE_DIR

# Generate input variable file and add to var file list
cat > $TMP_DIR/vars/inputVars.tfvars << EOF
geo="$geo"
target="$target"
stack="$stack"
region="$region"
EOF

echo
cat $TMP_DIR/vars/inputVars.tfvars
echo

VARS_FILE_LIST="-var-file $TMP_DIR/vars/inputVars.tfvars $VARS_FILE_LIST"


# Set up the Terraform remote state in S3
cd $TMP_DIR/stacks/$stack
terraform remote config -backend="s3" -backend-config="bucket=$bucket" -backend-config="key=$BUCKET_KEY" -backend-config="region=$region"

# Run Terraform!
echo "Executing: [terraform $action $VARS_FILE_LIST]"
terraform get
TF_LOG=debug TF_LOG_PATH=$(pwd)/tf_debug.log terraform $ACTION $VARS_FILE_LIST



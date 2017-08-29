function deploy_helpers::checkVars {
  [[ -z $region ]]  && deploy_helpers::usage
  [[ -z $target ]]  && deploy_helpers::usage
  [[ -z $stack ]]   && deploy_helpers::usage
  return 0
}

function deploy_helpers::usage {
     echo -e "
    ___________________________________________________________________________________________________
    Terraform Deployment Script

      This script is responsible for managing the work around remote state files for Terraform.
      This is based upon the concept of:

    Usage:

        tf_deploy [arguments] [terraform args]

        arguments:
            -r          (required: 'Region' - ex: us-east-1, eu-west-1 - Env default: REGION)

            -t          (required: 'Target' - ex: prod, dev, stg - Env default: TARGET)

            -s          (required: 'Stack' - ex: core, services, etc. - Env default: STACK)

        example usage:
          tf_deploy -g us-east-1 -t dev -s networking plan
    ___________________________________________________________________________________________________
    "
    exit 1
}

function deploy_helpers::checkSourced {
  [[ -z $bucket ]]  && echo "ERROR: an \`export \$bucket\` must be defined in $CONFIG_FILE" && exit 1
  [[ -z $region ]]  && echo "ERROR: an \`export \$region\` must be defined in $CONFIG_FILE" && exit 1
  return 0
}
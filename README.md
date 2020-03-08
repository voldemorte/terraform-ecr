# terraform-ecr
A terraform module to provision ECR repositories

## Getting started
This repository employs [pre-commit](https://pre-commit.com) to perform commit validations.
Cloning this repository for the first time? Please follow the following steps.

1. Install pre-commit for your system. The install steps are available [here](https://pre-commit.com/#installation)
2. Install the pre-commit hooks by running `pre-commit install` and `pre-commit install --hook-type commit-msg`
3. Install the required modules by running `yarn install`

Alternatively you can run `bin/setup` which will run the installation steps for you
(you will need to have [python3](https://www.python.org/downloads/) installed for this).

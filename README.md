# Docker Images
A set of opinionated images to aid in quickly setting up development and production environments.

# Contents
- [Go](./go/README.md)
- [Node](./node/README.md)

# Development
## Automation
Make is used to automate tasks.

## Setting up
Rename `sample.properties` to `Makefile.properties` and change the variables to your own.

## Conventions
Each directory should have a `Makefile` file with a `build` and `publish` recipe which builds and publishes the image respectively. The exact methodology of the building and publishing varies across projects.

# License
This project is licensed under the MIT license.

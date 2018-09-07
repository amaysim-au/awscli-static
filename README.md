# alpine-awscli

This is a static build of the AWS CLI, built for Alpine.

## Builder Image
Base on alpine:latest, an image to build the AWS CLI static binary.
Will be a bit heavy as it includes the build prerequisites.

The awscli will be installed to `/usr/local/bin/aws` in the `builder` image.

## Runtime Image
Base on alpine:latest, a light weight image to be used by clients.

The awscli will be installed to `/usr/local/bin/aws` in the `build` image.

### Runtime Requirements (Installed)
For `help` output to work:
* less
* groff

# Credit
This code is based off / inspired by: https://github.com/richiefi/alpine-awscli

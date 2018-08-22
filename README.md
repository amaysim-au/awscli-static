# alpine-awscli

This is a static build of the AWS CLI, built for Alpine.

## Build Image
Base on alpine:3.8, an image to build the AWS CLI static binary.
Will be a bit heavy as it includes the build prerequisites.

The awscli will be installed to `/usr/local/bin/aws` in the `build` image.

## Runtime Image
Base on alpine:3.8, a light weight image to be used by clients.

The awscli will be installed to `/usr/local/bin/aws` in the `build` image.

### Runtime Requirements
For `help` output to work:
* less
* groff

# Credit
This code is based off / inspired: https://github.com/richiefi/alpine-awscli

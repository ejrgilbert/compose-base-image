# Datawave Docker-Compose Base Image #

This repo houses the code for the Datawave Docker-Compose Base Image. The
image created here isn't meant to be run on its own, it's meant to be
extended for running various components of the Datawave software stack.

The image will start sshd in the foreground by default. It also creates an
entrypoint.d script for starting up with run-parts in image extensions.

We have added the `accumulo`, `datawave`, `hadoop`, and `zookeeper` users
with their own `ssh`keys. The `root` user also has its own `ssh` key which
can be used at `base/resources/sshd/root_key`. This is helpful since the
developer can use this key to ssh into the containers as `root` if they
would like to instead of using the `docker exec` command. The container is
also already preconfigured to allow the users to ssh into the other
containers (if there are multiple running on the host machine).

# How to... #

## Build the Base Image ##
We have automated the process of building the base image in the helper script
(`scripts/build.sh`). If you would like to build a new version, simply run:
`./build.sh base`

The script has some different options to enable to runner to tag and push the built
images. Run `./build.sh help` for more information about these options.

The command format must be as follows (the options should always come *before* the
specified command with a `--` delimiting them:
- `./build.sh [<opt1> <opt2> ... --] <cmd>`

## Deploy a new Base Image Version ##
We have a GitLab job that automatically deploys new Devbox versions to the registry
on `master` branch tags. See `.gitlab-ci.yml` for how this is done. However, if you
would like to do it manually (this is not recommended), you will use the build script.

When running `build.sh`, specify the version you would like to tag the image as via the
`-v` option and add the `-p` option as well to tell the script to push the images to the
registry after they have been built.
```bash
./build.sh -v <ver1> -v <ver2> <ver3> ... -p -- base
```

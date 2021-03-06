# git-builder
[![Build Status](https://travis-ci.org/bithavoc/git-builder.svg?branch=master)](https://travis-ci.org/bithavoc/git-builder)

Builds docker images from Git repositories

> `git clone`, `docker build`, `docker push`... repeat :musical_note:

## Configuration
Use the following environment variables to control the building process

**GIT_REPO:** Any git repository with a `Dockerfile` to clone and build, example: `git@github.com:username/repo.git`
**GIT_REF:** branch name or git commit hash to use, defaults to `master` branch
**IMAGE_TAG:** The docker tag used to push the image to a registry, example: `<username>/<repo>:<tag>`

Requires running as a `privileged` container, no `docker.sock` is necessary.

## Cloning Private Git Repositories

Use the environment variable `SSH_KEY` to provide a base64'd **private key** to access the private repo.

Example:

```bash
$ ssh-keygen -t rsa -b 4096 -q -P "" -C "your_email@example.com" -f deploy_key
$ ls
> deploy_key deploy_key.pub
```
The file `deploy_key` is what you encode as base64:

```bash
base64 deploy_key > deploy_key.key.base64
```

Then you add the content of the file `deploy_key.key.base64` in the `SSH_KEY` env variable.

The other file, `deploy_key.pub`, is what you add to your github repo as [Deploy Key](https://developer.github.com/guides/managing-deploy-keys/)

**Note:** passphrases are not supported in deploy keys

## Pushing to Private Docker Repositories
Use the environment variables `DOCKER_USER` and `DOCKER_PASS`.

`DOCKER_ENDPOINT` is also available to specify a custom registry.

## Example

```
docker run --privileged --name test-git-builder -e "DOCKER_USER=?" -e "DOCKER_PASS=?" -e "SSH_KEY=`deploy_key.key.base64`" -e "GIT_REPO=git@github.com:username/repo.git" -e "IMAGE_TAG=docker-username/docker-repo:docker-repo-tag" bithavoc/git-builder
```

## Without Docker-in-Docker

By default it uses Docker-in-Docker, however, docker sock can also be used by changing `DOCKERD_MODE=sock`.
This option requires mounting `/var/run/docker.sock` as in "docker run ... -v /var/run/docker.sock:/var/run/docker.sock".

## License
MIT

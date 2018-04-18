# Automatically create documentations with MkDocs (aisberg/mkdocs)

Dockerfile to build a [MkDocs](http://www.mkdocs.org/) container image.

## Arguments

| Argument                   | Description                                                        |  Default Value   | Mandatory |
|----------------------------|--------------------------------------------------------------------|:----------------:|:---------:|
| GIT_REPO_URI               | URI to the Git-Repo containing the MkDocs code                     |        -         |    yes    |
| GIT_SSH_KEY                | Path to the SSH-Key used to access the Git-Repo                    |        -         |    yes    |
| GIT_BRANCH                 | Branch to be used                                                  |      master      |    no     |
| ADDITIONAL_PYTHON_PACKAGES | Install specified python packages with PIP                         |        -         |    no     |
| CRON_JOB_SCHEDULE          | Cron schedule to check for changes and build static website files. | \*/5 \* \* \* \* |    no     |

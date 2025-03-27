# Spacecommands

## Overview

**Spacecommands** is a lightweight CLI framework that provides common utility commands and a base Docker setup for any project. It requires no external dependencies (except Docker, which is optional). 

This project is designed for Unix-based systems. Some scripts may not work on Windows without modifications.

## Features

- Easy-to-use CLI for common operations
- Predefined Docker commands for managing containers
- Automatic execution of commands inside the appropriate container
- Autocompletion support with `source ./commands`

## Directory Structure (Simplified)

```
.
├── commands
│   ├── app
│   │   ├── container
│   │   │   ├── build.sh
│   │   │   ├── logs-tail.sh
│   │   │   ├── ...
│   ├── docker
│   │   ├── clean.sh
│   │   ├── ls.sh
│   │   ├── ...
│   ├── fc
│   │   ├── app
│   │   │   ├── migrate
│   │   │   │   ├── generate-migrate.sh
│   │   │   │   ├── up-all.sh
│   │   │   │   ├── ...
│   │   │   ├── tests
│   │   │   │   ├── e2e.sh
│   │   │   │   ├── unit.sh
│   │   │   │   ├── ...
│   │   │   ├── ...
├── commands.sh
├── docker
│   ├── app
│   │   ├── compose.yml
│   │   ├── Dockerfile
│   │   ├── ...
│   ├── db
│   │   ├── compose.yml
│   │   ├── ...
├── README.md
```

## Running Commands

All commands are executed from the host machine using `./commands.sh`. However, commands inside `commands/fc` (fc = "from container") are executed from inside a container. The `commands.sh` script automatically ensures that:

- Regular commands are executed on the host.
- Commands inside `commands/fc` are executed within the **app** container (currently, the script does not support other containers).
- If you run `./commands.sh fc/...` from the host, it will be redirected inside the container.

## Autocompletion

To enable autocompletion when using `./commands.sh`, run:

```sh
source ./commands
```

Now, pressing `[Tab]` after `./commands.sh` will suggest available commands.

## How to Integrate Spacecommands into Your Project

If you want to bring **Spacecommands** into your existing project **without overwriting your .git or existing files**, follow these steps:

### 1. Add Spacecommands as a remote

```sh
git remote add spacecommands git@github.com:spacecodeur/spacecommands.git
```

### 2. Fetch the latest Spacecommands changes

```sh
git fetch spacecommands
```

### 3. Merge Spacecommands into your project (while keeping your files safe)

```sh
git merge --allow-unrelated-histories spacecommands/main -X ours
```

This will:
- **Add new files from Spacecommands** without overwriting existing files in your project.
- **Preserve your own files and modifications**.
- **Allow you to review changes** before committing.

If conflicts appear (e.g., in `.env`), Git will prompt you to manually merge them.

Finally, set the name of your project in the key `APP_NAME` (`.env` file)

### 4. Commit the merge

Once resolved, finalize the integration:

```sh
git commit -am "Merged Spacecommands into project"
```

Now, **Spacecommands** is integrated into your project while keeping your Git history intact!
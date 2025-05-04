# spacebase_commands

## Overview

**spacebase_commands** is a lightweight CLI framework that provides common utility commands and a base Docker setup for any project. It requires no external dependencies (except Docker, which is optional). 

This project is designed for Unix-based systems. Some scripts may not work on Windows without modifications.

## Features

- Easy-to-use CLI for common operations
- Predefined Docker commands for managing containers
- Automatic execution of commands inside the appropriate container

## Running commands

The `commands.sh` script automatically ensures that:

- Commands are executed on the host.
- But not inside `./commands/services/<service-name>/in-container/...`, commands are executed within the corresponding container named `${APP_NAME}-<service_name>-container`. If you run theses types of commands from the host, they it will be automatically executed inside the appropriate container.
- For example, `./commands.sh commands/services/app/in-container/tests/unit.sh` will run inside the `${APP_NAME}-app-container`, while (by example) `./commands.sh commands/services/db/in-container/clear-all.sh` will run inside the `${APP_NAME}-db-container`.

## How to integrate `spacebase_commands` into your project

If you want to bring **spacebase_commands** into your existing project **without overwriting your .git or existing files**, follow these steps:

### 1. Add `spacebase_commands` as a remote

```sh
git remote add spacebase_commands git@github.com:spacecodeur/spacebase_commands.git
```

### 2. Fetch the latest `spacebase_commands` changes

```sh
git fetch spacebase_commands
```

### 3. Merge `spacebase_commands` into your project (while keeping your files safe)

```sh
git merge --allow-unrelated-histories spacebase_commands/main -X ours
```

This will:
- **Add new files from spacebase_commands** without overwriting existing files in your project.
- **Preserve your own files and modifications**.
- **Allow you to review changes** before committing.

If conflicts appear (e.g., in `.env`), Git will prompt you to manually merge them.

Finally, set the name of your project in the key `APP_NAME` (`.env` file)

### 4. Commit the merge

Once resolved, finalize the integration:

```sh
git commit -am "Merged spacebase_commands into project"
```

Now, **spacebase_commands** is integrated into your project while keeping your Git history intact!

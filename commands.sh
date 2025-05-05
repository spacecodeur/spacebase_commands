#!/bin/bash

COMMANDS_DIR="./commands"
ENV_FILE=".env"

if [[ ! -d "$COMMANDS_DIR" ]]; then
    echo "Error: The directory $COMMANDS_DIR does not exist."
    exit 1
fi

if [ -f "$ENV_FILE" ]; then
  APP_NAME=$(grep '^APP_NAME=' "$ENV_FILE" | cut -d '=' -f 2)
else
  echo "Erreur : le fichier .env est introuvable."
  exit 1
fi

export APP_NAME

show_help() {
    echo "Usage: \`$0 <command/subcommand/...>.sh\`"
    echo "Available commands:"
    find "$COMMANDS_DIR" -type f -name "*.sh" | sort
}

is_running_in_docker() {
  if [[ -f "/.dockerenv" ]]; then
    return 0
  else
    return 1
  fi
}

if [[ $# -eq 0 ]]; then
    show_help
    exit 1
fi

COMMAND=$1

if [[ ! -f "$COMMAND" ]]; then
    echo "Unknown command: $COMMAND"
    show_help
    exit 1
fi

IFS='/' read -ra PARTS <<< "$COMMAND"

if [[ "${PARTS[1]}" == "services" && "${PARTS[3]}" == "in-container" ]] && ! is_running_in_docker; then
    
    SERVICE="${PARTS[2]}"
    
    CONTAINER_NAME="${APP_NAME}-${SERVICE}-container"

    # keep --tty and --interactive : if not, SIGINT (ctrl+c) won't be correctly passed from host to container
    docker exec --tty --interactive --workdir /app "$CONTAINER_NAME" ./commands.sh "$COMMAND" "${@:2}"

else
    # execute the command with parameters starting from the second argument
    bash "$COMMAND" "${@:2}"
fi
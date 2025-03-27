#!/bin/bash

## build containers

./commands.sh app/container/build &
./commands.sh db/container/build &
wait

## run some scripts like migrations, wasm building, ...

./commands.sh fc/app/migrate/up-all
./commands.sh fc/app/wasm-build

## finish !

echo
echo "All set!"
echo "Next step : ./commands.sh fc/app/server-start"
echo "Happy coding! :D"
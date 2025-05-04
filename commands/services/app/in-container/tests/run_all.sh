#!/bin/bash

./commands.sh commands/services/from-container/app/tests/unit.sh && \
./commands.sh commands/services/from-container/app/tests/integration.sh && \
./commands.sh commands/services/from-container/app/tests/e2e.sh
#!/bin/sh

cat <<EOF
Welcome to Jepsen on Docker
===========================

Please run \`bin/control\` in another terminal to proceed.
EOF

# hack for keep this container running
tail -f /dev/null

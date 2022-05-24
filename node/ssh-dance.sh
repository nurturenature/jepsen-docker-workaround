#!/bin/bash

# We make sure that root's authorized keys are ready
echo "Setting up root's authorized_keys" >> /var/log/jepsen-setup.log

cp /var/jepsen/shared/control_ssh_id_rsa_pub /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

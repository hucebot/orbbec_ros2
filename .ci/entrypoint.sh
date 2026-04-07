#!/bin/bash
set -e

source "/opt/ros/humble/setup.bash"
source "/ros2_ws/install/setup.bash"

# Route CycloneDDS based on env flag
if [ "$DEPLOYMENT_ENV" = "local" ]; then
    export CYCLONEDDS_URI="file:///etc/ros2/configs/local_cyclonedds.xml"
    echo "🔌 Network Mode: LOCAL (Loopback only)"
else
    export CYCLONEDDS_URI="file:///etc/ros2/configs/cyclonedds.xml"
    echo "🔌 Network Mode: ROBOT (Full network)"
fi

# Small delay for USB hardware discovery
sleep 2

exec "$@"
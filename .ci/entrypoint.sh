#!/bin/bash
set -e

# Source ROS 2 core and your specific workspace
source "/opt/ros/humble/setup.bash"
source "/ros2_ws/install/setup.bash"

# Small delay for USB hardware discovery
sleep 2

exec "$@"
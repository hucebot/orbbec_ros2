# ORBBEC ROS2

## Installation

To build the Docker image, run the following command in the directory containing the Dockerfile:

```bash
sh build.sh
```

This will create a Docker image with all the necessary dependencies for ORBBEC ROS2.

## Usage

To run a container from the built image, use the following command:

```bash
sh run.sh
```

This will start a Docker container with access to the host's devices, allowing interaction with ORBBEC sensors.

Then, you can launch the desired ROS2 nodes inside the container as needed.

**Tiago head-down camera** (camera name, resolutions, serial, and static transform from `ci/world` to camera optical frame):

```bash
ros2 launch /host_ws/launch/tiago/tiago_head_down_camera.launch
```

**Tiago both cameras** (head-down and head-front cameras with their respective static transforms):

```bash
ros2 launch /host_ws/launch/tiago/tiago_both_camera.launch
```

**Generic Femto Bolt** (custom parameters):

```bash
ros2 launch orbbec_camera femto_bolt.launch.py enable_point_cloud:=true enable_colored_point_cloud:=true depth_width:=1024 depth_height:=1024 ir_width:=1024 ir_height:=1024 depth_fps:=15 ir_fps:=15 enable_decimation_filter:=true enable_spatial_filter:=true
```
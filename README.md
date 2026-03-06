# ORBBEC ROS2

This repository provides a Docker-based environment for Orbbec cameras (Femto Bolt, etc.) used on the TIAGo robot. It includes a **Dev** mode for live code editing and a **Deploy** mode for standalone execution.

## 🛠 Installation

Before running, ensure the **NVIDIA Container Toolkit** is installed on your host.

### 1. Host USB Setup

To handle high-bandwidth point cloud streams, increase the USB buffer size on your host machine:

```bash
sudo sh -c 'echo 1000 > /sys/module/usbcore/parameters/usbfs_memory_mb'

```

### 2. Build Images

Build the development and deployment images using the Makefile:

```bash
# For development (interactive)
make build-dev

# For deployment (self-contained)
make build-dep

```

---

## 🚀 Usage

### Development Mode

Starts a container with your local directory mounted to `/host_ws`. Use this for debugging and live code changes.

```bash
make run

```

Inside the container, you can run any launch command manually:

```bash
ros2 launch /host_ws/launch/tiago/tiago_both_camera.launch

```

### Deployment Mode

Starts a standalone, detached container that automatically launches the **Tiago both cameras** setup. No host volumes are required as the code is baked into the image.

```bash
make deploy

```

**Monitor Deployment:**
To see the camera stream logs and ROS 2 output:

```bash
make logs

```

---

## 📡 ROS 2 Launch Commands

Available launch configurations within the environment:

**Tiago head-down camera:**

```bash
ros2 launch /host_ws/launch/tiago/tiago_head_down_camera.launch

```

**Tiago both cameras (Head-down & Head-front):**

```bash
ros2 launch /host_ws/launch/tiago/tiago_both_camera.launch

```

**Generic Femto Bolt (High Res):**

```bash
ros2 launch orbbec_camera femto_bolt.launch.py \
    enable_point_cloud:=true \
    depth_width:=1024 \
    depth_height:=1024 \
    depth_fps:=15

```

---

## 🧹 Maintenance

* **Stop containers:** `make stop`
* **Clean builds:** `make clean`
* **Registry login:** `make login`


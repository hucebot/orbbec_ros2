# Orbbec ROS 2 Docker Environment

A generic, Dockerized ROS 2 wrapper for Orbbec cameras (e.g., Femto Bolt). Configuration and network routing are fully driven by a `.env` file, allowing true plug-and-play deployment across different hosts and robots.


## 🛠 Quick Start

### 1. Host Setup (One-time)
Install the necessary udev rules and automatically increase the host's USB memory buffer to handle high-bandwidth point clouds.
```bash
make install-udev
```

### 2. Configure Camera
Copy the template environment file and configure your specific camera parameters, resolutions, and network mode (`robot` or `local`).
```bash
cp .env.template .env
```

### 3. Build & Deploy
Build the production image and start the camera node in the background.
```bash
make build
make deploy
```

---

## 🚀 Monitoring & Maintenance

Once deployed, you can use the following commands to manage the system:

* **View live logs:**
* ```bash
  make logs
  ```
* **List connected Orbbec devices: (Usefull for getting the SERIAL_NUMBER)**
* ```bash
  make list-devices
  ```
* **Stop the container:**
* ```bash
  make stop
  ```
* **Complete cleanup** (Removes containers and local build artifacts):
  ```bash
  make clean
  ```

---

## 📦 Pushing to a Registry (Optional)
If you want to build and push this image to a remote container registry (like GitLab):
1. Define `REGISTRY` and `IMAGE_NAME` in your `.env` file.
2. Run `make login` to authenticate.
3. Run `make build` (the script will automatically tag the image if the variables are present).
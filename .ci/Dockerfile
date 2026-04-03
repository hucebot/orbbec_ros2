# --- STAGE 1: Base (Shared) ---
FROM nvidia/opengl:1.2-glvnd-devel-ubuntu22.04 AS base
ENV ROS_DISTRO=humble
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
    curl gnupg2 lsb-release git build-essential cmake python3-pip python-is-python3

RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt-get update && apt install -y \
    ros-humble-desktop-full ros-dev-tools ros-humble-rmw-cyclonedds-cpp \
    ros-${ROS_DISTRO}-cv-bridge ros-${ROS_DISTRO}-rviz2 ros-${ROS_DISTRO}-image-transport

WORKDIR /ros2_ws
RUN mkdir src && cd src && git clone https://github.com/orbbec/OrbbecSDK_ROS2.git
RUN source /opt/ros/${ROS_DISTRO}/setup.bash && rosdep init || true && rosdep update && \
    rosdep install -i --from-path src --rosdistro ${ROS_DISTRO} --skip-keys=librealsense2 -y
RUN source /opt/ros/${ROS_DISTRO}/setup.bash && colcon build


COPY .ci/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# --- STAGE 2: Dev ---
FROM base AS dev
WORKDIR /host_ws
CMD /bin/bash

# --- STAGE 3: Dep ---
FROM base AS dep

USER root

COPY launch /ros2_ws/launch
COPY configs/cyclonedds.xml /etc/ros2/cyclonedds.xml

ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
ENV CYCLONEDDS_URI=/etc/ros2/cyclonedds.xml
ENV ROS_DOMAIN_ID=39

# Use shell form so the environment is sourced correctly
CMD ros2 launch /ros2_ws/launch/franka/franka_external.launch
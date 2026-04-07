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
# Copy the whole folder so both XMLs are available
COPY configs /etc/ros2/configs

ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

CMD ros2 launch /ros2_ws/launch/orbbec/orbbec.launch \
    camera_name:=${CAMERA_NAME} \
    serial_number:=${SERIAL_NUMBER} \
    device_num:=${DEVICE_NUM} \
    color_width:=${COLOR_WIDTH} \
    color_height:=${COLOR_HEIGHT} \
    ordered_pc:=${ORDERED_PC} \
    color_exposure:=${COLOR_EXPOSURE} \
    publish_tf:=${PUBLISH_TF} \
    tf_x:=${TF_X} \
    tf_y:=${TF_Y} \
    tf_z:=${TF_Z} \
    tf_yaw:=${TF_YAW} \
    tf_pitch:=${TF_PITCH} \
    tf_roll:=${TF_ROLL} \
    tf_parent_frame:=${TF_PARENT_FRAME}
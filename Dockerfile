FROM nvidia/opengl:1.2-glvnd-devel-ubuntu22.04
ENV ROS_DISTRO=humble

ENV DISPLAY=:0
ENV LIBGL_ALWAYS_INDIRECT=0

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ="Europe/Paris"

LABEL maintainer="clemente.donoso@inria.fr"

RUN apt-get update && apt-get upgrade -yy

###### Install Python Dependencies
RUN apt-get install -y \
    python-is-python3 \
    python3-pip

###### Install ROS2
RUN apt-get install -y \
    curl \
    gnupg2 \
    lsb-release

RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null
RUN apt-get update && apt-get upgrade -y
RUN apt install ros-humble-desktop-full -y
RUN apt install ros-dev-tools -y
RUN rosdep init && rosdep update

###### Install ROS Dependencies
RUN apt install -y \
    ros-${ROS_DISTRO}-cv-bridge \
    ros-${ROS_DISTRO}-rviz2

####### Install Orbbec SDK
RUN apt install -y git
RUN mkdir -p /ros2_ws/src
WORKDIR /ros2_ws/src
RUN git clone https://github.com/orbbec/OrbbecSDK_ROS2.git
WORKDIR /ros2_ws
RUN rosdep install -i --from-path src --rosdistro ${ROS_DISTRO} --skip-keys=librealsense2 -y

RUN apt install libgflags-dev nlohmann-json3-dev  \
    ros-${ROS_DISTRO}-image-transport  ros-${ROS_DISTRO}-image-transport-plugins ros-${ROS_DISTRO}-compressed-image-transport \
    ros-${ROS_DISTRO}-image-publisher ros-${ROS_DISTRO}-camera-info-manager \
    ros-${ROS_DISTRO}-diagnostic-updater ros-${ROS_DISTRO}-diagnostic-msgs ros-${ROS_DISTRO}-statistics-msgs \
    ros-${ROS_DISTRO}-backward-ros libdw-dev ros-${ROS_DISTRO}-cv-bridge
    
RUN source /opt/ros/${ROS_DISTRO}/setup.bash && \
    colcon build --event-handlers console_direct+ --cmake-args -DCMAKE_BUILD_TYPE=Release

###### Update Buffer
RUN sysctl net.ipv4.ipfrag_time=3
RUN sysctl net.ipv4.ipfrag_high_thresh=134217728

RUN echo "export FASTDDS_BUILTIN_TRANSPORTS=LARGE_DATA?max_msg_size=1MB&soets_size=1MB&non_blocking=true&tcp_negotiation_timeout=50" >> ~/.bashrc

###### Source ROS2
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
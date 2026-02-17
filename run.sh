
isRunning=`docker ps -f name=orbbec_ros2 | grep -c "orbbec_ros2"`;

if [ $isRunning -eq 0 ]; then
    xhost +local:docker
    docker rm orbbec_ros2
    docker run  \
        --name orbbec_ros2  \
        --gpus all \
        -e DISPLAY=$DISPLAY \
        -e NVIDIA_DRIVER_CAPABILITIES=all \
        -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        --env QT_X11_NO_MITSHM=1 \
        --net host \
        --ipc host \
        --pid host \
        --privileged \
        -it \
        -v $(pwd)/configs/:/xml_configs \
        -e RMW_IMPLEMENTATION=rmw_cyclonedds_cpp\
        -e CYCLONEDDS_URI=/xml_configs/cyclonedds.xml\
        -v $(pwd):/host_ws \
        -v /dev:/dev \
        -v /run/udev:/run/udev \
        --device /dev/dri \
        --device /dev/snd \
        --device /dev/input \
        -e ROS_DOMAIN_ID=1\
        --device /dev/bus/usb \
        -w /ros2_ws \
        orbbec_ros2:latest

else
    echo "Docker already running."
    docker exec -it orbbec_ros2 /bin/bash
fi
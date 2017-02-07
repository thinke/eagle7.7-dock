
KEY=$(xauth list  |grep $(hostname) | awk '{ print $3 }' | head -n 1)
DCK_HOST=eagle-dock
xauth add $DCK_HOST/unix:0 . $KEY

if [ ! -d $HOME/eagle-7 ]; then
  mkdir $HOME/eagle-7
fi

docker run -it --rm -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v $HOME/.Xauthority:/tmp/.Xauthority \
           -v /dev/snd:/dev/snd \
	   -v $HOME/eagle-7:/home/eagle/eagle \
           -e DISPLAY=$DISPLAY \
           -e XAUTHORITY=/tmp/.Xauthority  \
           -h $DCK_HOST \
eagle-dock

echo "Installing Blitz Dashboard"
echo "Getting required libraries via apt"
sudo apt install libgl1-mesa-dev libgles2-mesa-dev libegl-mesa0 libdrm-dev libgbm-dev ttf-mscorefonts-installer fontconfig gpiod libgpiod-dev
sudo fc-cache

echo "Cloning Flutter Engine repository"
git clone --depth 1 --branch engine-binaries https://github.com/ardera/flutter-pi.git

echo "Installing Flutter Engine"
sudo cp flutter-pi/libflutter_engine.so flutter-pi/icudtl.dat /usr/lib
sudo cp flutter-pi/flutter_embedder.h /usr/include

echo "Removing Flutter Engine repository"
rm -rf flutter-pi

echo "Cloning Flutter-PI"
git clone --depth 1 --branch master https://github.com/ardera/flutter-pi.git flutter-pi-src
cd flutter-pi-src
make
cd ..
cp flutter-pi-src/out/flutter-pi .

echo "Adding user admin to the render group"
usermod -a -G render admin

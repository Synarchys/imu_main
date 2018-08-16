nim js -o:public/js/index.js src/imu.nim
cd public ; python3 -m http.server 24042

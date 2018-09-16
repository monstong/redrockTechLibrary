# GCP Hackaton on Kube 3 Team.

## GCP 1st try(Install and configure  in VM ,GCP)

1) create vm

```
compute  > vm instance  > create > ubuntu 18.04 LTS
```


2) install prereqs pkgs

```bash
$ sudo apt-get install python3 python3-dev python3-venv
$ python3 -m venv py3
$ source py3/bin/activate
(py3) $ pip install --upgrade pip
(py3) $ pip install opencv-python
(py3) $ pip install opencv-contrib-python

  -> 그냥 dlib 설치하면 에러남, 추가 build pkg 설치후 진행
  sudo apt-get install build-essential cmake pkg-config
  sudo apt-get install libx11-dev libatlas-base-dev
  sudo apt-get install libgtk-3-dev libboost-python-dev

(py3) $ pip install dlib
(py3) $ pip install face_recognition
(py3) $ pip install flask
```

 - references 

   * https://ukayzm.github.io/python-face-recognition/
   * https://www.learnopencv.com/install-dlib-on-ubuntu/
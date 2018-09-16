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
  -> 기본 VM으로 생성(1 vcpu에 mem 등) 하면 이부분 상당히 오래 걸림 

(py3) $ pip install face_recognition
(py3) $ pip install flask
```

3) face_recognition source가져오기 

git clone 명령으로 source를 가져온다.
face_recognition만을 git으로 가져올 순 없어 opencv를 가져와 해당 폴더만 사용필요

```
(py3) monstong@instance-1:~$ git clone https://github.com/ukayzm/opencv.git
Cloning into 'opencv'...
remote: Counting objects: 232, done.
remote: Compressing objects: 100% (15/15), done.
remote: Total 232 (delta 3), reused 16 (delta 3), pack-reused 214
Receiving objects: 100% (232/232), 70.06 MiB | 36.05 MiB/s, done.
Resolving deltas: 100% (117/117), done.
(py3) monstong@instance-1:~$ cd opencv/
(py3) monstong@instance-1:~/opencv$ ls
README.md       face_clustering   facial_landmarks  motion_detector              saliency_detection
bg_subtraction  face_recognition  live_streaming    object_detection_tensorflow
(py3) monstong@instance-1:~/opencv$ cd face_recognition/
(py3) monstong@instance-1:~/opencv/face_recognition$ ls
README.md  camera.py  face_recog.py  knowns  live_streaming.py  templates

```

 - 수행해 본다

 ```
 (py3) monstong@instance-1:~/opencv/face_recognition$ python3 camera.py 
VIDEOIO ERROR: V4L: can't open camera by index 0
Traceback (most recent call last):
  File "camera.py", line 30, in <module>
    cv2.imshow("Frame", frame)
cv2.error: OpenCV(3.4.3) /io/opencv/modules/highgui/src/window.cpp:356: error: (-215:Assertion failed) size.width>0 && size.height>0 in function 'imshow'

(py3) monstong@instance-1:~/opencv/face_recognition$ python3 face_recog.py 
VIDEOIO ERROR: V4L: can't open camera by index 0
['Lenna']
Traceback (most recent call last):
  File "face_recog.py", line 104, in <module>
    frame = face_recog.get_frame()
  File "face_recog.py", line 45, in get_frame
    small_frame = cv2.resize(frame, (0, 0), fx=0.25, fy=0.25)
cv2.error: OpenCV(3.4.3) /io/opencv/modules/imgproc/src/resize.cpp:4044: error: (-215:Assertion failed) !ssize.empty() in function 'resize'
```
 - 문제점 : 
   * 원 소스를 보면 수행되는 OS내 연결되 webcam을 이용하는 걸로 보이는데, 클라우드에 올리면  동영상  링크등 소스 인풋을 네트워크로 받던, 클라우드 스토리지에 저장하여 소스를 리드하던 하는 형식으로 바꿔야할듯 함.
   * Flash 로 웹에서 스트리밍 하는 부분 필요

 - 발전할 부분??
   * 인식용 얼굴 사진 이미지는 클라우드 스토리지에 담도록 분리
   * VM에서 수행한 부분을 container로 변환하기
   * container 성공후  K8s 엔진에 클러스터 생성하여 구성해보기
   * replica 구성이나  deployment 연습해 보기
   * 보안 그룹 설정하여 허용된 접근만제어??
   

 - references 

   * https://ukayzm.github.io/python-face-recognition/
   * https://www.learnopencv.com/install-dlib-on-ubuntu/
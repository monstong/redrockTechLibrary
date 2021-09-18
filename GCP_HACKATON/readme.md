<<<<<<< HEAD
# GCP Hackaton in Kube 3 Team. 
## [Face Recognition on GCP K8s service]
=======
# GCP Hackaton in Kube 3 Team.
# [Face Recognition on GCP K8s service]

✨ 김서준 / 이지윤 / 서준용 / 강홍석 / 주태영 ✨
>>>>>>> 03e81e298d724c96ecdf991666b91c522cf0408c

## GCP 1st try(Install and configure  in VM ,GCP)

### 1) create vm

```bash
compute  > vm instance  > create > ubuntu 18.04 LTS
```

### 2) install prereqs pkgs

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

### 3) face_recognition source가져오기 

git clone 명령으로 source를 가져온다.
face_recognition만을 git으로 가져올 순 없어 opencv를 가져와 해당 폴더만 사용필요

```bash
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

 ```bash
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
   * external ip 로 접속안되는 이슈 : python live_streaming.py 실행시  external ip로 접속안되는 이슈 발생은
     VPC 에서 해당 포트에 대한  firewall rule을 적용후 대상 target 또는 전체 인스턴스 허용토록 하면 해결
     (VM 생성시 http , https trafiic 허용은 tcp 80 과 443 port만 오픈됨)

     1. VPC 메뉴로 이동
      
      > GCP console > compute engine > VM instances > 해당 instance 선택 > Network interfaces 에서 view details 선택하면 VPC 메뉴로 이동
      
     2. firewall rules 선택해서 `create firewall rule` 선택하여 아래와 같이 설정후 `create`버튼 선택

      - Name : 대략 넣는다 fw-http-5000  (firwall http 500port rule 만들거야~)
      - logs : 일단 off로 둔다 (추후 운영 서비스면 fw log 남기는게..)
      - Network : default로 둔다. 
      - Priority : 1000 기본값 그대로 (이후 유사 룰에 대한 우선권 부여라..)
      - Direction of traffic : ingres  (일단 다른 default rule 따라했음. 공부 더 필요)
      - Action on match : Allow  (당연 허용!!)
      - Targets : Specfified target tags 선택 (all instance 선택하는게 더 편하지만, 그대로 최소한의 보안은 챙기자 ^^)
      - Target tags : http-server  (web service 태그 입력 - 일단 default 80꺼 따라함)
      - Source filter : IP ranges 선택
      - Source IP ranges : 0.0.0.0/0  선택 (외부 IP가 유동이라 일단 요걸로...)
      - Protocols and ports : Specified protocols and ports > TCP check > 5000 입력(5000번 포트 열겠다라 8080하려면 여기서 변경)

     2. 신규 FW rule 적용 완료 후 테스트 해보면 외부 IP로도 접속이 잘된다.

     ```bash
     (py3) monstong@instance-1:~/opencv/face_recognition$ curl http://35.237.252.11:5000
<<<<<<< HEAD
35.237.252.11 - - [23/Sep/2018 07:50:09] "GET / HTTP/1.1" 200 -
     <html>
      <head>
      <title>Video Streaming Demonstration</title>
      </head>
      <body>
        <h1>Video Streaming Demonstration</h1>
        <img id="bg" src="/video_feed">
      </body>
     </html>
=======
        35.237.252.11 - - [23/Sep/2018 07:50:09] "GET / HTTP/1.1" 200 -
>>>>>>> 03e81e298d724c96ecdf991666b91c522cf0408c
     ```




## GCP 2nd try (creating docker and k8s cluster )

### 1) Dockerfile 만들기 : opencv 사이트에 있는 dockerfile 참조하여 만든다.

 단, port는 5000 으로 설정 (face_recog 의 flask에서 기본 포트 )
 Dlib 설치가 오래 걸리고 사이즈도 커서 Cloud shell에서 하지 않고 별도의 VM 생성하여 수행함
 
 ```bash
monstong@instance-3:~$ vi Dockerfile
monstong@instance-3:~$ cat Dockerfile 
FROM python:3.6

WORKDIR /app

ADD . /app

RUN pip install --upgrade pip
RUN pip install opencv-python opencv-contrib-python

RUN apt-get update && apt-get install -y \
   python3 \
   python3-dev \
   build-essential \
   cmake \
   pkg-config \
   libx11-dev \
   libatlas-base-dev \
   libgtk-3-dev \
   libboost-python-dev 

RUN pip install dlib
RUN pip install face_recognition flask

EXPOSE 5000

CMD ["python", "live_streaming.py"]
```
 
### 2) 먼저 cloud shell에서 project id를 확인한다. (image 배포 및 cluster 생성시 등에 사용)

```bash
monstong@cloudshell:~ (stellar-aleph-211809)$ gcloud projects list
PROJECT_ID            NAME              PROJECT_NUMBER
stellar-aleph-211809  My First Project  263816501665
```

### 3) Docker image build 하기 : 작성한 Dockerfile로  docker image를 생성후 registry에  등록(push)한다.

```bash
monstong@instance-3:~$ python3 -m venv py3
monstong@instance-3:~$ source py3/bin/activate
(py3) monstong@instance-3:~$ git clone https://github.com/ukayzm/opencv.git
Cloning into 'opencv'...
remote: Enumerating objects: 232, done.
remote: Total 232 (delta 0), reused 0 (delta 0), pack-reused 232
Receiving objects: 100% (232/232), 70.06 MiB | 11.94 MiB/s, done.
Resolving deltas: 100% (120/120), done.
Checking connectivity... done.
(py3) monstong@instance-3:~$ ls        
Dockerfile  opencv  py3
(py3) monstong@instance-3:~$ cd opencv/face_recognition/
(py3) monstong@instance-3:~/opencv/face_recognition$ ls
README.md  camera.py  face_recog.py  knowns  live_streaming.py  templates
(py3) monstong@instance-3:~/opencv/face_recognition$ cp ../../Dockerfile .
(py3) monstong@instance-3:~/opencv/face_recognition$ sudo docker build -t gcr.io/stellar-aleph-211809/face_recog:v1 .
... 중략 ...
Step 7/10 : RUN pip install dlib
 ---> Running in 5c4a915f1069
Collecting dlib
  Downloading https://files.pythonhosted.org/packages/35/8d/e4ddf60452e2fb1ce3164f774e68968b3f110f1cb4cd353235d56875799e/dlib-19.16.0.tar.gz (3.3MB)
Building wheels for collected packages: dlib
  Running setup.py bdist_wheel for dlib: started
  Running setup.py bdist_wheel for dlib: still running...
  Running setup.py bdist_wheel for dlib: still running...

요기서 오래 걸림

Successfully built de0a5e098c85
Successfully tagged gcr.io/stellar-aleph-211809/face_recog:v1

```

### 4) Dockerimage push 하기 (근데 에러가??)

```bash
(py3) monstong@instance-3:~/opencv/face_recognition$ gcloud docker -- push gcr.io/stellar-aleph-211809/face_recog:v1
WARNING: `gcloud docker` will not be supported for Docker client versions above 18.03.

As an alternative, use `gcloud auth configure-docker` to configure `docker` to
use `gcloud` as a credential helper, then use `docker` as you would for non-GCR
registries, e.g. `docker pull gcr.io/project-id/my-image`. Add
`--verbosity=error` to silence this warning: `gcloud docker
--verbosity=error -- pull gcr.io/project-id/my-image`.

See: https://cloud.google.com/container-registry/docs/support/deprecation-notices#gcloud-docker

Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post http://%2Fvar%2Frun%2Fdocker.sock/v1.38/images/gcr.io/stellar-aleph-211809/face_recog/push?tag=v1: dial unix /var/run/docker.sock: connect: permission denied

```

VM에서 gcloud sdk 접속 권한이 없는 상태이므로 `gcloud auth login`을 통해 인증 후 진행한다.

```bash
(py3) monstong@instance-3:~/opencv/face_recognition$ gcloud auth login

You are running on a Google Compute Engine virtual machine.
It is recommended that you use service accounts for authentication.

You can run:

  $ gcloud config set account `ACCOUNT`

to switch accounts if necessary.

Your credentials may be visible to others with access to this
virtual machine. Are you sure you want to authenticate with
your personal account?

Do you want to continue (Y/n)?  y

Go to the following link in your browser:

    https://accounts.google.com/o/oauth2/auth?redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&prompt=select_account&response_type=code&client_id=32555940559.apps.googleusercontent.com&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcloud-platform+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fappengine.admin+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcompute+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Faccounts.reauth&access_type=offline


Enter verification code: 4/bwBQztgG-GC9C17tht-hHFFKkqe8t7Vi_C5zzEpoul1U8urCXrmvmCA
WARNING: `gcloud auth login` no longer writes application default credentials.
If you need to use ADC, see:
  gcloud auth application-default --help

You are now logged in as [monstong@gmail.com].
Your current project is [stellar-aleph-211809].  You can change this setting by running:
  $ gcloud config set project PROJECT_ID
(py3) monstong@instance-3:~/opencv/face_recognition$ gcloud projects list
PROJECT_ID            NAME              PROJECT_NUMBER
stellar-aleph-211809  My First Project  263816501665
```

이제 image를 push 하자

```bash
(py3) monstong@instance-3:~/opencv/face_recognition$ sudo gcloud docker  -- push gcr.io/stellar-aleph-211809/face
_recog:v1
WARNING: `gcloud docker` will not be supported for Docker client versions above 18.03.

As an alternative, use `gcloud auth configure-docker` to configure `docker` to
use `gcloud` as a credential helper, then use `docker` as you would for non-GCR
registries, e.g. `docker pull gcr.io/project-id/my-image`. Add
`--verbosity=error` to silence this warning: `gcloud docker
--verbosity=error -- pull gcr.io/project-id/my-image`.

See: https://cloud.google.com/container-registry/docs/support/deprecation-notices#gcloud-docker

The push refers to repository [gcr.io/stellar-aleph-211809/face_recog]
The push refers to repository [gcr.io/stellar-aleph-211809/face_recog]
901e08660ef7: Pushed 
9d97645aa50e: Pushed 
aa8decf56ba6: Pushed 
7abc9d4c6874: Pushed 
34dc58c3e4fd: Pushed 
e8d0c72aba99: Pushed 
f5217fb9dd57: Pushed 
6e24c544229f: Layer already exists 
2a238856cffa: Layer already exists 
ca26ff57b02f: Layer already exists 
e0978d7d106a: Layer already exists 
a19cb627cc73: Layer already exists 
ab016c9ea8f8: Layer already exists 
2eb1c9bfc5ea: Layer already exists 
0b703c74a09c: Layer already exists 
b28ef0b6fef8: Layer already exists 
v1: digest: sha256:909d5de2f53c48263e00b02f6d0c0dcf3c941528e530bd6f7ad85b0cf2e5775c size: 369
```

### 5) Dockerimage pull 하기 (cloud shell에서)

```bash
use `gcloud` as a credential helper, then use `docker` as you would for non-GCR
registries, e.g. `docker pull gcr.io/project-id/my-image`. Add
`--verbosity=error` to silence this warning: `gcloud docker
--verbosity=error -- pull gcr.io/project-id/my-image`.

See: https://cloud.google.com/container-registry/docs/support/deprecation-notices#gcloud-docker

v1: Pulling from stellar-aleph-211809/face_recog
05d1a5232b46: Pull complete
5cee356eda6b: Pull complete
89d3385f0fd3: Pull complete
80ae6b477848: Pull complete
28bdf9e584cc: Pull complete
dec1a1f0462b: Pull complete
a4670d125615: Pull complete
547b45a875f5: Pull complete
102a0247b454: Pull complete
2095dfacd0eb: Pull complete
01340f5149ae: Pull complete
c1f250a18eba: Pull complete
00dc74e0ab90: Pull complete
116ada10c0a7: Pull complete
26daeec26517: Pull complete
45fe8417b652: Pull complete
Digest: sha256:909d5de2f53c48263e00b02f6d0c0dcf3c941528e530bd6f7ad85b0cf2e5775c
Status: Downloaded newer image for gcr.io/stellar-aleph-211809/face_recog:v1

```

### 6) K8s cluster 생성하자 (워커 노드는 3개로...)

```bash
monstong@cloudshell:~ (stellar-aleph-211809)$ gcloud container clusters create face-recog-clu --num-nodes 3 --machine-type n1-standard-1 --zone us-central1-f
WARNING: Starting in 1.12, new clusters will have basic authentication disabled by default. Basic authentication can be enabled (or disabled) manually using the `--[no-]enable-basic-auth` flag.
WARNING: Starting in 1.12, new clusters will not have a client certificate issued. You can manually enable (or disable) the issuance of the client certificate using the `--[no-]issue-client-certificate` flag.
WARNING: Currently VPC-native is not the default mode during cluster creation. In the future, this will become the default mode and can be disabled using `--no-enable-ip-alias` flag. Use `--[no-]enable-ip-alias` flag to suppress this warning.
This will enable the autorepair feature for nodes. Please see https://cloud.google.com/kubernetes-engine/docs/node-auto-repair for more information on node autorepairs.
WARNING: Starting in Kubernetes v1.10, new clusters will no longer get compute-rw and storage-ro scopes added to what is specified in --scopes (though the latter will remain included in the default --scopes). To use these scopes, add them explicitly to --scopes. To use the new behavior, set container/new_scopes_behavior property (gcloud config set container/new_scopes_behavior true).
Creating cluster face-recog-clu in us-central1-f...done.
Created [https://container.googleapis.com/v1/projects/stellar-aleph-211809/zones/us-central1-f/clusters/face-recog-clu].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/us-central1-f/face-recog-clu?project=stellar-aleph-211809
kubeconfig entry generated for face-recog-clu.
NAME            LOCATION       MASTER_VERSION  MASTER_IP      MACHINE_TYPE   NODE_VERSION  NUM_NODES  STATUS
face-recog-clu  us-central1-f  1.9.7-gke.6     35.193.79.194  n1-standard-1  1.9.7-gke.6   3          RUNNING
monstong@cloudshell:~ (stellar-aleph-211809)$

```

### 7) kubectl 로 container 실행하고 , deployment까지~ 


```bash
monstong@cloudshell:~ (stellar-aleph-211809)$ kubectl run face-recog-clu --image=gcr.io/stellar-aleph-211809/face_recog:v1 --port=5000
deployment.apps "face-recog-clu" created
monstong@cloudshell:~ (stellar-aleph-211809)$ kubectl expose deployment hello-node --type="LoadBalancer"
Error from server (NotFound): deployments.extensions "hello-node" not found
monstong@cloudshell:~ (stellar-aleph-211809)$ kubectl expose deployment face-recog-clu --type="LoadBalancer"
service "face-recog-clu" exposed

monstong@cloudshell:~ (stellar-aleph-211809)$ kubectl get pods 
NAME                             READY     STATUS    RESTARTS   AGE
face-recog-clu-574c789cd-cqv4c   1/1       Running   0          1m

monstong@cloudshell:~ (stellar-aleph-211809)$ kubectl get deployments
NAME             DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
face-recog-clu   1         1         1            1           1m

monstong@cloudshell:~ (stellar-aleph-211809)$ kubectl get services
NAME             TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
face-recog-clu   LoadBalancer   10.63.245.87   35.232.18.9   5000:32180/TCP   4m
kubernetes       ClusterIP      10.63.240.1    <none>        443/TCP          9m

```

### 8) 이제 웹페이지를 보면 뙇~! 

우리가 예상한 것

https://ukayzm.github.io/python-face-recognition/


실제는??

-[실제 보러가기](https://github.com/monstong/redrockTechLibrary/edit/master/GCP_HACKATON/ours.PNG)

<br/>
<br/>
<br/>
<br/>
<br/>
<br/><br/>
<br/>
<br/><br/>
<br/>
<br/><br/>
<br/>
<br/><br/>
<br/>
<br/><br/>
<br/>
<br/>


### epilogue...

 - 발전할 부분??
   * 인식용 얼굴 사진 이미지는 클라우드 스토리지에 담도록 분리
   * VM에서 수행한 부분을 container로 변환하기
   * container 성공후  K8s 엔진에 클러스터 생성하여 구성해보기
   * replica 구성이나  deployment 연습해 보기
   * 보안 그룹 설정하여 허용된 접근만제어??


 
 - Our slack channel 
   * https://kube3.slack.com/messages/CCQDHMYBF/

 - references 
 
   * https://ukayzm.github.io/python-face-recognition/
   * https://www.learnopencv.com/install-dlib-on-ubuntu/
   * https://01010011.blog/2017/04/11/kubernetes-%EB%A1%9C-flask-web-app-%EB%B0%B0%ED%8F%AC%ED%95%98%EA%B8%B0/
   * https://www.techrepublic.com/article/how-to-quickly-install-kubernetes-on-ubuntu/
   * https://github.com/ageitgey/face_recognition  (원본 GIT)


# redrock's guide : Flexiable YUM configuration

이미 많이 사용하고 있는 YUM 이지만 관리하는 Linux 서버들의 종류와 버전에 따라 RPM 들을  별도로 관리해야할 필요가 있습니다.

각각 다른 버전의 , 다른 배포판의 Linux 별로 repo 를 구성해서 사용해도 되지만, 저같이 게으른 사람은 yum repo 파일조차도
1개 버전으로 다되게 관리하고 싶어서 나름 찾아 정리해 보았습니다.
(배포판 대상은 Yum을 사용하는 Redhat 계열 배포판들이며, 테스트해 본 환경은 Oracle Linux, Redhat Linux, CentOS 정도네요.)

## YUM configuration
YUM ( Yellowdog Updater, Modified) 은 RPM 기반의 패키지들의  효율적인 설치, 업데이트, 롤백, 히스토리 관리등이 가능하게 해주는 도구로 rpm -Uvh 수행시와 달리 RPM간 의존성들도 알아서 해결해 주는 장점을 많이 많이 가지고 있습니다.

Redhat 계열 Linux 배포판 설치시 기본적으로 사용 가능하며, 설치/업데이트 대상 RPM 들을 저장하는 YUM repository를 다양한 (CDROM, WEB based, Local file based 등) 방식으로 사용할 수 있습니다, repository 구성시에는  해당 경로를 createrepo 라는 도구로 YUM repository용 metadata 생성하는 작업이 우선 필요합니다.

본 글에서는 WEB based 방식으로 Repository 를 이미 구성 (여러 대의  관리 대상 서버들에 설치/업데이트 해야 하므로)에 대해서만 이야기하고자 합니다.

각 배포판 별로 기본적으로 제공하는 WEB 방식의 Base repository로 OS 설치시 기본적으로 제공되며, 해당 repo 파일을 열어보면 이미 제가 이야기하려고 하는 부분이 일부분 적용이 되어 있는 걸 볼 수 있습니다.

```bash
(Cent OS base Yum repo file)
root # cat /etc/yum.repos.d/CentOS-Base.repo  
...
[base]
name=CentOS-$releasever - Base
mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra
#baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
...

```
위와 같이 repo 파일이 잘 구성되어 있으면 YUM repository를 검증하고  원하는 패키지를 설치하면 됩니다. (기본 이름만 주어도 알아서 의존성 검사하여 필요 RPM들을 설치하죠)

```bash
(yum repo 검증)

root # yum repolist
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.neowiz.com
 * extras: ftp.neowiz.com
 * updates: ftp.neowiz.com
base                                                                    | 3.6 kB  00:00:00
extras                                                                  | 3.4 kB  00:00:00
localrpms                                                               | 2.9 kB  00:00:00
nginx                                                                   | 2.9 kB  00:00:00
updates                                                                 | 3.4 kB  00:00:00
localrpms/primary_db                                                    | 6.7 kB  00:00:00
repo id                                    repo name                                     status
base/7/x86_64                              CentOS-7 - Base                               9,911
extras/7/x86_64                            CentOS-7 - Extras                               313
localrpms                                  local rpms repo                                   6
nginx/7/x86_64                             nginx repo                                      106
updates/7/x86_64                           CentOS-7 - Updates                              711
repolist: 11,047
root #
-> 현재 /etc/yum.repo.d 경로에 enabled=1 인 repository에 대한 접근 상태 및 저장소에 존재하는 RPM 파일 갯수들을 보여줍니다.

(YUM을 통한 RPM 설치)
root # yum install gcc
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.kakao.com
 * extras: mirror.kakao.com
 * updates: mirror.kakao.com
Resolving Dependencies
--> Running transaction check
---> Package gcc.x86_64 0:4.8.5-28.el7_5.1 will be installed
--> Processing Dependency: libgomp = 4.8.5-28.el7_5.1 for package: gcc-4.8.5-28.el7_5.1.x86_64
...
--> Running transaction check
---> Package cpp.x86_64 0:4.8.5-28.el7_5.1 will be installed
---> Package glibc-devel.x86_64 0:2.17-222.el7 will be installed
--> Processing Dependency: glibc-headers = 2.17-222.el7 for package: glibc-devel-2.17-222.el7.x86_64
--> Processing Dependency: glibc-headers for package: glibc-devel-2.17-222.el7.x86_64
---> Package libgcc.x86_64 0:4.8.5-28.el7 will be updated
---> Package libgcc.x86_64 0:4.8.5-28.el7_5.1 will be an update
...
--> Finished Dependency Resolution

Dependencies Resolved

===============================================================================================
 Package                 Arch            Version                        Repository        Size
===============================================================================================
Installing:
 gcc                     x86_64          4.8.5-28.el7_5.1               updates           16 M
Installing for dependencies:
 cpp                     x86_64          4.8.5-28.el7_5.1               updates          5.9 M
 glibc-devel             x86_64          2.17-222.el7                   base             1.1 M
 glibc-headers           x86_64          2.17-222.el7                   base             678 k
 kernel-headers          x86_64          3.10.0-862.3.3.el7             updates          7.1 M
 libmpc                  x86_64          1.0.1-3.el7                    base              51 k
 mpfr                    x86_64          3.1.1-4.el7                    base             203 k
Updating for dependencies:
 libgcc                  x86_64          4.8.5-28.el7_5.1               updates          101 k
 libgomp                 x86_64          4.8.5-28.el7_5.1               updates          156 k

Transaction Summary
===============================================================================================
Install  1 Package  (+6 Dependent packages)
Upgrade             ( 2 Dependent packages)

Total download size: 31 M
Is this ok [y/d/N]:

=> gcc를 설치하려고 하지만 의존성 있는 추가 RPM 들 까지 설치하도록 찾아주네요., y 를 선택하면 이후 설치가 시작되고, yum install 수행시 -y 옵션을 주면 non-interactive 모드로 바로 설치까지 진행해 버립니다.
```

## YUM Variables
1개의 YUM repo 파일로 여러 버전/배포판의 Linux 서버들을 관리하려면 YUM에서 기본적으로 제공하는 Variable 기능을 사용하면 됩니다.

 1) Pre-defined Variables : /etc/yum.repo.d/ 아래  .repo 파일에  아래의 변수를 이용해 기본적인 
   - $releasever : Linux의 Major 버전을 나타냅니다. Oracle Linux 7.2 이면  실제 repository 검색시 7로 변환하여 검색합니다.
   - $arch : CPU 아키텍쳐 (32비트 또는 64비트) 를 나타냅니다. 예상 값은 (32bit = i686 / 64bit = x86_64) 입니다.
   - $basearch : System의 base 아키텍쳐를 나타냅니다. i686은 i386으로, Intel x64와 AMD x64는 x86_64 의 값을 가집니다. ($arch와 차이는 잘... )
   - $YUM0-9  : $YUM0 ~ $YUM9 로 총 10개의 변수명을 사용할 수 잇씁니다. 동일명의 여러 변수가 존재할 때 사용할 수 있다고 하는데, yum.conf와 연계되는듯.. 

 2) Custom variables
   - 저희가 원하는 배포판 종류나  또는 유저가 원하는 임의의 변수를 만들어 사용할 수 있습니다.
   - 생성 방법 : /etc/yum/vars 경로 아래 원하는 변수명의 파일을 생성합니다. ($ 를 제외하고 만들어야 합니다.)
   ```bash
    root # echo "Red Hat Enterprise Linux" > /etc/yum/vars/osname
    위와 같이 수행하여 osname이란 파일을 생성후 .repo 파일에 아래와 같이 변수로 활용가능합니다.

    name=$osname $releasever
   ```
 - 출처 : https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/sec-using_yum_variables

## YUM variable을 이용하여 Flexible YUM 구성
YUM variable을 이용하여 배포판, 버전, CPU아키텍쳐가 달라도 범용으로 사용할 수 있는 YUM repo file을 만들어 보겠습니다.
nginx 설치 공식 yum repo 설정이 다음과 같습니다.

```bash
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/[배포판종류]/[OS버전]/$basearch/
gpgcheck=0
enabled=1


```
위 경로중 배포판 종류와 OS 버전 부분을 각 OS 에 맞게 수정해서 쓰라고 하네요.
(원문 : Replace “OS” with “rhel” or “centos”, depending on the distribution used, and “OSRELEASE” with “6” or “7”, for 6.x or 7.x versions, respectively.)

 - 출처 : http://nginx.org/en/linux_packages.html#stable

테스트 환경은 아래와 같다고 가정하겠습니다.
 - yumrepo01 : yum repository 서버 (Cent OS 7 , Web 서버 : nginx, Web root : /opt/yumrepo/)
 - oel01 : Oracle Linux 6.8 
 - centos01 : CentOS 7.5
 - rhel01 : Redhat Linux 6.6

먼저 yumrepo01 서버에 repository에 종류별로 하부 디렉토리를 생성합니다.
생성후 각 버전에 맞는 ntp rpm 패키지를 별도로 다운로드 받아 각 경로에 맞게 저장합니다.

```bash
yumrepo01 # mkdir -p /opt/yumrepo/centos/7/x86_64
yumrepo01 # mkdir -p /opt/yumrepo/oracle/6/x86_64
yumrepo01 # mkdir -p /opt/yumrepo/redhat/6/x86_64
```
그 다음 각대상 서버(oel01, rhel01, centos01)들에서  범용 repo 파일을 아래와 같이 설정합니다.

```bash

대상 서버 # vi /etc/yum.repo.d/myrepo.repo
[myrepo]
name=my repo
baseurl=http://yumrepo/$distro/$releasever/$basearch/
gpgcheck=0
enabled=1

```

이때, 버전 과 CPU아키텍쳐 차이는 기본 변수를 사용 가능하나 배포판 구분은 별도의 custom 변수를 생성해 주어야 합니다.

각 대상 서버에서 다음의 스크립트를 수행해 줍니다. 

```bash
대상 서버 # grep "^NAME" /etc/os-release | awk '{print $1}' | sed 's/\"//g' | awk -F= '{print tolower($2)}' > /etc/yum/vars/distro
```

 스크립트 내용은 /etc/os-release 파일에서 배포판 구분이 가능한 문자열을 추출하여 소문자로 변환한다 입니다. /etc/yum/vars에 distro란 파일이 생성되어 있고, 내용이 oracle linux의 경우 oracle로  centos 의 경우 centos로, redhat linux의 경우 redhat으로 저장이 됩니다.
 
 * 주의 : Redhat 5.x 대에서는 /etc/os-release 파일이 없어 정상 동작하지 않습니다. 다른 방식으로 변수 설정이 필요합니다.

이제 각 서버에서 ntp 를 install 또는 업데이트를 수행하면 1개의 repo 파일로 잘 수행됨을 알 수 있습니다.
```bash
(repository 검증)

대상 서버 # yum repolist
(정상이면 install 또는 update 수행 , update를 수행하면 repository내 동일 rpm 중 버전이 최신인 파일로 업데이트한다.)

```bash
대상 서버 # yum install ntp 
또는
대상 서버 # yum update ntp
```

요즘 워낙 code as infra니, 자동화 배포 툴이 잘되어 있어 아시는 분들도 많겠지만,
Linux를 특히 Redhat 계열의 배포판을 관리하시는 분들께 도움이 되었으면 하네요.
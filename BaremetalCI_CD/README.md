# Baremetal CI/CD For Infrastructure

Baremetal 향 CI/CD 를 가능한 곳까지 구현해 보자

## Test Environment

Basic Architecture : Git + Ansible + Jenkins + elastic search + etc...미정

1. VM : Virtualbox 5.1.26
2. Guest OS 1 : Host node(Git + Ansible 서버로 구성)

- OS media : Cent OS 7.3 1611 DVD
- HW : 1cpu, 2G mem, 30G OS disk, 10G stage disk
- SW : minimal install
- hostname : centos7base-1611 (OVA로 생성)
- Yum repo : local (/stage/Packages , /stage/add_rpms)
- additional rpms 
```bash
net-tools-2.0-0.17.20131004git.el7.x86_64
createrepo-0.9.9-26.el7   
> deltarpm-3.6-3.el7
> python-deltarpm-3.6-3.el7
> libxml2-python-2.9.1-6.el7_2.3
```

기본 설치 후 local yum repository 구성
```bash
 # rpm -Uvh createrepo-0.9.9-26.el7.noarch.rpm deltarpm-3.6-3.el7.x86_64.rpm python-deltarpm-3.6-3.el7.x86_64.rpm libxml2-python-2.9.1-6.el7_2.3.x86_64.rpm
warning: createrepo-0.9.9-26.el7.noarch.rpm: Header V3 RSA/SHA256 Signature, key                                         ID f4a80eb5: NOKEY
Preparing...                          ################################# [100%]
Updating / installing...
   1:deltarpm-3.6-3.el7               ################################# [ 25%]
   2:python-deltarpm-3.6-3.el7        ################################# [ 50%]
   3:libxml2-python-2.9.1-6.el7_2.3   ################################# [ 75%]
   4:createrepo-0.9.9-26.el7          ################################# [100%]
 # rpm-Uvh net-tools-2.0-0.17.20131004git.el7.x86_64.rpm
 # cd /stage/Packages
 # createrepo .
Spawning worker 0 with 3831 pkgs
Workers Finished
Saving Primary metadata
Saving file lists metadata
Saving other metadata
Generating sqlite DBs
Sqlite DBs complete
 # cd /etc/yum.repos.d/
 # cp CentOS-Base.repo local.repo
 # vi local.repo
 # yum repolist (에러 발생  dns client 설정하지 않았으므로)

```

이후 GIt 과 Ansible rpm 다운로드 우선 (특정 망은 외부 인터넷 단절로 별도로 다운로드가 필요 --downloadonly 옵션 사용)

실제 구성시에는 download 받은 rpm들로 별도 local repo 재구성하여 사용할 예정

```
# yum install git --downloadonly --downloaddir=/stage/add_rpms

   ... 전략 ...

Installing:
 git                                   x86_64                1.8.3.1-6.el7_2.1                base                4.4 M
Installing for dependencies:
 libgnome-keyring                      x86_64                3.8.0-3.el7                      base                109 k
 perl                                  x86_64                4:5.16.3-291.el7                 base                8.0 M
 perl-Carp                             noarch                1.26-244.el7                     base                 19 k
 perl-Encode                           x86_64                2.51-7.el7                       base                1.5 M
 perl-Error                            noarch                1:0.17020-2.el7                  base                 32 k
 perl-Exporter                         noarch                5.68-3.el7                       base                 28 k
 perl-File-Path                        noarch                2.09-2.el7                       base                 26 k
 perl-File-Temp                        noarch                0.23.01-3.el7                    base                 56 k
 perl-Filter                           x86_64                1.49-3.el7                       base                 76 k
 perl-Getopt-Long                      noarch                2.40-2.el7                       base                 56 k
 perl-Git                              noarch                1.8.3.1-6.el7_2.1                base                 53 k
 perl-HTTP-Tiny                        noarch                0.033-3.el7                      base                 38 k
 perl-PathTools                        x86_64                3.40-5.el7                       base                 82 k
 perl-Pod-Escapes                      noarch                1:1.04-291.el7                   base                 51 k
 perl-Pod-Perldoc                      noarch                3.20-4.el7                       base                 87 k
 perl-Pod-Simple                       noarch                1:3.28-4.el7                     base                216 k
 perl-Pod-Usage                        noarch                1.63-3.el7                       base                 27 k
 perl-Scalar-List-Utils                x86_64                1.27-248.el7                     base                 36 k
 perl-Socket                           x86_64                2.010-4.el7                      base                 49 k
 perl-Storable                         x86_64                2.45-3.el7                       base                 77 k
 perl-TermReadKey                      x86_64                2.30-20.el7                      base                 31 k
 perl-Text-ParseWords                  noarch                3.29-4.el7                       base                 14 k
 perl-Time-HiRes                       x86_64                4:1.9725-3.el7                   base                 45 k
 perl-Time-Local                       noarch                1.2300-2.el7                     base                 24 k
 perl-constant                         noarch                1.27-2.el7                       base                 19 k
 perl-libs                             x86_64                4:5.16.3-291.el7                 base                688 k
 perl-macros                           x86_64                4:5.16.3-291.el7                 base                 43 k
 perl-parent                           noarch                1:0.225-244.el7                  base                 12 k
 perl-podlators                        noarch                2.5.1-3.el7                      base                112 k
 perl-threads                          x86_64                1.87-4.el7                       base                 49 k
 perl-threads-shared                   x86_64                1.43-6.el7                       base                 39 k
 rsync                                 x86_64                3.0.9-17.el7                     base                360 k
 ... 중략 ...

 Total                                                                                   9.5 MB/s |  16 MB  00:00:01
exiting because "Download Only" specified

 # mkdir git
 # mv *.rpm git

 # yum install --downloadonly --downloaddir=/stage/add_rpms/ epel-release
Loaded plugins: fastestmirror
L...

========================================================================================================================
 Package                          Arch                       Version                   Repository                  Size
========================================================================================================================
Installing:
 epel-release                     noarch                     7-9                       extras                      14 k

Transaction Summary
========================================================================================================================
Install  1 Package

Total download size: 14 k
Installed size: 24 k
Background downloading packages, then exiting:
epel-release-7-9.noarch.rpm                                                                      |  14 kB  00:00:00
exiting because "Download Only" specified
 # ls
epel-release-7-9.noarch.rpm  git

 # yum install epel-release -y   <- 다음 ansible 다운을 위해 epel 일단 설치 진행 : epel용 repo 구성하는 것임

Loaded plugins: fastestmirror
...

Dependencies Resolved

========================================================================================================================
 Package                          Arch                       Version                   Repository                  Size
========================================================================================================================
Installing:
 epel-release                     noarch                     7-9                       extras                      14 k

Transaction Summary
========================================================================================================================
Install  1 Package
...
Installed:
  epel-release.noarch 0:7-9

Complete!

 # yum install --downloadonly --downloaddir=/stage/add_rpms/ ansible
Loaded plugins: fastestmirror
...

========================================================================================================================
 Package                                         Arch               Version                      Repository        Size
========================================================================================================================
Installing:
 ansible                                         noarch             2.3.1.0-1.el7                epel             5.7 M
Installing for dependencies:
 PyYAML                                          x86_64             3.10-11.el7                  base             153 k
 libtomcrypt                                     x86_64             1.17-25.el7                  epel             225 k
 libtommath                                      x86_64             0.42.0-5.el7                 epel              35 k
 libyaml                                         x86_64             0.1.4-11.el7_0               base              55 k
 python-babel                                    noarch             0.9.6-8.el7                  base             1.4 M
 python-backports                                x86_64             1.0-8.el7                    base             5.8 k
 python-backports-ssl_match_hostname             noarch             3.4.0.2-4.el7                base              12 k
 python-httplib2                                 noarch             0.7.7-3.el7                  epel              70 k
 python-jinja2                                   noarch             2.7.2-2.el7                  base             515 k
 python-keyczar                                  noarch             0.71c-2.el7                  epel             218 k
 python-markupsafe                               x86_64             0.11-10.el7                  base              25 k
 python-setuptools                               noarch             0.9.8-4.el7                  base             396 k
 python-six                                      noarch             1.9.0-2.el7                  base              29 k
 python2-crypto                                  x86_64             2.6.1-13.el7                 epel             476 k
 python2-ecdsa                                   noarch             0.13-4.el7                   epel              83 k
 python2-paramiko                                noarch             1.16.1-2.el7                 epel             258 k
 python2-pyasn1                                  noarch             0.1.9-7.el7                  base             100 k
 sshpass                                         x86_64             1.06-1.el7                   epel              21 k

Transaction Summary
========================================================================================================================
Install  1 Package (+18 Dependent packages)

Total download size: 9.7 M
Installed size: 44 M
Background downloading packages, then exiting:
(1/19): PyYAML-3.10-11.el7.x86_64.rpm                                                            | 153 kB  00:00:00
(2/19): libyaml-0.1.4-11.el7_0.x86_64.rpm                                                        |  55 kB  00:00:00
...
(19/19): ansible-2.3.1.0-1.el7.noarch.rpm                                                        | 5.7 MB  00:00:22
------------------------------------------------------------------------------------------------------------------------
Total                                                                                   441 kB/s | 9.7 MB  00:00:22
exiting because "Download Only" specified

 # mkdir ansible
 # mv *.rpm ansible
 # ls
ansible  git

```

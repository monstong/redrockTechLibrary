# Ansible

You can also build an RPM yourself. From the root of a checkout or tarball, use the ```make rpm``` command to build an RPM you can distribute and install. Make sure you have ```rpm-build```, ```make```, ```asciidoc```, ```git```, ```python-setuptools``` and ```python2-devel``` installed.

```bash
$ git clone git://github.com/ansible/ansible.git --recursive
$ cd ./ansible
$ make rpm
$ sudo rpm -Uvh ./rpm-build/ansible-*.noarch.rpm
```

Required RPMs' dependencies
```
Installing:
 asciidoc                noarch        8.6.8-5.el7            base        251 k
Installing for dependencies:
 boost-regex             x86_64        1.53.0-26.el7          base        300 k
 ctags                   x86_64        5.8-13.el7             base        155 k
 graphviz                x86_64        2.30.1-19.el7          base        1.3 M
 source-highlight        x86_64        3.1.6-6.el7            base        611 k



# rpm -Uvh ansible-2.4.0-100.git201707101602.6fd579b.devel.el7.centos.noarch.rpm
error: Failed dependencies:
        sshpass is needed by ansible-2.4.0-100.git201707101602.6fd579b.devel.el7.centos.noarch
```

### how to download RPM only via yum.

use the follow options when run the yum command.

**```yum install [RPM name] --downloadonly --downloaddir=.```**

```
# yum install git --downloadonly --downloaddir=.
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * base: centos.mirror.cdnetworks.com
 * extras: mirror.navercorp.com
 * updates: centos.mirror.cdnetworks.com
Resolving Dependencies
--> Running transaction check
---> Package git.x86_64 0:1.8.3.1-6.el7_2.1 will be installed
--> Processing Dependency: perl-Git = 1.8.3.1-6.el7_2.1 for package: git-1.8.3.1-6.el7_2.1.x86_64
--> Processing Dependency: perl(Git) for package: git-1.8.3.1-6.el7_2.1.x86_64
--> Running transaction check
---> Package perl-Git.noarch 0:1.8.3.1-6.el7_2.1 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package          Arch           Version                     Repository    Size
================================================================================
Installing:
 git              x86_64         1.8.3.1-6.el7_2.1           base         4.4 M
Installing for dependencies:
 perl-Git         noarch         1.8.3.1-6.el7_2.1           base          53 k

Transaction Summary
================================================================================
Install  1 Package (+1 Dependent package)

Total download size: 4.4 M
Installed size: 22 M
Background downloading packages, then exiting:
(1/2): perl-Git-1.8.3.1-6.el7_2.1.noarch.rpm               |  53 kB   00:00
(2/2): git-1.8.3.1-6.el7_2.1.x86_64.rpm                    | 4.4 MB   00:00
--------------------------------------------------------------------------------
Total                                              6.2 MB/s | 4.4 MB  00:00
exiting because "Download Only" specified
# ls
git-1.8.3.1-6.el7_2.1.x86_64.rpm
perl-Git-1.8.3.1-6.el7_2.1.noarch.rpm
```





## references
[https://docs.ansible.com](http://docs.ansible.com/ansible/latest/intro_installation.html#latest-release-via-yum)
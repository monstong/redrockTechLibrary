# **Unable to Power on VM with "Connection refused" error.**

VCSA 환경에서 Virtual Machine이 실행이 되지 않을 때의 CASE 중 하나입니다.
구글링을 하면  많이 검색되긴 한데  개인용 정리겸  한글로 정리에 의의를 두어 보았습니다. ^^;

## **Simptom**
vsphere client 또는 vsphere web client에서 특정 VM을 실행시 아래 오류가 발생하면서 Power on이 fail됩니다.
- **Error No** : `A general system error occurred: Connection refused` 


## **Solution**
구글링을 해보니 보통 이경우는 vCEnter workflow Manager service가 중지되었을 때 발생할 수 있다고 하네요.
아래와 같이 해당 서비스의 구동 상태를 확인 후 중지되어 있다면 시작해 주시면 됩니다.

  - **caution** : 해당 조치 방법은 VCSA 6.0 버전만 해당됩니다. 

  - **caution** : 물론 아무 이유없이 workflow manager service가 중지되지 않았을 수도 있습니다. 이경우는 2차 트러블 슈팅이 필요합니다. Root cause를 해결후  아래 절차를 수행해 주시면 됩니다.
    * 제 경우는  /storage/log filesystem이 100%로 full 발생하여 workflow manager service가 중지된 케이스여서 다음 링크와 같이 파일시스템 Full 이슈 해결 후 서비스 기동하였습니다. [Filesystem Full 조치 방법](Filesystem_full_in_VCSA.md)


 1. connect to VCSA with SSH(root유저) : VCSA에 SSH를 통하여 접속합니다. (putty등 터미널 클라이언트 이용)
    * 필요시 vCenter Management URL에서 SSH enable 진행합니다.

 1. Shell 모드로 진입 : 버전별로 좀 다르지만 아래와 같이 shell모드로 진입합니다.

    ```
    (VCSA 6.0)
    Command> shell.set --enabled True
    Command> shell
    ```

 1. check the status of the VMware vCenter Workflow Manager Service : 서비스 기동 상태를 확인합니다.

    ```
    bash # service-control --status vmware-vpx-workflow
    ```

 1. Start the VMware vCenter Workflow Manager Service :서비스가 중지되어 있다면 시작합니다.

    ```
    bash # service-control --start vmware-vpx-workflow
    ```

## **references**
 - [http://virtualization24x7.blogspot.com/2016/01/unable-to-power-on-vm-in-vcenter-6.html](http://virtualization24x7.blogspot.com/2016/01/unable-to-power-on-vm-in-vcenter-6.html)

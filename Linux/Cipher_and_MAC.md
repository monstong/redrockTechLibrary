# What is the Cipher and MAC ?

 - 요즘 나오는 대부분의 오픈소스 혹은 상용 software들이 많이 사용하는 REST API call을 사용하다 보면, 인증을 위한 Authorization 헤더 생성시 HMAC으로 인코딩 어쩌고를 하는 걸 볼 수 있습니다.

 - 이외에도 최근 NSX-T 의 overlay 네트워크내 VM들과  외부 네트워크가 연결된 VM간 SSH 통신 이슈(expecting SSH2_MSG_KEX_DH_GEX_REPLY hanging 이슈 - ssh debug모드로 확인 가능) 의 해결책( -o macs=hmac-md5 설정을 하거나 mtu 재조정으로 해결)에서도 언급되기도 하는 MAC 과 cipher가 무엇인지 개념을 간단하게  지극히 개인 정리용으로 정리해 보았습니다.

## MAC (Message authentication code)
 - 원격지와 통신시 송수신되는 메세지의 훼손을 확인하는 용도로 사용되는 메세지 인증 코드입니다.
 - 간단한 예시로 Centos iso 파일을 다운로드 받고 혹시 파일이 깨지지 않았는지 확인할 때 md5sum이나 cksum의 수행결과와  공식 다운로드 페이지에 언급된  check sum 태그를 비교해 보는 부분으로 이해할 수도 있습니다.

 > In cryptography, a message authentication code (MAC), sometimes known as a tag, is a short piece of information used to authenticate a message—in other words, to confirm that the message came from the stated sender (its authenticity) and has not been changed. The MAC value protects both a message's data integrity as well as its authenticity, by allowing verifiers (who also possess the secret key) to detect any changes to the message content.  - from Wikipedia

## MAC procedure
 1. Sender가 MAC value를 생성합니다. (secrete key와 임의의 길이의 메세지를 입력 받아 선택한 암호화 알고리즘으로 생성)
 2. 생성한 MAC value 와 원본 메세지를 Receiver에게 보냅니다.
 3. 생성된 MAC value는 역산(복호화)가 불가능하므로  전달 받은 원본 메세지를 이용해 동일한 방식으로 MAC value를 생성합니다.
 4. 2번 단계에서 전달받은 MAC value와 비교해  원본 메세지가 훼손이 있는지 확인합니다.

 - 위와 같이 원본 데이터의 변조 또는 훼손이 있었는지 확인 가능하므로 통신간 데이터 무결성을 보장하고 특히 중요한 인증용 정보를 주고 받을 때 사용합니다. (단, 메세지 자체를 암호화하지는 않습니다.)

## HMAC 이란 ?
 - MAC 사용되는 Key에 따라 CMAC, HMAC, VMAC등 여러가지 방식이 존재합니다.
 - HMAC 은 Hash based Messages authentication code) 로 Sender 와 Receiver 간에만 공유되는 Shared secret key와 메세지만으로 해시값 즉 MAC value를 구성하는 방식입니다.
   * secret key로 inner/outter key 2개를 생성
   * inner key 와 메세지로 1st pass 생성
   * outer key 와 1st pass로 final MAC value 생성

## Cipher 란 ?
 - 암호화와 복호화를 수행하는 알고리즘입니다. 
 > In cryptography, a cipher (or cypher) is an algorithm for performing encryption or decryption - from wikipedia

 - 암호화/복호화시 사용되는 Key type에 따라 두가지(대칭/비대칭)로 나눌 수 있습니다.
   * symmetric key algorithms (Private-key cryptography) : 암호화 /복호화시  같은 키를 사용 , sender와 receiver가 미리 shared key를 가지고 있어야 함 , 대부분의 block cipher 알고리즘이 이에 해당 (예: AES, DES)
   * asymmetric key algorithms (Public-key cryptography) : 암호화 /복호화시 다른 키를 사용 , public key는 공유되어 어떤 sender도 암호화할 수 있음, 복호화는 private key를 가진  receiver만 가능 (예: RSA)
   , where two different keys are used for encryption and decryption.

 - Input data의 종류에 따라 두가지로 나누기도 합니다.
   * block ciphers : 고정크기의 Block 단위 데이터를 암호화
   * stream ciphers : 연속적인 stream 형태의 데이터를 암호화

## Cipher and MAC in SSH
 - `man ssh_config`을 수행하거나 `cat /etc/ssh/ssh_config`을 보면 관련 내용을 가장 정확히 알 수 있습니다.
    ```bash
    [root@centos01 ~]# man ssh_config
    /Cipher
        Cipher  Specifies the cipher to use for encrypting the session in proto‐
                col version 1.  Currently, blowfish, 3des (the default), and des
                are supported, though des is only supported in the ssh(1) client
                for interoperability with legacy protocol 1 implementations; its
                use is strongly discouraged due to cryptographic weaknesses.

        Ciphers
                Specifies the ciphers allowed for protocol version 2 in order of
                preference.  Multiple ciphers must be comma-separated.  If the
                specified value begins with a ‘+’ character, then the specified
                ciphers will be appended to the default set instead of replacing
                them.
    /MAC
        MACs    Specifies the MAC (message authentication code) algorithms in
                order of preference.  The MAC algorithm is used for data
                integrity protection.  Multiple algorithms must be comma-sepa‐
                rated.  If the specified value begins with a ‘+’ character, then
                the specified algorithms will be appended to the default set
                instead of replacing them.

    [root@centos01 ~]# cat /etc/ssh/ssh_config | grep -e "Cipher" -e "MAC"
    #   Cipher 3des
    #   Ciphers aes128-ctr,aes192-ctr,aes256-ctr,arcfour256,arcfour128,aes128-cbc,3des-cbc
    #   MACs hmac-md5,hmac-sha1,umac-64@openssh.com,hmac-ripemd160
    ```

 - Cipher와 MAC 모두 SSH2에서 multiple 알고리즘을 허용하므로 default order의 정의된 리스트(콤마로 구분)들을 순서대로 확인하여 가용한 알고리즘을 사용합니다.

 - 설치된 openssh 에서 지원하는  ciphers 와 MAC을 보고 싶을 때 (default order가 아닌 알고리즘이 적용이 필요할 수 있음) 'ssh -Q` 옵션으로 query 할 수 있습니다.
    ```bash
    [root@centos01 ~]# ssh -Q cipher
    3des-cbc
    blowfish-cbc
    cast128-cbc
    ... 중략 ...
    aes256-gcm@openssh.com
    chacha20-poly1305@openssh.com

    [root@centos01 ~]# ssh -Q mac
    hmac-sha1
    hmac-sha1-96
    hmac-sha2-256
    ... 중략 ...
    umac-64-etm@openssh.com
    umac-128-etm@openssh.com
    ```

 - 임시로 특정 cipher또는 mac 알고리즘을 사용토록 지정시에는 `ssh -o`옵션을 사용합니다.
    ```bash
    [root@centos01 ~]# ssh 192.168.200.215 -omacs=hmac-md5
    The authenticity of host '192.168.200.215 (192.168.200.215)' can't be established.
    ECDSA key fingerprint is SHA256:LMSqmS8NsKtwNE9CcYeaZ9PPtQFiZBx2tQWvL2KrwVU.
    ECDSA key fingerprint is MD5:1d:9e:f1:96:d3:bc:36:55:bd:c6:3c:e9:06:a0:59:a6.
    Are you sure you want to continue connecting (yes/no)?
    ```

## Summary
 - MAC은 메세지의 무결성을 보장하지만 자체를 암호화하지는 않습니다.
 - Cipher는 암호화/복호화를 하기 위한 알고리즘을 말합니다. (키사용 방식에 따라 대칭/비대칭, 데이터 종류에 따라 block/stream cipher로 나눌 수 있음)
 - SSH 는 Secure Shell로  원격 접근을 위한 Secrured connection이 중요하므로 cipher 알고리즘과 MAC 방식을 사용하며, 필요시 특정 set으로 설정할 수 있습니다.
 
## References
 - MAC 관련
   * sncap style 블로그(MAC설명) : https://en.wikipedia.org/wiki/Message_authentication_code
   * MAC wikipedia : https://sncap.tistory.com/460
   * HMAC wikipedia : https://en.wikipedia.org/wiki/HMAC
   

 - Cipher 관련
   * Cipher wikipedia : https://en.wikipedia.org/wiki/Cipher


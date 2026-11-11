# 🐧 Linux Server Practice

한국폴리텍대학 **AI소프트웨어과 하이테크과정** 리눅스 수업(금요일)에서 Ubuntu로 실습한 내용과 손필기를 정리한 저장소입니다.
명령어를 외우는 데서 끝내지 않고, **권한 → 편집기 → 웹 서버 → 서비스 관리** 순서로 서버 한 대를 직접 운영해 보는 흐름으로 정리했습니다.

| 항목 | 내용 |
|---|---|
| 환경 | Ubuntu Linux |
| 범위 | 리눅스마스터 대비 기본 명령 + 서버 실습 (Apache, MariaDB, Samba) |
| 함께 보기 | 수업 손필기 사진: [`notes/`](notes) |

---

## 🗺 학습 로드맵

| 단계 | 폴더 | 내용 |
|---|---|---|
| 1 | [01-shell-permissions](01-shell-permissions) | 셸 기본 명령, `history`, 환경 설정 파일, **파일 속성 읽기, `chmod` 기호·숫자 모드, `umask`** |
| 2 | [02-vim](02-vim) | vi 모드 전환, 편집·검색·치환 명령, **나만의 `.vimrc` 설정 파일** |
| 3 | [03-apache-web-server](03-apache-web-server) | Apache 설치·서비스 관리, **UserDir(`public_html`)로 자기소개 홈페이지 띄우기**, 웹 문서 권한 설정 |
| 4 | [04-process-service](04-process-service) | `ps`·`kill`·시그널, 백그라운드 작업, **`crontab` 예약 실행, `systemd`·`systemctl` 서비스 관리**, `shutdown` |
| 5 | [05-package-disk-archive](05-package-disk-archive) | `apt-get`, `/etc/fstab`, `fdisk`, **`tar` 압축·해제** |
| 6 | MariaDB | 설치와 서비스 관리, 서버 설정 *(명령 기록 정리 예정)* |
| 7 | Samba · Network | Samba 버전 확인, 네트워크 인터페이스·IP 주소 확인 *(명령 기록 정리 예정)* |

## ✍️ 정리하면서 신경 쓴 점

- **권한은 숫자로 계산할 수 있게**: `rw-` = 110(2진수) = 4+2+0 = 6. 웹 서버 실습에서 홈페이지를 띄울 때 쓰는 `chmod 711 / 755 / 644`도 이 계산으로 읽을 수 있습니다.
- **서비스는 systemd 관점에서**: Apache, cron, MariaDB 모두 같은 `systemctl start / status / enable` 흐름으로 관리합니다.
- **필기 원본도 함께**: 각 README 위쪽에 해당 필기 사진 링크를 달았습니다.

## 📂 폴더 구조

```text
linux-server-practice/
├── 01-shell-permissions/      셸 기본 · 파일 권한 · umask
├── 02-vim/                    vi 명령 정리 · .vimrc
├── 03-apache-web-server/      Apache · public_html 자기소개 페이지
├── 04-process-service/        프로세스 · 시그널 · crontab · systemd
├── 05-package-disk-archive/   apt · fstab · fdisk · tar
└── notes/                     리눅스 손필기 사진
```

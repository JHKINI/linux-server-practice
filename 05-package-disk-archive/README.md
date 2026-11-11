# 05. 패키지 · 디스크 · 압축

> 수업 필기 정리 · 원본: [`p22`](../notes/images/p22_systemd.jpg), [`p24`](../notes/images/p24_apt.jpg), [`p25`](../notes/images/p25_tar.jpg)

## 패키지 관리 (apt)

```bash
sudo apt-get update            # 패키지 목록 새로고침
sudo apt-get install apache2   # 설치
apt-cache stats                # 패키지 캐시 통계
```

## 디스크 · 파일 시스템

```bash
cat /etc/fstab    # ★ 부팅할 때 자동으로 마운트할 파일 시스템 목록
sudo fdisk -l     # 디스크와 파티션 보기
```

## 파일 아카이브: tar (교재 p.485) ★

옵션 `c` `v` `z`가 중요

| 옵션 | 의미 |
|---|---|
| `c` | 묶기 (create) |
| `x` | 풀기 (extract) |
| `v` | 진행 과정 보여주기 (verbose) |
| `z` | gzip으로 압축 / 해제 |
| `f` | 파일 이름 지정 (맨 뒤에) |

```bash
tar cvzf backup.tar.gz 폴더/   # 묶고 압축
tar xvzf backup.tar.gz         # 압축 풀기
tar tvzf backup.tar.gz         # 안에 뭐가 있는지만 보기
```

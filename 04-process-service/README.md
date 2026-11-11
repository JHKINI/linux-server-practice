# 04. 프로세스 · 작업 예약 · 서비스 관리

> 수업 필기 정리 · 원본: [`p21`](../notes/images/p21_umask_signal_process_cron.jpg), [`p22`](../notes/images/p22_systemd.jpg), [`p23`](../notes/images/p23_systemctl_shutdown.jpg)

## 프로세스 확인과 종료

```bash
man ps          # 명령어 설명 보기
ps -ef          # 전체 프로세스 목록
kill -9 4005    # 4005번 프로세스 강제 종료
top             # CPU·메모리 사용량 실시간 보기 (종료: Ctrl+C, 다른 창에서 killall top)
top >> a.txt    # 결과를 파일에 로그로 남기기 (기록 형식 확인이 중요)
```

## 시그널

| 시그널 | 번호 | 언제 |
|---|---|---|
| SIGHUP | 1 | 터미널 연결이 끊겼을 때 |
| SIGINT | 2 | `Ctrl + C` (종료 요청) |
| SIGQUIT | 3 | `Ctrl + \` |
| **SIGKILL** | **9** | **강제 종료** (좀비 프로세스 정리에 사용) |
| SIGALRM | 14 | 알람 |
| SIGTERM | 15 | `kill` 명령의 기본값 (정상 종료 요청) |

## 포그라운드 / 백그라운드

```bash
sleep 100 &       # 백그라운드로 실행
jobs              # 작업 목록
# Ctrl + Z        # 실행 중인 작업 일시 정지
fg                # 포그라운드로 가져오기
nohup 명령 &       # 로그아웃해도 계속 실행
```

## crontab: 정기 예약 실행 ★

```bash
crontab -e    # 편집
crontab -l    # 목록 보기
crontab -r    # 전체 삭제
```

```text
# 분  시  일  월  요일   작업
  30  23  1   *   *     /usr/bin/명령     # 매월 1일 23:30에 실행
```

## systemd ★★

- **시스템과 서비스를 관리하는 프로그램**. 예전의 `init`을 대신한다.
- 데몬(백그라운드에서 특정 서비스를 제공하는 프로세스)을 시작하고 상태를 유지·관리한다.
- 장점: inetd와 호환, fsck 제어 가능, ★ **서비스에 시그널을 전달할 수 있다**
- 관리 단위는 **유닛(unit)**: 예) `cron.service`, `apache2.service`

```bash
systemctl [옵션] [명령] [유닛명]
# 명령: start stop reload restart status enable is-active is-enabled isolate kill

systemctl -t service             # 서비스 유형의 유닛 목록
sudo systemctl start cron        # 관리자 권한으로 cron 시작
systemctl status cron            # 상태 확인
```

## 시스템 종료와 재시작

```bash
sudo shutdown -h now               # 지금 끄기
sudo shutdown -r +3 "곧 재시작"     # 3분 뒤 재시작 + 메시지
sudo shutdown -c                   # 예약 취소
```

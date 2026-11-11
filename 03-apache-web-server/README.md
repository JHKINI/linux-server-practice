# 03. Apache 웹 서버

Ubuntu에 Apache를 설치하고, 사용자 홈의 `public_html` 폴더로 **자기소개 홈페이지**를 띄운 실습입니다.

| 파일 | 내용 |
|---|---|
| [`index.html`](index.html) | 자기소개 페이지 (About Me, Skills, Projects, Career Goal, Contact) |
| [`index-root.html`](index-root.html) | 같은 페이지의 다른 사본 (끝 빈 줄 하나만 다름) |

## 실습 흐름

```bash
# 1. 설치와 서비스 관리
sudo apt-get install apache2
sudo systemctl start apache2
sudo systemctl enable apache2       # 부팅할 때 자동 시작
systemctl status apache2

# 2. 사용자 홈페이지(UserDir) 사용
sudo a2enmod userdir
sudo systemctl restart apache2
mkdir ~/public_html
cp index.html ~/public_html/

# 3. 권한: 웹 서버(다른 사용자)가 읽을 수 있어야 함
chmod 711 ~                          # 홈 디렉터리: 들어가기만 허용
chmod 755 ~/public_html              # 폴더: 읽기·들어가기 허용
chmod 644 ~/public_html/index.html   # 파일: 읽기 허용

# 접속: http://서버주소/~사용자이름/
```

- 권한이 부족하면 브라우저에 **403 Forbidden**이 뜹니다. → [01. 파일 권한](../01-shell-permissions)에서 정리한 숫자 모드로 맞춤
- `systemctl` 명령은 [04. 프로세스 · 서비스](../04-process-service) 참고

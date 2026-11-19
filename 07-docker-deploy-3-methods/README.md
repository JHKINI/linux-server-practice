# Docker 배포 3가지 방식 정리 (iris_pca_knn_flask 예제)

같은 Flask 앱(iris_pca_knn_flask)을 기준으로, Docker로 배포하는 방법을 자동화 수준에 따라 3단계로 정리한다.

```
① 수동(순수 docker run)  →  ② Dockerfile + 수동 build/run  →  ③ docker compose
   자동화 거의 없음              레시피는 있지만 명령은 직접         레시피 + 실행 설정까지 선언적으로
```

세 방식 모두 "실행 결과"는 같다(같은 소스/모델을 같은 포트로 서비스). 차이는 **반복 배포를 얼마나 자동화하느냐**다.

---

## 방식 ① : 수동 (base 이미지 + requirements를 그 자리에서 설치)

FTP(FileZilla)로 소스코드/모델/`requirements.txt`만 서버에 올려두고, Dockerfile 없이 base 이미지 컨테이너를 띄워서 **그 안에서 직접** 패키지를 설치하고 실행하는 방식.

```bash
# 1) FTP로 올린 폴더로 이동
cd ~/iris_pca_knn_flask

# 2) base 이미지로 컨테이너를 띄우고 그 안에서 작업
#    -v  : 소스코드를 컨테이너 내부 경로에 볼륨으로 연결
#    -p  : 포트 매핑
#    --name : 컨테이너 이름 지정
sudo docker run -it \
  --name iris-manual \
  -p 5003:5003 \
  -v ~/iris_pca_knn_flask:/app \
  -w /app \
  python:3.12-slim bash

# 3) (컨테이너 안에서) 의존성 설치 + 실행
pip install -r requirements.txt
python app.py
```

- 장점: Dockerfile 없이 바로 확인 가능, 개념 이해하기 좋음
- 단점: 컨테이너를 지우면 설치한 패키지도 날아감(이미지로 저장 안 함), 재배포할 때마다 같은 걸 손으로 또 쳐야 함, 명령어가 길고 사람이 외워야 함

---

## 방식 ② : Dockerfile 작성 → 수동 build/run

이번엔 "컨테이너에 뭘 복사하고, 뭘 설치할지"를 **Dockerfile(레시피)** 로 고정해두고, 그 레시피로 **나만의 이미지**를 빌드한 뒤 실행한다. 실행 명령(`docker run`)은 여전히 직접 친다.

**Dockerfile** (소스 위치 기준으로 작성):
```dockerfile
FROM python:3.12-slim
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
COPY templates/ templates/
COPY static/ static/
COPY img/ img/
COPY model/ model/

EXPOSE 5003
CMD ["python", "app.py"]
```

**빌드 + 실행** (명령어는 직접):
```bash
cd ~/iris_pca_knn_flask

# 이 Dockerfile 레시피로 "나만의 이미지" 빌드
sudo docker build -t iris-pca-knn-flask:v1 .

# 그 이미지로 컨테이너 실행 (포트/이름을 직접 맞춰줌)
sudo docker run -d \
  --name iris-pca-knn-flask \
  --restart unless-stopped \
  -p 5003:5003 \
  iris-pca-knn-flask:v1

sudo docker ps
sudo docker logs -f iris-pca-knn-flask
```

- 장점: 이미지로 고정되어 어디서든 같은 결과 재현 가능(①과 가장 큰 차이), 재배포 시 `build` 한 번이면 끝
- 단점: 포트/이름/재시작정책 같은 실행 옵션은 매번 명령어로 직접 입력해야 함 → 사람이 옵션을 틀릴 여지가 있음

---

## 방식 ③ : docker compose (가장 자동화됨)

②의 Dockerfile(레시피)은 그대로 쓰되, **실행 옵션(포트·이름·재시작정책·헬스체크 등)까지 `docker-compose.yml` 한 파일에 선언**해두는 방식. 이번 iris 프로젝트 실제 배포에 사용한 방식이다.

**docker-compose.yml**:
```yaml
services:
  iris-flask:
    build:
      context: .
      dockerfile: Dockerfile
    image: iris-pca-knn-flask:latest
    container_name: iris-pca-knn-flask
    restart: unless-stopped
    ports:
      - "5003:5003"
    healthcheck:
      test: ["CMD", "python", "-c", "import urllib.request,sys; sys.exit(0 if urllib.request.urlopen('http://127.0.0.1:5003/').status==200 else 1)"]
      interval: 30s
      timeout: 3s
      start_period: 10s
      retries: 3
```

**빌드 + 실행 (한 줄)**:
```bash
cd ~/iris_pca_knn_flask
sudo docker compose up -d --build
sudo docker compose ps
sudo docker compose logs -f
```

**재배포 / 종료**:
```bash
sudo docker compose up -d --build   # 코드/모델 수정 후 재배포
sudo docker compose down            # 종료 + 컨테이너 제거
```

- 장점: build + run + 옵션 전부가 파일 하나로 선언 → 누가 봐도 같은 결과 재현, 명령어 한 줄로 끝, Git으로 버전관리 가능
- 단점: compose 문법을 추가로 알아야 함(러닝커브는 Dockerfile보다 낮음)

---

## 세 방식 비교

| | ① 수동(base 이미지) | ② Dockerfile + 수동 run | ③ docker compose |
|---|---|---|---|
| 레시피(이미지) 고정 | ❌ (컨테이너 지우면 사라짐) | ✅ | ✅ |
| 실행 옵션 반복 입력 | 매번 전부 직접 | 매번 직접 | ❌ (파일에 선언) |
| 재배포 명령 | 전부 다시 | `build` + `run` | `up -d --build` 한 줄 |
| 적합한 상황 | 개념 학습, 1회성 테스트 | 간단한 단일 컨테이너 | 반복 배포, 여러 서비스 연동 |

---
*iris_pca_knn_flask 프로젝트 배포 실습 과정에서 정리.*

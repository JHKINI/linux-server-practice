" --- 외관 및 인터페이스 설정 ---

set number        " 줄 번호 표시
set hlsearch      " 검색어 하이라이트 표시
set ignorecase    " 검색 시 대소문자 무시
set smartcase     " 검색어에 대문자가 있으면 대소문자 구분
set ruler         " 하단 상태바에 현재 커서 위치 표시
set wildmenu      " 명령행 완성 기능을 시각적으로 표시
set laststatus=2  " 항상 상태 표시줄을 표시

" --- 들여쓰기 및 탭 설정 ---

set autoindent    " 자동 들여쓰기
set cindent       " C 언어 스타일 들여쓰기
set tabstop=4     " 탭 간격을 4칸으로 설정
set shiftwidth=4  " 자동 들여쓰기 시 4칸 사용
set expandtab     " 탭을 공백(스페이스)으로 변환

" --- 기타 편의 설정 ---

set history=1000  " 명령어 기록 저장 개수 설정
set nobackup      " 백업 파일을 생성하지 않음
set nowritebackup " 저장 시 백업 파일을 생성하지 않음
syntax on         " 코드 구문 강조(하이라이트) 활성화

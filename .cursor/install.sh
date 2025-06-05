#!/bin/bash
set -e

echo "🚀 프로젝트 의존성 설치를 시작합니다..."

# 환경 변수 설정 (기존 설치된 도구들 사용)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
export PATH="$HOME/.cargo/bin:$PATH"

# Node.js 20 사용 (이미 설치되어 있다고 가정)
echo "📦 Node.js 20 사용 설정 중..."
nvm use 20 2>/dev/null || echo "⚠️ Node.js 20이 설치되어 있지 않습니다. 기본 Node.js를 사용합니다."

# 백엔드 의존성 설치 (uv 사용)
if [ -d "backend" ]; then
    echo "⚡ FastAPI 백엔드 의존성 설치 중..."
    cd backend
    if [ -f "pyproject.toml" ]; then
        uv sync
    elif [ -f "requirements.txt" ]; then
        uv pip install -r requirements.txt
    else
        echo "⚠️  pyproject.toml 또는 requirements.txt 파일이 없습니다. 기본 FastAPI 의존성을 설치합니다."
        uv pip install fastapi uvicorn python-multipart sqlalchemy alembic
    fi
    cd ..
fi

# 프론트엔드 의존성 설치
if [ -d "frontend" ]; then
    echo "⚛️  React 프론트엔드 의존성 설치 중..."
    cd frontend
    if [ -f "package.json" ]; then
        npm install
    else
        echo "⚠️  package.json 파일이 없습니다. 기본 React + TailwindCSS 프로젝트를 설정합니다."
        npx create-react-app . --template typescript
        npm install -D tailwindcss postcss autoprefixer
        npx tailwindcss init -p
    fi
    cd ..
fi

# 프로젝트 구조가 없는 경우 기본 구조 생성
if [ ! -d "backend" ] && [ ! -d "frontend" ]; then
    echo "📁 기본 프로젝트 구조를 생성합니다..."
    mkdir -p backend frontend
    echo "✅ backend와 frontend 디렉토리가 생성되었습니다."
fi

echo "✅ 프로젝트 의존성 설치가 완료되었습니다!"
echo "🔥 이제 백그라운드 에이전트가 FastAPI + React 게시판 개발을 시작할 수 있습니다." 
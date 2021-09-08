
ARG PYTHON_VERSION=3.8

FROM python:${PYTHON_VERSION}-alpine

ENV PYTHONDONTWRITEBYTECODE 1
ARG POETRY_VERSION=1.1.8

RUN apk add --no-cache \
    curl \
    gcc \
    libressl-dev \
    musl-dev \
    cargo \
    python3-dev \
    openssl-dev \
    libffi-dev && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile=minimal && \
    source $HOME/.cargo/env && \
    pip install --no-cache-dir poetry==${POETRY_VERSION} && \
    apk del \
    curl \
    gcc \
    libressl-dev \
    musl-dev \
    libffi-dev

WORKDIR /src

ONBUILD COPY pyproject.toml pyproject.toml
ONBUILD COPY poetry.lock poetry.lock

ONBUILD RUN poetry export -f requirements.txt --without-hashes -o /src/requirements.txt

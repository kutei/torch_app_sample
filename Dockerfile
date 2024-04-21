FROM nvidia/cuda:12.3.2-cudnn9-devel-ubuntu22.04

ARG PYTHON_VERSION=3.11.9
ARG POETRY_VERSION=1.7.1
ARG POETRY_HOME=/opt/poetry
ARG GUEST_UNAME=app
ARG GUEST_UID=1000
ARG GUEST_GID=1000

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        # dev tools
        curl git vim \
        # pyenv build
        build-essential libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev libncursesw5-dev xz-utils \
        tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
        # for install poetry
        python3 python3-distutils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN export POETRY_VERSION=${POETRY_VERSION} \
    && export POETRY_HOME=${POETRY_HOME} \
    && curl -sSL https://install.python-poetry.org | python3 - \
    && ln -s /opt/poetry/bin/poetry /usr/local/bin/poetry

RUN groupadd ${GUEST_UNAME} --gid ${GUEST_GID} \
    && useradd ${GUEST_UNAME} --uid ${GUEST_UID} --gid ${GUEST_GID} -m
USER ${GUEST_UNAME}

# install pyenv
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv \
    && echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.init_pyenv \
    && echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.init_pyenv \
    && echo 'eval "$(pyenv init -)"' >> ~/.init_pyenv \
    && echo 'source ~/.init_pyenv' >> ~/.bashrc

WORKDIR /app
COPY pyproject.toml poetry.lock /app/
RUN . ~/.init_pyenv \
    && PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install ${PYTHON_VERSION} \
    && pyenv global ${PYTHON_VERSION} \
    && poetry env use $(which python) \
    && poetry install

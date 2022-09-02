FROM jinaai/jina:master-py38-perf

LABEL org.opencontainers.image.description Built against Jina ${JINA_VERSION} (Python ${PYTHON_VERSION}).

# install requirements before copying the workspace
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir --compile -r requirements.txt

# setup the workspace
COPY . /workspace
WORKDIR /workspace

ENTRYPOINT ["jina", "executor", "--uses", "config.yml"]
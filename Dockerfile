FROM jinaai/jina:3.8-py38-perf

# install requirements before copying the workspace
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir --compile -r requirements.txt

# setup the workspace
COPY . /workspace
WORKDIR /workspace

ENTRYPOINT ["jina", "executor", "--uses", "config.yml"]
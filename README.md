# TransformerTorchEncoder (CUDA 11.3)

**TransformerTorchEncoderCU113** is a modified version of Jina's [TransformerTorchEncoder](https://github.com/jina-ai/executor-text-transformers-torch-encoder/) executor. It differs in the following ways:

* PyTorch has been upgraded to 1.10
* CUDA 11.3 is supported (i.e. the GPU image installs `torch==1.10.0+cu113`)
* For M1 Mac and other ARM users, CPU-only `linux/arm64` are available from GitHub Container Registry ([instructions](#github-container-registry-for-m1other-arm-systems))

**TransformerTorchEncoderCU113** wraps the torch-version of transformers from huggingface. It encodes text data into dense vectors.

**TransformerTorchEncoderCU113** receives [`Documents`](https://docs.jina.ai/fundamentals/document/) with `text` attributes.
The `text` attribute represents the text to be encoded. This Executor will encode each `text` into a dense vector and store them in the `embedding` attribute of the `Document`.


## Usage

Use the prebuilt images from Jina Hub in your Flow and encode an image:

```python
from jina import Flow, Document

f = Flow().add(uses='jinahub+docker://TransformerTorchEncoderCU113')

doc = Document(content='my sentence to be encoded')

with f:
    f.post(on='/index', inputs=doc, on_done=lambda resp: print(resp.docs[0].embedding))
```

### GitHub Container Registry (for M1/other ARM systems)

Jina Hub builds only support `amd64` systems, which means the executor will be emulated by Docker, which is significantly slower.

This executor is also built for the `arm64` platform and pushed to GitHub Container Registry. If you use an M1 Mac or other ARM-based system, you should use this instead. `amd64` builds are also provided, so you can deploy to an `amd64`-based server using the _same container address_.

Only the CPU image is built cross-platform, but for completeness `amd64`-only builds of the GPU executor are also available from GHCR.

Unlike using Jina Hub, these images will **not automatically be rebuilt to match your local version**. Images will always are always built against the then-`master` version of Jina's base image - check the description for each image on the [registry page](https://github.com/freddyheppell/executor-text-transformers-torch-encoder/pkgs/container/transformer-torch-encoder-cu113/versions?filters%5Bversion_type%5D=tagged) to see what version this was.

Replace your `uses` with:
```
docker://ghcr.io/freddyheppell/transformer-torch-encoder-cu113:latest
```
or
```
docker://ghcr.io/freddyheppell/transformer-torch-encoder-cu113:latest-gpu
```

In production systems, it is advisable to request a specific version. For a list of available versions, [check the container registry page](https://github.com/freddyheppell/executor-text-transformers-torch-encoder/pkgs/container/transformer-torch-encoder-cu113).

### Set `volumes`

With the `volumes` attribute, you can map the cache directory to your local cache directory, in order to avoid downloading 
the model each time you start the Flow.

```python
from jina import Flow

flow = Flow().add(
    uses='jinahub+docker://TransformerTorchEncoderCU113',
    volumes='.cache/huggingface:/root/.cache/huggingface'
)
```

Alternatively, you can reference the docker image in the `yml` config and specify the `volumes` configuration.

`flow.yml`:

```yaml
jtype: Flow
executors:
  - name: encoder
    uses: 'jinahub+docker://TransformerTorchEncoderCU113'
    volumes: '.cache/huggingface:/root/.cache/huggingface'
```

And then use it like so:
```python
from jina import Flow

flow = Flow.load_config('flow.yml')
```


### Use other pre-trained models
You can specify the model to use with the parameter `pretrained_model_name_or_path`:
```python
from jina import Flow, Document

f = Flow().add(
    uses='jinahub+docker://TransformerTorchEncoderCU113',
    uses_with={'pretrained_model_name_or_path': 'bert-base-uncased'}
)

doc = Document(content='this is a sentence to be encoded')

with f:
    f.post(on='/foo', inputs=doc, on_done=lambda resp: print(resp.docs[0].embedding))
```

You can check the supported pre-trained models [here](https://huggingface.co/transformers/pretrained_models.html)

### Use GPUs
To enable GPU, you can set the `device` parameter to a cuda device.
Make sure your machine is cuda-compatible.
If you're using a docker container, make sure to add the `gpu` tag and enable 
GPU access to Docker with `gpus='all'`.
Furthermore, make sure you satisfy the prerequisites mentioned in 
[Executor on GPU tutorial](https://docs.jina.ai/tutorials/gpu_executor/#prerequisites).

```python

from jina import Flow, Document

f = Flow().add(
    uses='jinahub+docker://TransformerTorchEncoderCU113/gpu',
    uses_with={'device': 'cuda'}, gpus='all'
)

doc = Document(content='this is a sentence to be encoded')

with f:
    f.post(on='/foo', inputs=doc, on_done=lambda resp: print(resp.docs[0].embedding))
```

## Reference
- [Huggingface Transformers](https://huggingface.co/transformers/pretrained_models.html)

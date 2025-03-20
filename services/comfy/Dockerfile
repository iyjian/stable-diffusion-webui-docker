FROM alpine/git:2.36.2 as download

COPY clone.sh /clone.sh

RUN . /clone.sh ComfyUI-Manager https://github.com/ltdrdata/ComfyUI-Manager.git 68aa534e1dbe0244eb6c0a0b51824b6c959a2840


FROM pytorch/pytorch:2.3.0-cuda12.1-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

RUN apt-get update && apt-get install -y git curl && apt-get clean

ENV ROOT=/stable-diffusion
RUN --mount=type=cache,target=/root/.cache/pip \
  git clone https://github.com/comfyanonymous/ComfyUI.git ${ROOT} && \
  cd ${ROOT} && \
  git checkout master && \
  git reset --hard 9aac21f894a122ddb8d825c57ad61c0db5e630db && \
  pip install -r requirements.txt

RUN mkdir -p /data/.cache/huggingface/hub/ && \
  curl -o /data/.cache/huggingface/hub/cache.tar.gz https://pic.tiusolution.com/cache.tar.gz && \
  tar xvzf /data/.cache/huggingface/hub/cache.tar.gz -C /data/.cache/huggingface/hub && \
  rm /data/.cache/huggingface/hub/cache.tar.gz

COPY --from=download /repositories/ ${ROOT}/custom_nodes/

# RUN /docker/init.sh
  
WORKDIR ${ROOT}
COPY . /docker/
RUN chmod u+x /docker/entrypoint.sh && cp /docker/extra_model_paths.yaml ${ROOT}

ENV NVIDIA_VISIBLE_DEVICES=all PYTHONPATH="${PYTHONPATH}:${PWD}" CLI_ARGS=""
EXPOSE 7860
ENTRYPOINT ["/docker/entrypoint.sh"]
CMD python -u main.py --listen --port 7860 ${CLI_ARGS}

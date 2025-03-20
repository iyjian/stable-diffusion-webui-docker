#!/bin/bash
echo $ROOT
set -Eeuo pipefail

mkdir -vp /data/config/comfy/custom_nodes

declare -A MOUNTS

MOUNTS["/data/models"]="/mnt/models"
MOUNTS["/data/embeddings"]="/mnt/embeddings"
MOUNTS["/data/config/auto/extensions/sd-webui-controlnet/models"]="/mnt/controlnet/models"

MOUNTS["/root/.cache"]="/data/.cache"
MOUNTS["${ROOT}/input"]="/data/config/comfy/input"
MOUNTS["${ROOT}/output"]="/output/comfy"

for to_path in "${!MOUNTS[@]}"; do
  set -Eeuo pipefail
  from_path="${MOUNTS[${to_path}]}"
  rm -rf "${to_path}"
  if [ ! -f "$from_path" ]; then
    mkdir -vp "$from_path"
  fi
  mkdir -vp "$(dirname "${to_path}")"
  ln -sT "${from_path}" "${to_path}"
  echo Mounted $(basename "${from_path}")
done

if [ -f "/data/config/comfy/startup.sh" ]; then
  pushd ${ROOT}
  . /data/config/comfy/startup.sh
  popd
fi

echo -e "[default]\nnetwork_mode = offline" > /stable-diffusion/user/default/ComfyUI-Manager/config.ini

exec "$@"

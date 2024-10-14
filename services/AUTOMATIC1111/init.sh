#!/bin/bash
mkdir -p /data/config/auto/extensions
cd /data/config/auto/extensions
git clone https://github.com/Mikubill/sd-webui-controlnet.git
cd sd-webui-controlnet
git checkout a5457dcc1c952a400b84a2ab90eade47c0d7fed7
cd /data/config/auto/extensions
git clone https://github.com/w-e-w/sd-webui-nudenet-nsfw-censor.git
git clone https://github.com/iyjian/stable-diffusion-webui-localization-zh_CN.git
shopt -s nullglob
# For install.py, please refer to https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Developing-extensions#installpy
list=(./*/install.py)
for installscript in "${list[@]}"; do
  EXTNAME=$(echo $installscript | cut -d '/' -f 3)
  # Skip installing dependencies if extension is disabled in config
  if $(jq -e ".disabled_extensions|any(. == \"$EXTNAME\")" config.json); then
    echo "Skipping disabled extension ($EXTNAME)"
    continue
  fi
  PYTHONPATH=${ROOT} python "$installscript"
done

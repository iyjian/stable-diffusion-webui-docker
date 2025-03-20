#!/bin/bash
# python -c 'import main;main.apply_custom_paths()'
# python -c 'import main;main.execute_prestartup_script()'
cd /data/config/comfy/custom_nodes
list=(./*/requirements.txt)
for installscript in "${list[@]}"; do
  EXTNAME=$(echo $installscript | cut -d '/' -f 3)
  # Skip installing dependencies if extension is disabled in config
  PYTHONPATH=${ROOT} pip install -r "$installscript"
done


# mkdir -p /data/config/auto/extensions
# cd /data/config/auto/extensions
# git clone https://github.com/Mikubill/sd-webui-controlnet.git
# cd sd-webui-controlnet
# git checkout bb3c2a9bf7329c7d39e7b8b85a606cd5d567e57a
# rm -rf .git
# cd /data/config/auto/extensions
# git clone https://github.com/w-e-w/sd-webui-nudenet-nsfw-censor.git
# git clone https://github.com/iyjian/stable-diffusion-webui-localization-zh_CN.git
# shopt -s nullglob
# # For install.py, please refer to https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Developing-extensions#installpy
# list=(./*/install.py)
# for installscript in "${list[@]}"; do
#   EXTNAME=$(echo $installscript | cut -d '/' -f 3)
#   # Skip installing dependencies if extension is disabled in config
#   if $(jq -e ".disabled_extensions|any(. == \"$EXTNAME\")" config.json); then
#     echo "Skipping disabled extension ($EXTNAME)"
#     continue
#   fi
#   PYTHONPATH=${ROOT} python "$installscript"
# done
# pip install insightface
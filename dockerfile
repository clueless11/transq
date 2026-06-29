FROM pytorch/pytorch:2.8.0-cuda12.8-cudnn9-devel

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_NO_CACHE_DIR=1
ENV PYTHONUNBUFFERED=1
ENV HF_HOME=/workspace/.cache/huggingface
ENV TRANSFORMERS_CACHE=/workspace/.cache/huggingface
ENV HF_HUB_ENABLE_HF_TRANSFER=1

RUN apt-get update && apt-get install -y \
    git curl nano unzip rsync build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://rclone.org/install.sh | bash

# Make bootstrap available immediately when you enter the container
COPY bootstrap_restore.sh /workspace/transcribe/bootstrap_restore.sh
RUN chmod +x /workspace/transcribe/bootstrap_restore.sh

RUN python -m pip install --upgrade pip setuptools wheel

# Install general dependencies first
RUN python -m pip install --no-cache-dir \
    openai \
    python-docx \
    pillow \
    pandas \
    numpy \
    transformers==4.55.4 \
    "tokenizers>=0.21,<0.22" \
    datasets==4.0.0 \
    "accelerate>=1.3.0,<=1.11.0" \
    "peft>=0.18.0,<=0.18.1" \
    "trl>=0.18.0,<=0.24.0" \
    bitsandbytes \
    deepspeed \
    sentencepiece \
    protobuf \
    hf_transfer \
    safetensors \
    tiktoken \
    einops \
    scipy \
    scikit-learn \
    matplotlib \
    llamafactory

# Force known-good runtime versions LAST
RUN python -m pip install --no-cache-dir --force-reinstall \
    fastapi==0.136.3 \
    starlette==1.3.1 \
    prometheus-fastapi-instrumentator==8.0.2 \
    vllm==0.10.2

RUN mkdir -p /workspace/.cache/huggingface /workspace/transcribe

RUN echo "transq image v4 - cuda12.8 - known-good vllm stack - 2026-06-28" > /IMAGE_VERSION.txt

WORKDIR /workspace/transcribe

CMD ["tail", "-f", "/dev/null"]
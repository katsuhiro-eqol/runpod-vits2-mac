FROM pytorch/pytorch:2.1.2-cuda12.1-cudnn8-runtime
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ffmpeg \
    wget \
    curl \
    libsndfile1 \
    build-essential \
    pkg-config \
    libavformat-dev \
    libavcodec-dev \
    libavdevice-dev \
    libavutil-dev \
    libavfilter-dev \
    libswscale-dev \
    libswresample-dev \
    tzdata \
    && ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/litagin02/Style-Bert-VITS2.git /app/Style-Bert-VITS2

WORKDIR /app/Style-Bert-VITS2

COPY requirements.txt /app/requirements.extra.txt

RUN pip install --upgrade pip setuptools wheel
RUN pip install "Cython==0.29.36"
RUN pip install "numpy<2"

RUN echo "Cython<3" > /tmp/constraints.txt
ENV PIP_CONSTRAINT=/tmp/constraints.txt

RUN grep -v -E "^(torch|torchaudio|torchvision|xformers)" requirements.txt > /tmp/requirements.no_torch.txt \
    && cat /tmp/requirements.no_torch.txt \
    && pip install --no-cache-dir -r /tmp/requirements.no_torch.txt

RUN pip install -r /app/requirements.extra.txt

COPY rp_handler.py /app/rp_handler.py
COPY sbv2_client.py /app/sbv2_client.py
COPY start_server.py /app/start_server.py

ENV MODEL_ROOT=/runpod-volume/models
ENV SBV2_HOST=127.0.0.1
ENV SBV2_PORT=5000
ENV PYTHONUNBUFFERED=1

EXPOSE 5000

WORKDIR /app

CMD ["python", "-u", "rp_handler.py"]
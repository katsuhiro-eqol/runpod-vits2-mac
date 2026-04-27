FROM pytorch/pytorch:2.3.1-cuda12.1-cudnn8-runtime

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git \
    ffmpeg \
    wget \
    curl \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/litagin02/Style-Bert-VITS2.git /app/Style-Bert-VITS2

WORKDIR /app/Style-Bert-VITS2

COPY requirements.txt /app/requirements.extra.txt

RUN pip install --upgrade pip \
    && pip install -r requirements.txt \
    && pip install -r /app/requirements.extra.txt

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
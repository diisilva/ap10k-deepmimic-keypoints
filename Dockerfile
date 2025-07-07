# Use uma imagem-base com CUDA 11.7 + cuDNN 8
FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04

# --- 1. Instala dependências de sistema e Python3/pip ---
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      python3 python3-pip \
      build-essential \
      libglib2.0-0 libsm6 libxrender1 libxext6 \
      libcairo2 libpango1.0-0 \
      ffmpeg \
 && ln -sf /usr/bin/python3 /usr/bin/python \
 && ln -sf /usr/bin/pip3 /usr/bin/pip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# --- 2. Defina o diretório de trabalho ---
WORKDIR /usr/src/app

# --- 3. Atualiza pip e setuptools ---
RUN pip install --no-cache-dir --upgrade pip setuptools

# --- 4. Copie e instale as dependências Python ---
#    Ajuste o nome caso seu arquivo seja diferente
COPY requiriments_v2.txt ./
RUN pip install --no-cache-dir -r requiriments_v2.txt

# --- 5. Instale PyTorch com suporte CUDA 11.7 ---
RUN pip install --no-cache-dir \
      torch torchvision torchaudio \
      --index-url https://download.pytorch.org/whl/cu117

# --- 6. (Opcional) Tema para Jupyter via jupyterthemes ---
RUN pip install --no-cache-dir jupyterthemes \
 && jt -t chesterish -T -N -kl

# --- 7. Exponha porta e habilite Jupyter Lab ---
EXPOSE 8888
ENV JUPYTER_ENABLE_LAB=yes

# --- 8. Comando padrão ao iniciar o container ---
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]

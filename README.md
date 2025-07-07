# Classificação e Visualização de Keypoints com AP-10K e RESNET-18

Detecção de Esqueleto de Cães para DeepMimic
Problema: Extrair automaticamente poses (esqueletos) de cães em imagens usando IA.
Objetivo do projeto: Criar um modelo de visão computacional capaz de identificar pontos-chave (articulações) no corpo de cães.
Aplicação: Os esqueletos detectados serão usados como base de dados de movimentos caninos para o sistema DeepMimic (simulação física + RL) imitar esses movimentos.

## Conteúdo do repositório

- `docker-compose.yml` – define serviços Docker para ambiente de treino e inferência  
- `Dockerfile` – imagem base Ubuntu 22.04 com Python, PyTorch, dependências e suporte a GPU  
- `notebooks/` – exemplos de uso, pré-processamento, treino, avaliação e visualização  
- `requirements_v2.txt` – dependências Python  
- `README.md` – este arquivo

## Pré-requisitos

- **Máquina**: Ubuntu 22.04 LTS, AMD Ryzen 5 5600x 6-core × 12, 32 GiB RAM, NVIDIA RTX 3060 12 GB  
- **Docker Engine & Compose** instalado e funcionando  
- **NVIDIA Docker** (nvidia-container-toolkit) configurado para GPU passthrough

## Passo a Passo

### 1. Clonar o repositório  
```bash
git https://github.com/diisilva/ap10k-deepmimic-keypoints.git
cd ap10k-deepmimic-keypoints
```

### 2. Obter o dataset AP-10K  
O AP-10K é um benchmark para pose estimation animal com ~10 000 imagens e anotações COCO-style.  
```bash
Baixe o dataset e descompacte em notebooks/
 https://drive.google.com/drive/folders/1nea--zcXGSUDMiZQ5tcwwFbNQGpPg1cy?usp=sharing
```

### 3. Buildar e subir containers  
```bash
docker-compose build
docker-compose up -d
```

### 4. (APENAS SE QUISER CONFIGURAR O AMBIENTE FORA DO DOCKER) - Instalar dependências Python (alternativa fora de Docker)  
```bash
pip install -r requirements_v2.txt
```

### 5. Executar notebooks  
Abra o Jupyter em `http://localhost:8891`, (verificar senha em docker-compose.yml) depois navegue até `notebooks/` e execute:
1. **main.ipynb** – carregamento e pré-processamento  


## Visualização de Resultados

Funções para plotar keypoints Ground-Truth (verde) vs Preditos (vermelho/ciano) em múltiplas amostras.

## Arquitetura do Modelo

- **Backbone**: ResNet-18 pré-treinada (remove fc final)  
- **Head**: 2×Linear (512→512→17×3), ReLU, Dropout, Sigmoid  
- **Normalização**: Resize 256×256, Normalize(mean=[0.485,0.456,0.406], std=[0.229,0.224,0.225])  
- **Métrica**: MSELoss e PCK@0.05

## Docker

- **Dockerfile**: base Ubuntu 22.04, Python 3.10, PyTorch 2.x, CUDA, dependências  
- **docker-compose.yml**: define serviços `trainer`, `jupyter` e `visualizer`

## Developers

Diego Silva | 
FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

# Install Python and Jupyter
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    python3-dev \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3.10 as default
RUN ln -sf /usr/bin/python3.10 /usr/bin/python

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# Install Jupyter and core data science packages
RUN pip install --no-cache-dir \
    jupyter \
    jupyterlab \
    ipython \
    ipywidgets \
    pandas \
    numpy \
    scipy \
    scikit-learn \
    matplotlib \
    seaborn \
    psutil \
    memory-profiler

# Note: TensorFlow and PyTorch are optional heavy packages
# Scikit-learn will use CPU parallelization with n_jobs=-1
# GPU is available in the container runtime if needed

WORKDIR /workspace

# Expose port for Jupyter
EXPOSE 8888

# Create Jupyter config directory
RUN mkdir -p /root/.jupyter

# Run Jupyter Lab with GPU support and increased timeout settings
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--no-browser", \
     "--ServerApp.iopub_data_rate_limit=10000000"]

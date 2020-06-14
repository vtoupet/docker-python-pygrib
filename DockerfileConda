FROM continuumio/miniconda3:4.8.2

ENV PYTHONDONTWRITEBYTECODE=true

RUN conda install --yes --freeze-installed -c conda-forge \
    numpy==1.18.5 \
    pandas==1.0.4 \
    pygrib==2.0.4 \
    python-cdo==1.5.3 \
    && conda clean -afy \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.pyc' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete
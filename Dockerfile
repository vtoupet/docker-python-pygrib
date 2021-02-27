FROM vincejah/python-scientific:release-20210227 as builder

# https://confluence.ecmwf.int/display/ECC/Releases
ENV ECCODES_VERSION=2.20.0

RUN apt-get update && apt-get install -y \
        cmake \
        gcc \
        gfortran \
        g++ \
        build-essential \
        libgrib-api-dev \
        wget \
        git \
        libfreexl-dev \
        libjpeg-dev \
        libopenjp2-7-dev \
        libpng-dev \
        libxml2-dev \
        libpng-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*


RUN wget https://confluence.ecmwf.int/download/attachments/45757960/eccodes-$ECCODES_VERSION-Source.tar.gz \
    && tar -xzf  eccodes-$ECCODES_VERSION-Source.tar.gz \
    && mkdir build \
    && cd build \
    && cmake \
        -ENABLE_NETCDF=OFF \
        -ENABLE_JPG=ON \
        -ENABLE_PNG=OFF \
        -ENABLE_PYTHON=OFF \
        -ENABLE_FORTRAN=OFF \
        ../eccodes-$ECCODES_VERSION-Source \
    && make -j"$(nproc)"\
    && ctest \
    && make install

COPY ./setup.cfg /setup.cfg

RUN pip install pyproj numpy

RUN git clone https://github.com/jswhit/pygrib.git  \
    && cd pygrib \
    && mv /setup.cfg . \
    && git checkout dbe46fb2b2a833c59dfc91cf49e4703ffa45447d \
    && python setup.py build \
    && python setup.py install \
    && python test.py

FROM vincejah/python-scientific:latest as final

COPY --from=builder /usr/local/ /usr/local/
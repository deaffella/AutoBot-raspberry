FROM python:3.9.18-slim-bullseye
MAINTAINER Letenkov Maksim <letenkovmaksim@yandex.ru>

RUN apt update && \
    apt install -y \
        nano git wget curl dos2unix htop  \
        libsm6 libxext6 \
    && \
    apt autoremove -y && \
    apt autoclean && \
    apt clean
RUN python3 -m pip install --upgrade pip && \
    pip3 install --no-cache-dir \
        virtualenv \
        opencv-contrib-python==4.5.5.62 \
        tqdm==4.66.1


RUN cd /opt && \
    git clone https://github.com/autorope/donkeycar && \
    cd donkeycar && \
    git checkout 4.5.0

COPY donkeycar.setup.py /opt/donkeycar/setup.py
RUN cd /opt/donkeycar && \
    pip3 install -e .[pi]


RUN ln -sf /proc/1/fd/1 /var/log/test.log
CMD ["bash"]

FROM ubuntu:22.04
 
ENV DEBIAN_FRONTEND noninteractive
 
WORKDIR /root
 
RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential locales tzdata \
    python3 python3.10-dev python3-pip python3-wheel pipx \
    vim git curl jq \
    mysql-client
 
RUN pipx ensurepath
 
RUN locale-gen ja_JP.UTF-8
 
ENV LANG ja_JP.UTF-8
ENV TZ Asia/Tokyo
ENV PATH="${PATH}:/root/.local/bin"
 
RUN ln -s /usr/bin/python3.10 /usr/bin/python
 
RUN pip install -U pip setuptools wheel
 
RUN pipx install poetry
 
WORKDIR /usr/src/
 
RUN mkdir -p /usr/src/app
COPY . /usr/src/app
 
WORKDIR /usr/src/app
RUN poetry install -C jdsf_data/
 
COPY docker-entrypoint.sh /
RUN chown root:root /docker-entrypoint.sh && chmod 700 /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
 
CMD ["bash"]

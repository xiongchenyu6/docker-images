FROM postgres:latest

LABEL auther="freemanX"

RUN apt upgrade \
    && apt update \
    && apt install -y git build-essential postgresql-server-dev-all sudo

RUN git clone --depth 1 https://github.com/michaelpq/pg_plugins.git

WORKDIR /pg_plugins/decoder_raw

RUN make \
    && make install

RUN localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8
ENV LANG zh_CN.utf8

EXPOSE 5432

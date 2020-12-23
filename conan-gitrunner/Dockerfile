FROM ubuntu:16.04

ENV CONAN_USER_HOME=~
ARG llvmver=8

ADD llvm.list /
ADD llvm-snapshot.gpg.key /
ADD entrypoint /

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8611B7A28669BB93 && \
    apt update && \ 
    apt install -y software-properties-common gnupg apt-transport-https ca-certificates && \
    apt-add-repository 'deb http://apt.kitware.com/ubuntu/ xenial main' && \
    apt-get upgrade -y && \
    # Install pre-reqs
    mv llvm.list /etc/apt/sources.list.d/ && \
    apt-key add llvm-snapshot.gpg.key && \
    rm llvm-snapshot.gpg.key  && \
    apt-get update  &&\
    apt-get install -y \
    build-essential \
    #Install Tool
    clang-$llvmver \
    clang-tools-$llvmver \
    clang-format-$llvmver \
    python-clang-$llvmver \
    libfuzzer-$llvmver-dev \
    lldb-$llvmver \
    lld-$llvmver \
    libc++-$llvmver-dev \
    libc++abi-$llvmver-dev \
    libomp-$llvmver-dev \
    wget \ 
    python3 \ 
    python3-pip \ 
    curl\ 
    git\ 
    cmake && \
    pip3 install conan && \
    chmod +x /entrypoint && \
    update-alternatives --install /usr/bin/cc cc /usr/bin/clang-8 100 && \
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-8 100 &&\
    mkdir -p ~/.conan/profiles/

ADD default ~/.conan/profiles/default

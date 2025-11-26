FROM ubuntu:22.04

ENV CONAN_USER_HOME=~
ARG llvmver=17

ADD llvm.list /
ADD llvm-snapshot.gpg.key /
ADD entrypoint /

RUN apt update && \
    apt install -y software-properties-common gnupg apt-transport-https ca-certificates wget && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    apt-add-repository 'deb https://apt.kitware.com/ubuntu/ jammy main' && \
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
    update-alternatives --install /usr/bin/cc cc /usr/bin/clang-$llvmver 100 && \
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-$llvmver 100 &&\
    mkdir -p ~/.conan/profiles/

ADD default ~/.conan/profiles/default

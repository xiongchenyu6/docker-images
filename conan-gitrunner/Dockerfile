FROM ubuntu:bionic

ENV CONAN_USER_HOME=~
ARG llvmver=8

ADD llvm.list /
ADD llvm-snapshot.gpg.key /
ADD https://github.com/Yelp/dumb-init/releases/download/v1.0.2/dumb-init_1.0.2_amd64 /usr/bin/dumb-init
ADD entrypoint /
ADD default ~/.conan/profiles/default

# Pre-Req Repos
RUN chmod +x /usr/bin/dumb-init && \ 
 apt update && \ 
 apt install -y software-properties-common gnupg && \
 apt-get upgrade -y && \
# Install pre-reqs
 mv llvm.list /etc/apt/sources.list.d/ && \
 apt-key add llvm-snapshot.gpg.key && \
 rm llvm-snapshot.gpg.key  && \
 apt-get update  &&\
 apt-get install -y \
  ca-certificates \
  build-essential \
# Install Tool
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
  ca-certificates \
  wget \ 
  python3 \ 
  python3-pip \ 
  curl\ 
  git\ 
  cmake\
  apt-transport-https && \
 echo "deb https://packages.gitlab.com/runner/gitlab-ci-multi-runner/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/runner_gitlab-ci-multi-runner.list && \
 wget -q -O - https://packages.gitlab.com/gpg.key | apt-key add - && \
 apt-get update -y && \
 apt-get install -y gitlab-ci-multi-runner && \
 apt-get clean && \
 mkdir -p /etc/gitlab-runner/certs && \
 chmod -R 700 /etc/gitlab-runner && \
 rm -rf /var/lib/apt/lists/* && \
 pip3 install conan && \
 chmod +x /entrypoint && \
 update-alternatives --install /usr/bin/cc cc /usr/bin/clang-8 100 && \
 update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-8 100

VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]

FROM ubuntu:20.04
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y \
       git curl wget software-properties-common locales make build-essential libssl-dev \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && mkdir -p "/usr/local/cmake" \
    && wget -qO- "https://github.com/Kitware/CMake/releases/download/v3.24.2/cmake-3.24.2.tar.gz" | tar --strip-components=1 -xz -C "/usr/local/cmake" \
    && cd "/usr/local/cmake"; ./bootstrap; make -j; make install; cd - \
    && curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage \
    && chmod u+x nvim.appimage \
    && ./nvim.appimage --appimage-extract \
    && ln -s /squashfs-root/AppRun /usr/bin/nvim \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt update \
    && apt install -y python3 python3-pip \
    && pip install pynvim \
    && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt install -y nodejs \
    && npm install -g neovim \
    && curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb \
    && dpkg -i ripgrep_13.0.0_amd64.deb
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

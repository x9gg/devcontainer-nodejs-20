ARG VARIANT=20-bookworm-slim
FROM node:${VARIANT}

ARG USERNAME=node
ARG NPM_GLOBAL=/usr/local/share/npm-global

# Add NPM global to PATH.
ENV PATH=${NPM_GLOBAL}/bin:${PATH}
RUN \
    # Configure global npm install location, use group to adapt to UID/GID changes
    if ! cat /etc/group | grep -e "^npm:" > /dev/null 2>&1; then groupadd -r npm; fi \
    && usermod -a -G npm ${USERNAME} \
    && umask 0002 \
    && mkdir -p ${NPM_GLOBAL} \
    && touch /usr/local/etc/npmrc \
    && chown ${USERNAME}:npm ${NPM_GLOBAL} /usr/local/etc/npmrc \
    && chmod g+s ${NPM_GLOBAL} \
    && npm config -g set prefix ${NPM_GLOBAL} \
    && su ${USERNAME} -c "npm config -g set prefix ${NPM_GLOBAL}" \
    # Install eslint
    && su ${USERNAME} -c "umask 0002 && npm install -g eslint" \
    && npm cache clean --force > /dev/null 2>&1

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    apt-utils \
    git \
    zsh \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    sudo \
    iputils-ping \
    whois \
    dnsutils \
    openssh-client \
    gnupg \
    curl \
    wget \
    procps \
    jq \
    vim \
    nano \
    traceroute \
    net-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create dev user with sudo privileges (no password)
RUN useradd -m -s /usr/bin/zsh -G sudo dev && \
    echo "dev ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev

RUN mkdir -p /home/dev && chown -R dev:dev /home/dev
RUN mkdir -p /home/dev/scripts && chown -R dev:dev /home/dev/scripts

# Set up .zshrc for both root and dev user
COPY .zshrc /root/.zshrc
COPY .zshrc /home/dev/.zshrc
COPY scripts/git-set-config.sh /home/dev/scripts/git-set-config.sh

# Fix permissions
RUN chown dev:dev /home/dev/.zshrc
RUN chown dev:dev /home/dev/scripts/git-set-config.sh

# Set zsh as default shell for root
RUN chsh -s /usr/bin/zsh

USER dev
WORKDIR /home/dev

CMD ["zsh"]
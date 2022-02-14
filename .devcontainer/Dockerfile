ARG VARIANT=3
FROM mcr.microsoft.com/vscode/devcontainers/ruby:0-${VARIANT}

ARG USERNAME=vscode

RUN gem update --system && \
    gem install bundler -v 2.3.5 && \
    gem cleanup bundler

ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev"

ARG NODE_VERSION="lts/*"
RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends libcurl4-openssl-dev neovim python3-pip tmux

RUN curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/pgdg-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/pgdg-keyring.gpg] http://apt.postgresql.org/pub/repos/apt bullseye-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update \
    && apt-get install -y postgresql-client-14 libpq-dev

RUN curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb bullseye main" > /etc/apt/sources.list.d/redis.list > /dev/null \
    && apt-get update \
    && apt-get install -y redis-tools

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install -y gh

RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable

RUN /bin/bash -c 'set -ex && \
    ARCH=`uname -m` && \
    if [ "$ARCH" == "x86_64" ]; then \
      curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
    elif [ "$ARCH" == "aarch64" ]; then \
      curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"; \
    fi' \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf ./aws \
    && mkdir /home/$USERNAME/.aws \
    && chmod -R 0700 /home/$USERNAME/.aws \
    && chown -R $USERNAME /home/$USERNAME/.aws

RUN gem install foreman solargraph

RUN BASH_SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && ZSH_SNIPPET="export HISTFILE=/commandhistory/.zsh_history" \
    && mkdir /commandhistory \
    && touch /commandhistory/.bash_history \
    && touch /commandhistory/.zsh_history \
    && touch /commandhistory/.irb_history \
    && chown -R $USERNAME /commandhistory \
    && echo $BASH_SNIPPET >> "/home/$USERNAME/.bashrc" \
    && echo $ZSH_SNIPPET >> "/home/$USERNAME/.zshrc" \

RUN GPG_AGENT_SNIPPET='export GPG_AGENT_INFO=/home/$USERNAME/.gnupg/S.gpg-agent:0:1' GPG_TTY_SNIPPET='export GPG_TTY=$(tty)' \
    && mkdir /home/$USERNAME/.gnupg \
    && chmod -R 0700 /home/$USERNAME/.gnupg \
    && chown -R $USERNAME /home/$USERNAME/.gnupg \
    && echo $GPG_AGENT_SNIPPET >> "/home/$USERNAME/.bashrc" \
    && echo $GPG_TTY_SNIPPET >> "/home/$USERNAME/.bashrc" \
    && echo $GPG_AGENT_SNIPPET >> "/home/$USERNAME/.zshrc" \
    && echo $GPG_TTY_SNIPPET >> "/home/$USERNAME/.zshrc"

RUN SNIPPET='eval $(ssh-agent)' \
    && mkdir /home/$USERNAME/.ssh \
    && chmod -R 0700 /home/$USERNAME/.ssh \
    && chown -R $USERNAME /home/$USERNAME/.ssh \
    && echo $SNIPPET >> "/home/$USERNAME/.bashrc" \
    && echo $SNIPPET >> "/home/$USERNAME/.zshrc"

RUN BASH_SNIPPET='[[ $(ls -A /dotfiles/bashrc.d) ]] && for f in /dotfiles/bashrc.d/*.bash; do source $f; done' \
    && ZSH_SNIPPET='[[ $(ls -A /dotfiles/zshrc.d) ]] && for f in /dotfiles/zshrc.d/*.zsh; do source $f; done' \
    && GITCONFIG="[include]\n  path = /dotfiles/gitconfig" \
    && TMUXCONF="source /dotfiles/tmux.conf" \
    && mkdir /dotfiles \
    && mkdir /dotfiles/bashrc.d \
    && mkdir /dotfiles/zshrc.d \
    && touch /dotfiles/gitconfig \
    && touch /dotfiles/tmux.conf \
    && chown -R $USERNAME /dotfiles \
    && echo $BASH_SNIPPET >> "/home/$USERNAME/.bashrc" \
    && echo $ZSH_SNIPPET >> "/home/$USERNAME/.zshrc" \
    && echo $GITCONFIG >> "/home/$USERNAME/.gitconfig" \
    && echo $TMUXCONF >> "/home/$USERNAME/.tmux.conf" \

RUN SNIPPET='export EDITOR=nvim' \
    && mkdir -p /home/$USERNAME/.config/nvim \
    && touch /home/$USERNAME/.config/nvim/init.vim \
    && chown -R $USERNAME /home/$USERNAME/.config \
    && echo $SNIPPET >> "/home/$USERNAME/.bashrc" \
    && echo $SNIPPET >> "/home/$USERNAME/.zshrc"

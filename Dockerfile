FROM ubuntu:latest

SHELL ["/bin/bash", "--login", "-c"]

RUN apt update && apt install -y git wget curl sudo rsync locales

# Locale is set in .bash_profile; needs to be created
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8

# From now on, use login shell so that bashrc gets sourced
ENV SHELL /bin/bash

ADD . dotfiles
WORKDIR dotfiles
RUN git checkout $BRANCH

# Run setup in order

ENV DOTFILES_FORCE=true
RUN ./setup.sh --apt-get-installs-minimal
RUN ./setup.sh --install-miniconda
RUN ./setup.sh --dotfiles
RUN ./setup.sh --set-up-bioconda
RUN ./setup.sh --install-neovim
RUN ./setup.sh --set-up-vim-plugins

RUN echo $HOME
RUN source $HOME/.aliases

# Don't know why yet, but the alias isn't sticking. But this installs plugins
# without interaction
RUN nvim +PlugInstall +qall

# Various installations using ./setup.sh
RUN ./setup.sh --install-bat
RUN ./setup.sh --install-black
RUN ./setup.sh --install-fzf
RUN ./setup.sh --install-git-cola
RUN ./setup.sh --install-hub
RUN ./setup.sh --install-icdiff
RUN ./setup.sh --install-jq
RUN ./setup.sh --install-radian
RUN ./setup.sh --install-ripgrep
RUN ./setup.sh --install-vd

# Additional for this container: asciinema for screen casts
RUN pip install asciinema
RUN conda install r-base
RUN conda install ipython

ENTRYPOINT ["/bin/bash"]
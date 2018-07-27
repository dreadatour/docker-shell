FROM alpine:3.8
MAINTAINER Vlad Rudnyh

ENV TERM xterm-256color
ENV LC_ALL en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_COLLATE=C

RUN apk update && apk upgrade && apk add \
	coreutils \
	findutils \
	grep \
	man \
	man-pages \
	less \
	less-doc \
	sudo \
	make \
	g++ \
	zsh \
	curl \
	wget \
	net-tools \
	tmux \
	git \
	python \
	python-dev \
	py2-pip \
	python3 \
	python3-dev \
	go \
	neovim

RUN pip2 install --upgrade pip && pip2 install neovim
RUN pip3 install --upgrade pip && pip3 install neovim

RUN ln -s /bin/grep /usr/bin/grep
RUN ln -s /usr/bin/nvim /usr/bin/vim

RUN rm -rf /var/cache/apk/*

RUN echo "unicode=\"YES\"" >> /etc/rc.conf

ADD wrapper /usr/local/bin/
RUN chmod +x /usr/local/bin/wrapper

RUN adduser -h /home/rudnyh -s /bin/zsh -G root -D rudnyh; \
	echo "rudnyh ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/rudnyh; \
    chmod 0440 /etc/sudoers.d/rudnyh
WORKDIR /home/rudnyh
USER rudnyh

RUN sh -c "`curl -fsSL https://raw.githubusercontent.com/dreadatour/dotfiles/install/install.sh`"
#RUN nvim +PlugInstall +qall

CMD ["/usr/local/bin/wrapper"]


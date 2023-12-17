FROM kong:3.5

USER root
RUN luarocks install lua-resty-openidc
FROM debian:sid-slim

RUN apt-get update && apt-get install -y socat make gcc libc6-dev

RUN useradd --home=/challenge interiut

RUN mkdir build

ADD ./src /build

RUN cd /build && make

WORKDIR /challenge

RUN mv /build/mini_chall.out "./ENSIBS{tr0_f4c1l3_l35_f0rm4t_5tring5}"

RUN rm -rf /build

ADD entrypoint.sh /

EXPOSE 1338

CMD ["/entrypoint.sh"]

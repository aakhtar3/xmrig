ARG ALPINE_VERSION=3.19
ARG ARCH=arm64v8
FROM ${ARCH}/alpine:${ALPINE_VERSION} as builder

ARG XMRIG_VERSION=v6.21.3

WORKDIR /xmrig
RUN apk add git make cmake libstdc++ gcc g++ automake libtool autoconf linux-headers gcc musl-dev
RUN git clone -b ${XMRIG_VERSION} --single-branch --depth 1 https://github.com/xmrig/xmrig ./ && \
    sed -i 's/kDefaultDonateLevel = 1;/kDefaultDonateLevel = 0;/g' ./src/donate.h && \
    sed -i 's/kMinimumDonateLevel = 1;/kMinimumDonateLevel = 0;/g' ./src/donate.h && \
    mkdir build && cd scripts && ./build_deps.sh && cd ../build && \
    cmake .. -DXMRIG_DEPS=scripts/deps -DBUILD_STATIC=ON && make -j$(nproc)

FROM ${ARCH}/alpine:${ALPINE_VERSION}
COPY --from=builder /xmrig/build/xmrig /bin/

RUN mkdir -p /root/
COPY ./config.json /root/.xmrig.json
COPY ./entrypoint.sh /entrypoint.sh

CMD [ "./entrypoint.sh" ]
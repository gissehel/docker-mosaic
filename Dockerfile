FROM alpine AS builder

RUN apk update && apk add git make gcc libxt-dev libc-dev motif-dev motif libxmu-dev libjpeg-turbo-dev libpng-dev
RUN mkdir -p /app && cd /app && git clone https://github.com/rehaby/ncsa-mosaic && cd /app/ncsa-mosaic && make linux

FROM alpine

RUN apk update && apk add motif libjpeg libxmu && adduser x -g "" -D
COPY --from=builder /app/ncsa-mosaic/src/Mosaic /Mosaic

USER x
CMD [ "/Mosaic" ]

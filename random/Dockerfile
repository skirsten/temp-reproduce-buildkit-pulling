# syntax=docker/dockerfile:1.4
FROM alpine as builder

RUN dd if=/dev/urandom bs=1M count=1000 of=/random.bin

FROM scratch
COPY --from=builder /random.bin /random.bin

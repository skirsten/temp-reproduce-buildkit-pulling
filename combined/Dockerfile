# syntax=docker/dockerfile:1.4
ARG base_image
ARG append_image

FROM ${append_image} as append-image

FROM ${base_image}

COPY --link --from=append-image / /

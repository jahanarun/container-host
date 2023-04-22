FROM cloudflare/cloudflared AS source

FROM alpine

ARG user=nonroot
ARG home=/home/$user
RUN addgroup -S nonroot
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home $home \
    --ingroup nonroot \
    $user

COPY --from=source --chown=nonroot /usr/local/bin/cloudflared /usr/local/bin/
RUN apk update && apk add --no-cache curl bind-tools

USER nonroot

ENTRYPOINT ["cloudflared", "--no-autoupdate"]

CMD ["version"]

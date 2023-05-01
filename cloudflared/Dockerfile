FROM cloudflare/cloudflared AS source

FROM alpine

ARG user=nonroot
ARG home=/home/$user
RUN addgroup -S $user
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home $home \
    --ingroup $user \
    $user

COPY --from=source --chown=$user /usr/local/bin/cloudflared /usr/local/bin/
RUN apk update && apk add --no-cache curl bind-tools

USER $user

ENTRYPOINT ["cloudflared", "--no-autoupdate"]

CMD ["version"]

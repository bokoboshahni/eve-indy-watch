FROM bokoboshahni/eve-rails-builder:edge AS builder
FROM bokoboshahni/eve-rails-base:edge

LABEL maintainer="shahni@bokobo.space"

COPY --from=builder /etc/alpine-release /tmp/dummy

USER app

CMD ["bundle", "exec", "rails", "console"]

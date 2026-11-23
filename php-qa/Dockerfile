ARG PHPVS
FROM curatorium/php-${PHPVS}:base

ARG PHPVS
ENV PHPVS=${PHPVS}
ENV ENABLED_SERVICES=""

COPY files /
COPY mods-available/ /etc/php/${PHPVS}/mods-available/
COPY Stewardfile /tmp/Stewardfile
# Anonymous composer dist downloads from api.github.com get HTTP 504; the token is a build secret, never a layer.
RUN --mount=type=secret,id=github_token,env=GITHUB_TOKEN \
    if [ -n "${GITHUB_TOKEN:-}" ]; then export COMPOSER_AUTH="{\"github-oauth\":{\"github.com\":\"$GITHUB_TOKEN\"}}"; fi; \
    steward /tmp/Stewardfile && clean-tmp

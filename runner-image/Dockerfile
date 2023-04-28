FROM summerwind/actions-runner:latest
ARG RUNNER_CONTAINER_HOOKS_VERSION=0.3.1
ENV RUNNER_ASSETS_DIR=/runnertmp
USER root
RUN cd "$RUNNER_ASSETS_DIR" \
    && rm -rf k8s \
    && curl -fLo runner-container-hooks.zip https://github.com/actions/runner-container-hooks/releases/download/v${RUNNER_CONTAINER_HOOKS_VERSION}/actions-runner-hooks-k8s-${RUNNER_CONTAINER_HOOKS_VERSION}.zip \
    && unzip ./runner-container-hooks.zip -d ./k8s \
    && rm -f runner-container-hooks.zip
USER runner

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["entrypoint.sh"]
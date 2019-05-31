FROM python:3.7-slim@sha256:589527a734f2a9e48b23cc4687848cb9503d0f8569fad68c3ad8b2ee9d1c50ff

ENV AWSCLI_VERSION='1.16.76'
RUN pip install -q --no-cache-dir "awscli==${AWSCLI_VERSION}"

ENV TERRAFORM_VERSION='0.12.0' \
	TERRAFORM_SHA256SUM=42ffd2db97853d5249621d071f4babeed8f5fdba40e3685e6c1013b9b7b25830 \
	TF_IN_AUTOMATION=true \
	TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache" \
	SENTRY_TPP_VERSION='0.4.0'

RUN apt-get update && apt-get install --no-install-recommends -y \
		curl \
		git \
		unzip \
		zip \
	&& curl -sSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
	&& echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS \
	&& sha256sum -c --status terraform_${TERRAFORM_VERSION}_SHA256SUMS \
	&& unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin \
	&& rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
	&& curl -sSL https://github.com/jianyuan/terraform-provider-sentry/releases/download/v${SENTRY_TPP_VERSION}/terraform-provider-sentry_${SENTRY_TPP_VERSION}_linux_amd64.tar.gz > terraform-provider-sentry_${SENTRY_TPP_VERSION}_linux_amd64.tar.gz \
	&& mkdir -p $HOME/.terraform.d/plugins/linux_amd64 \
	&& tar -zxf terraform-provider-sentry_${SENTRY_TPP_VERSION}_linux_amd64.tar.gz -C $HOME/.terraform.d/plugins/linux_amd64 \
	&& rm -f terraform-provider-sentry_${SENTRY_TPP_VERSION}_linux_amd64.tar.gz \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& apt-get autoremove --purge -y \
		curl \
		unzip

CMD ["/bin/terraform", "help"]

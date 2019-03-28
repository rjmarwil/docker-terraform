FROM python:3.7-slim@sha256:3e4be41076ebb6fe8c3112b220ce133ef0dc49c814024e4874ca76eae3c8dec0

ENV AWSCLI_VERSION='1.16.76'
RUN pip install -q --no-cache-dir "awscli==${AWSCLI_VERSION}"

ENV TERRAFORM_VERSION='0.11.13' \
	TERRAFORM_SHA256SUM=5925cd4d81e7d8f42a0054df2aafd66e2ab7408dbed2bd748f0022cfe592f8d2 \
	TF_IN_AUTOMATION=true \
	TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

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
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& apt-get autoremove --purge -y \
		curl \
		unzip

CMD ["/bin/terraform", "help"]

FROM python:3.7-slim@sha256:baf4188f0b50c6383fedd55cdb79f511bfabee23068dcf26f209426f4bf540ab

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN pip install -q --no-cache-dir -r requirements.txt

ENV TERRAFORM_VERSION='0.12.2' \
	TERRAFORM_SHA256SUM=d9a96b646420d7f0a80aa5d51bb7b2a125acead537ab13c635f76668de9b8e32 \
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

FROM python:3.7-slim@sha256:d1a2d81693a34a892ef5ea039e2579f0670979dbf84ada597fde95aae461bc2f

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN pip install -q --no-cache-dir -r requirements.txt

ENV TERRAFORM_VERSION='0.12.3' \
	TERRAFORM_SHA256SUM=75e4323b8514074f8c2118ea382fc677c8b1d1730eda323ada222e0fac57f7db \
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

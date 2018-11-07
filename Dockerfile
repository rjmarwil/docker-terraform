FROM python:3.7-alpine

RUN apk add --no-cache tini

ENTRYPOINT ["/sbin/tini", "--"]

ENV AWSCLI_VERSION='1.16.48'
RUN pip install -q --no-cache-dir "awscli==${AWSCLI_VERSION}"

ENV TERRAFORM_VERSION='0.11.10' \
	TERRAFORM_SHA256SUM=43543a0e56e31b0952ea3623521917e060f2718ab06fe2b2d506cfaa14d54527

RUN apk add --no-cache --virtual .build-deps \
		curl \
		openssh \
	&& curl -sSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
	&& echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS \
	&& sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS \
	&& unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin \
	&& rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
	&& apk del .build-deps

ENV TF_IN_AUTOMATION=true \
	TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

COPY terraform /terraform

CMD ["/bin/terraform", "help"]

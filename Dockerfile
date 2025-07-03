ARG TERRAFORM_VERSION=1.8.5

FROM public.ecr.aws/hashicorp/terraform:${TERRAFORM_VERSION}

RUN apk add --no-cache bash 

ENV ENVIRONMENT_NAME=
ENV S3_BACKEND_BUCKET=
ENV S3_BACKEND_KEY=
ENV S3_BACKEND_REGION=
ENV TARGET_REGION=
ENV DOWNLOAD_MODULES=false
ENV TERRAFORM_COMMAND=

COPY . /innovation

WORKDIR /innovation

RUN terraform init -backend=false 

ENTRYPOINT ["./utils/tf.sh"]
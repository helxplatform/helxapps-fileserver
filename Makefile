## BRANCH_TAG: Tag of Helx-Apps embedded in the app
EMBEDDED_BRANCH := ordrd

build:
	docker buildx build \
	--platform=linux/amd64 \
	--build-arg=BUILD_REF=$(EMBEDDED_BRANCH) \
	--build-arg BUILD_DATE=`date -u + "%Y-%m-%dT%H:%M:%SZ"` \
	--tag=containers.renci.org/helxplatform/third-party/helxappsfs:latest \
	.
IMAGE_NAME = debian-scala-build

.PHONY: all clean help

help: ## Display this help page
	@echo "Welcome to the Debian Scala container!"
	@printf "\n\033[32mEnvironment Variables\033[0m\n"
	@cat $(MAKEFILE_LIST) | egrep -o "\\$$\{[a-zA-Z0-9_]*\}" | sort | uniq | \
		sed -E 's/^[\$$\{]*|\}$$//g' | xargs -I % echo % % | \
		xargs printf "echo \"\033[93m%-30s\033[0m \$$(printenv %s)\n\"" | bash | sed "s/echo //"
	@printf "\n\033[32mMake Targets\033[0m\n"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

build: ## Build the container
	@echo "--- :wind_chime: Building :wind_chime:"
	docker build --pull --no-cache -t redbubble/${IMAGE_NAME}:latest .

tag: ## Tag the container with its Git branch and Buildkite build number
	@echo "--- :label: Tagging image :label:"
	docker tag -f redbubble/${IMAGE_NAME}:latest redbubble/${IMAGE_NAME}:${BUILDKITE_BRANCH}
	docker tag -f redbubble/${IMAGE_NAME}:latest redbubble/${IMAGE_NAME}:${BUILDKITE_BUILD_NUMBER}

push: ## Push the tagged image to Docker Hub
	@echo "--- :satellite: Pushing to docker registry :satellite:"
	docker push redbubble/${IMAGE_NAME}:${BUILDKITE_BUILD_NUMBER}
	docker push redbubble/${IMAGE_NAME}:${BUILDKITE_BRANCH}
	docker push redbubble/${IMAGE_NAME}:latest

clean: ## Clean up images
	@echo "--- :shower: Cleaning up :shower:"
	-docker rmi redbubble/${IMAGE_NAME}:latest
	-docker rmi redbubble/${IMAGE_NAME}:${BUILDKITE_BRANCH}
	-docker rmi redbubble/${IMAGE_NAME}:${BUILDKITE_BUILD_NUMBER}
	-docker rmi $(docker images -f "dangling=true" -q)

all: build tag push

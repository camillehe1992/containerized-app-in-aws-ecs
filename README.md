# Build a Strapi Project and Deploy to AWS ECS

See [README_TF](README_TF.md) for the detail description about Terraform structure.

## 🚀 Getting started with Strapi

Strapi comes with a full featured [Command Line Interface](https://docs.strapi.io/dev-docs/cli) (CLI) which lets you scaffold and manage your project in seconds.

### `develop`

Start your Strapi application with autoReload enabled. [Learn more](https://docs.strapi.io/dev-docs/cli#strapi-develop)

```bash
npm run develop
# or
yarn develop
```

### `start`

Start your Strapi application with autoReload disabled. [Learn more](https://docs.strapi.io/dev-docs/cli#strapi-start)

```bash
npm run start
# or
yarn start
```

### `build`

Build your admin panel. [Learn more](https://docs.strapi.io/dev-docs/cli#strapi-build)

```bash
npm run build
# or
yarn build
```

## Build & Publish Docker Image

### `docker build`

Build the docker image from local.

```bash
docker build \
  --build-arg NODE_ENV=development \
  -t strapi \
  -f Dockerfile.dev .
```

### `docker run`

Test the docker image by creating a container, and run it from local.

```bash
docker run --name my-strapi --rm -it --env-file=.env -p 1337:1337 strapi
```

Access container via `http://localhost:1337`

### `docker push`

```bash
docker login
# Build docker image for muliple OS
# create a custom buildx
docker buildx create --name multi-arch --platform "linux/arm64,linux/amd64"
docker buildx build --platform linux/arm64,linux/amd64 --builder multi-arch -f Dockerfile.prod -t camillehe1992/strapi:latest --push .

# Or
docker image tag strapi camillehe1992/strapi:latest
docker image push camillehe1992/strapi:latest
```

## ⚙️ Deployment

Deploy Terraform AWS resources into AWS Account using Github Actions workflows.

### 1. Build & Publish

The `build-and-publish.yaml` workflow is used to build Docker image for Strapi application and publish to Docker Hub repository. You can trigger the workflow manually from Github Actions -> `Build and Publish Docker Image` workflow.

See the details of workflow from the YAML file.

### 2. Terraform Plan & Apply

The `tf-plan-apply.yaml` workflow is used to deploy all Terraform resources into AWS account. You can trigger the workflow manually from Github Actions -> `Terraform Plan/Apply` workflow.

### 3. Terraform Plan Destroy & Apply

The `tf-plan-destroy-apply.yaml` workflow is used to destroy all Terraform resources from AWS account. You can trigger the workflow manually from Github Actions -> `Terraform Plan Destroy/Apply` workflow.

## 📚 Learn more

- [Resource center](https://strapi.io/resource-center) - Strapi resource center.
- [Strapi documentation](https://docs.strapi.io) - Official Strapi documentation.
- [Strapi tutorials](https://strapi.io/tutorials) - List of tutorials made by the core team and the community.
- [Strapi blog](https://strapi.io/blog) - Official Strapi blog containing articles made by the Strapi team and the community.
- [Changelog](https://strapi.io/changelog) - Find out about the Strapi product updates, new features and general improvements.

Feel free to check out the [Strapi GitHub repository](https://github.com/strapi/strapi). Your feedback and contributions are welcome!

## ✨ Community

- [Discord](https://discord.strapi.io) - Come chat with the Strapi community including the core team.
- [Forum](https://forum.strapi.io/) - Place to discuss, ask questions and find answers, show your Strapi project and get feedback or just talk with other Community members.
- [Awesome Strapi](https://github.com/strapi/awesome-strapi) - A curated list of awesome things related to Strapi.

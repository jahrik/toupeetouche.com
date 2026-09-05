image := "jahrik/toupee_touche"
tag := `uname -m`
stack := "tt"

# Install npm dependencies via a throwaway node container
[group('build')]
npm:
    docker run --rm -v {{ justfile_directory() }}/v2:/v2 -w /v2 --user "$(id -u):$(id -g)" node npm install

# Build the image locally (uses Dockerfile_<arch> for the host architecture)
[group('build')]
build image_name=image image_tag=tag:
    docker build -t {{ image_name }}:{{ image_tag }} -f Dockerfile_{{ image_tag }} .

# Push the image to its default registry
[group('build')]
push image_name=image image_tag=tag:
    docker push {{ image_name }}:{{ image_tag }}

# Bring the compose stack up locally
[group('deploy')]
up:
    docker-compose up -d

# Deploy the swarm stack
[group('deploy')]
deploy stack=stack:
    docker stack deploy --with-registry-auth -c docker-stack.yml {{ stack }}

# Remove node_modules
[group('build')]
clean:
    rm -rf v2/node_modules

# This container is for simplifying CI when using Azure Pipelines

# Aggregates all code into a single Docker image for export
FROM node:12


# Copy the web server code to /var/web/
ADD web/ /var/build/web/

# Copy SSH configuration and startup script to /var/
# Adopted from https://github.com/Azure-App-Service/node/blob/master/10.14/sshd_config
ADD init.sh /var/build/
ADD sshd_config /var/build/

# Doing a fresh "npm install" on build to make sure the image is reproducible
WORKDIR /var/build/web/
RUN npm ci

# Pack "concurrently" to make sure the image is reproducible
WORKDIR /var/build/
RUN npm install concurrently@4.1.0

# Pack the build content as a "build.tgz" and export it out
RUN tar -cf build.tgz *

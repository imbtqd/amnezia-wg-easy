# Use Node.js 20 for better performance and security
# Previous issue with armv6/armv7 should be resolved in newer versions
FROM docker.io/library/node:20-alpine AS build_node_modules

# Update npm to latest version
RUN npm install -g npm@latest

# Copy Web UI
COPY src /app
WORKDIR /app
RUN npm ci --omit=dev &&\
    mv node_modules /node_modules

# Copy build result to a new image.
# This saves a lot of disk space.
FROM amneziavpn/amneziawg-go:latest
HEALTHCHECK CMD /usr/bin/timeout 5s /bin/sh -c "/usr/bin/wg show | /bin/grep -q interface || exit 1" --interval=1m --timeout=5s --retries=3
COPY --from=build_node_modules /app /app

# Install Node.js
RUN apk add --no-cache \
    nodejs \
    npm

# Move node_modules one directory up, so during development
# we don't have to mount it in a volume.
# This results in much faster reloading!
#
# Also, some node_modules might be native, and
# the architecture & OS of your development machine might differ
# than what runs inside of docker.
COPY --from=build_node_modules /node_modules /node_modules

# Install Linux packages
RUN apk add --no-cache \
    dpkg \
    dumb-init \
    iptables

# iptables is installed and ready to use

# Set Environment
ENV DEBUG=Server,WireGuard

# Run Web UI
WORKDIR /app
CMD ["/usr/bin/dumb-init", "node", "server.js"]

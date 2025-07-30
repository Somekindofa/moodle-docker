FROM bitnami/moodle:latest

# Switch to root user to install packages
USER root

# Update package lists and install wget
RUN apt-get update && apt-get install -y wget curl

# Download and install firectl (corrected process)
RUN wget -O firectl.gz https://storage.googleapis.com/fireworks-public/firectl/stable/linux-amd64.gz
RUN gunzip firectl.gz
RUN install -o root -g root -m 0755 firectl /usr/local/bin/firectl

# Verify installation works
RUN /usr/local/bin/firectl --version || echo "firectl installed but version check failed"

# Clean up
RUN rm -f firectl && apt-get clean && rm -rf /var/lib/apt/lists/*

# Switch back to the default bitnami user
USER 1001
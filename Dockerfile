

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
RUN HOME=/tmp /usr/local/bin/firectl --version || echo "firectl installed but version check failed"

# Install grunt-cli globally
RUN npm install -g grunt-cli

# Create a startup script for grunt watch
RUN echo '#!/bin/bash\n\
cd /bitnami/moodle\n\
if [ -f "package.json" ]; then\n\
    npm install\n\
    grunt watch &\n\
fi\n\
exec "$@"' > /usr/local/bin/start-with-grunt.sh && \
    chmod +x /usr/local/bin/start-with-grunt.sh

# Ensure proper permissions for Moodle directories
RUN chown -R 1001:1001 /bitnami/moodle || true
RUN chmod -R 755 /bitnami/moodle/blocks || true

# Clean up
RUN rm -f firectl && apt-get clean && rm -rf /var/lib/apt/lists/*

# Switch back to the default bitnami user
USER 1001

# Set the entrypoint to our custom script
ENTRYPOINT ["/usr/local/bin/start-with-grunt.sh"]
CMD ["/opt/bitnami/scripts/moodle/run.sh"]
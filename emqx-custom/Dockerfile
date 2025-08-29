# Using EMQ X official image as the base image
FROM emqx/emqx:5.5.0

# Switch to root to install additional packages
USER root

# Update the package list and install inotify-tools
RUN apt-get update && \
    apt-get install -y inotify-tools

# Switch back to the default user for security, replace `emqx` with the actual user if it's different
USER emqx
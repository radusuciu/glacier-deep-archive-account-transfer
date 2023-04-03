# Use Alpine Linux for a minimal base image
FROM alpine:3.14

# Install AWS CLI
RUN apk add --no-cache \
    python3 \
    py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install awscli

# Copy the scripts to the container
COPY transfer_glacier_deep_archive.sh /usr/local/bin/transfer_glacier_deep_archive.sh
COPY delete_objects_and_remove_permissions.sh /usr/local/bin/delete_objects_and_remove_permissions.sh

# Set execute permissions for the scripts
RUN chmod +x /usr/local/bin/transfer_glacier_deep_archive.sh \
    && chmod +x /usr/local/bin/delete_objects_and_remove_permissions.sh

# Set the entrypoint to a shell
ENTRYPOINT ["/bin/sh"]
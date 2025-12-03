# Use a minimal base image suitable for fast CI/CD builds.
FROM alpine:latest
ARG A
ARG B
RUN echo $A $B
# Set an argument. This is often used in pipelines to pass version numbers,
# and it helps verify that the build environment can handle ARGs.
ARG BUILD_VERSION=1.0.0
ENV APP_VERSION=$BUILD_VERSION

# --- Simulation of Build Steps ---

# Step 1: Prove the RUN command executes and can install packages.
RUN echo "--- Pipeline Step 1: Initial Setup Check ---"
RUN apk update --no-cache && apk add --no-cache curl

# Step 2: Simulate creating a build artifact directory and writing a file.
RUN mkdir -p /app/dist
RUN echo "Artifact version: $APP_VERSION" > /app/dist/version.txt

# Step 3: Check build-time variables (shows the value from ARG/ENV).
RUN echo "--- Pipeline Step 2: Environment Validation ---"
RUN echo "Build process completed for version: $APP_VERSION"

# Step 4: Simple script execution test.
RUN sh -c "echo 'Build finished at: $(date)'"

# --- Final Container Configuration ---

# Define the default command when the container is run.
# It simply lists the created artifact and keeps the container active.
CMD ["sh", "-c", "echo '--- Build Test Successful ---' && ls -l /app/dist && cat /app/dist/version.txt && echo '--- Ready for runtime execution ---'"]

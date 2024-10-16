FROM ubuntu:24.04
LABEL MAINTAINER "Subash SN"

WORKDIR /app

# Install curl and dependencies
RUN apt-get update && \
    apt-get install -y curl iputils-ping wget && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Set up NVM environment variables
ENV NVM_DIR="/root/.nvm"
ENV NODE_VERSION="8.17.0"
ENV PATH="$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH"

# Install Node.js and NPM through NVM
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm use $NODE_VERSION && nvm alias default $NODE_VERSION && nvm install-latest-npm"

# Copy the package.json and install dependencies
COPY package*.json ./
RUN bash -c "source $NVM_DIR/nvm.sh && npm install"

# Copy the remaining app code
COPY . .

# Rebuild necessary native packages
RUN bash -c "source $NVM_DIR/nvm.sh && npm rebuild libxmljs && npm uninstall bcrypt && npm install bcrypt"

# Expose the necessary port
EXPOSE 9090

# Run the application
CMD ["bash", "-c", "source $NVM_DIR/nvm.sh && npm start"]

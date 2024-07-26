# SSH Container for Kubernetes

This repository provides a Docker container configured to run an SSH server. The container is designed to be deployed in a Kubernetes cluster and used for secure access to nodes within the cluster’s network. This approach is particularly useful for scenarios where you need to manage or debug applications and infrastructure inside a Kubernetes environment.

## Idea and Workflow

When deploying a server or system for a client using Kubernetes/Rancher, you can leverage Rancher's support for Kubernetes API through its authentication mechanism and token. By doing so, you can download the kubeconfig file of the cluster and use `kubectl` locally to interact with any cluster connected to Rancher.

### How It Works

1. **Deploy the SSH Container**: Deploy this SSH container to your Kubernetes cluster. The container will run an SSH server that listens on a specific port.

2. **Port Forwarding**: Use `kubectl port-forward` to forward the SSH port from the container to your local machine. This allows you to securely access the container’s SSH server from your local machine.

3. **SSH Access**: Once the port is forwarded, you can SSH into the container as if it were a node in your network. This provides you with direct access to the container’s environment and any network resources it has access to.

## Deployment Instructions

### Prerequisites

- Kubernetes cluster managed by Rancher.
- Rancher access with the ability to download the kubeconfig file.
- `kubectl` installed on your local machine.

### Building the Docker Image

1. Clone this repository:
   ```bash
   git clone https://github.com/your-repository/ssh-container.git
   cd ssh-container
   ```

2. Build the Docker image:
   ```bash
   docker build -t your-dockerhub-username/ssh-container:latest .
   ```

### Deploying the Container to Kubernetes

1. Create a Kubernetes deployment file, `ssh-deployment.yaml`, with the following content:

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: ssh-container
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: ssh-container
     template:
       metadata:
         labels:
           app: ssh-container
       spec:
         containers:
           - name: ssh-container
             image: your-dockerhub-username/ssh-container:latest
             ports:
               - containerPort: 22
   ```

2. Apply the deployment to your Kubernetes cluster:
   ```bash
   kubectl apply -f ssh-deployment.yaml
   ```

3. Forward the SSH port from the container to your local machine:
   ```bash
   kubectl port-forward deployment/ssh-container 2222:22
   ```

### Accessing the Container

Once port forwarding is set up, you can SSH into the container using the following command:
```bash
ssh root@localhost -p 2222
```

Replace `root` with the appropriate username if needed. The password or key for SSH access should be configured in the container as per your requirements.

## Dockerfile

The Dockerfile included in this repository is configured to set up an SSH server in a Debian-based image. Here’s a brief overview of the Dockerfile:

```Dockerfile
FROM debian:11-slim

RUN apt-get update && apt-get install openssh-server curl wget htop telnet dnsutils net-tools nano vim -y

WORKDIR /usr/local/bin/

COPY docker-entrypoint.sh ./
RUN chmod a+x docker-entrypoint.sh

RUN echo "GatewayPorts yes" >> /etc/ssh/sshd_config

CMD ["/usr/local/bin/docker-entrypoint.sh"]
```

The Dockerfile installs necessary packages, sets up the SSH server configuration, and specifies the entrypoint script.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request if you have suggestions or improvements.
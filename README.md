# DigitalOcean K3S Terraform

Sample Terraform project to create a single server, N-node worker K3S cluster on DigitalOcean ready to be used with `kubectl`. Ideal for a low cost homelab.

## Usage

Create the cluster;

```
terraform apply \
    -var "api_token=<your-do-token>" \
    -var "public_key=~/.ssh/do.pub" \
    -var "private_key=~/.ssh/do" \
```

By default this will download a kubeconfig file to `data/k3s.yaml`

Use the downloaded kubeconfig file to apply our Kubernetes manifest;

```
kubectl apply -f manifest --kubeconfig=data/k3s.yaml
```

An example ingress rule can be found in  `manifest/ingress.yaml` for configuring the default Traefik installation.
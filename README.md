# darst
darts jump box


# How to use

- First create the EC2 instance via: `AWS_PROFILE=lfproduct-test ./create_ec2_instance.sh`
- Wait for instance top be up and then: `./ssh_into_ec2_pem.sh` (it will use Key PEM file stored locally as `DaRstKey.pem` - not checked into the git repository - gitignred).
- When inside the instance, allow password login, create `darst` user that can `sudo` and logout.
- Login as `darst` user via: `./ssh_into_ec2.sh`. here you go. Passwords are stored in `passwords.secret` that is also gitignored.
- Finally if you have ssh keys defined on you machine, you can add them to the darst box, so you won't need to enter passwords anymore, run: `./add_ssh_keys.sh`.
- Suggest running: `AWS_PROFILE=... aws ec2 describe-instances | grep PublicIpAddress`, get server's IP address and add a line to `/etc/hosts`, like this one: `X.Y.Z.V dars`.
- After than you can login password-less via: `ssh darst@darst` or `root@darst` and that configuration is assumed later.


# AWS

- Use `testaws.sh` (installed from `aws/testaws.sh`) instead of the plain `aws` command, it just prepends `AWS_PROFILE=lfproduct-test`.
- Similarly with `devaws.sh`, `stgaws.sh` and `prodaws.sh`.


# Kubernetes (EKS >= v1.13)

- Use `testk.sh` (installed from `k8s/testk.sh`) instead of the plain `kubectl` command, it just prepends `KUBECONFIG=/root/.kube/kubeconfig_test AWS_PROFILE=lfproduct-test`.
- Similarly with `devk.sh`, `stgk.sh` and `prodk.sh`.


# Helm 3

- Use `testh.sh` (installed from `helm/testh.sh`) instead of the plain `helm` command, it just prepends `KUBECONFIG=/root/.kube/kubeconfig_test AWS_PROFILE=lfproduct-test`.
- Similarly with `devh.sh`, `stgh.sh` and `prodh.sh`.
- You can prepend with `V2=1` to use `Helm 2` instead of `helm 3` - but this is only valid until old clusters are still alive.


# eksctl


- Use `testeksctl.sh` (installed from `eksctl/testeksctl.sh`) instead of the plain `eksctl` command, it just prepends `KUBECONFIG=/root/.kube/kubeconfig_test AWS_PROFILE=lfproduct-test`.
- Similarly with `deveksctl.sh`, `stgeksctl.sh` and `prodeksctl.sh`.
- Use `eksctl/get_cluster.sh {{env}}` to get current cluster info, replace `{{env}}` with `dev` or `stg` or `test` or `prod`.
- Use `eksctl/create_cluster.sh {{env}}` to create EKS v1.13 cluster, replace `{{env}}` with `dev` or `stg` or `test` or `prod`.
- Use `eksctl/delete_cluster.sh {{env}}` to delete cluster, replace `{{env}}` with `dev` or `stg` or `test` or `prod`.

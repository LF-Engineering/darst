# darst
darts jump box


# How to use

- First create the EC2 instance via: `AWS_PROFILE=lfproduct-test ./ec2/create_ec2_instance.sh`
- Wait for instance top be up and then: `./ec2/ssh_into_ec2_pem.sh` (it will use Key PEM file stored locally as `DaRstKey.pem` - not checked into the git repository - gitignred).
- When inside the instance, allow password login, create `darst` user that can `sudo` and logout.
- Login as `darst` user via: `./ec2/ssh_into_ec2.sh`. here you go. Passwords are stored in `passwords.secret` that is also gitignored.
- Finally if you have ssh keys defined on you machine, you can add them to the darst box, so you won't need to enter passwords anymore, run: `./ec2/add_ssh_keys.sh`.
- Suggest running: `AWS_PROFILE=... aws ec2 describe-instances | grep PublicIpAddress`, get server's IP address and add a line to `/etc/hosts`, like this one: `X.Y.Z.V dars`.
- After than you can login password-less via: `ssh darst@darst` or `root@darst` and that configuration is assumed later.


All next commands are assumed to be run on the `darst` jump box.

- Use `mfa.sh` (from `mfa/mfa.sh`) to renew your AWS access keys for the next 36 hours.


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
- Use `eksctl/get_cluster.sh {{env}}` to get current cluster info, replace `{{env}}` with `dev` or `stg` or `test` or `prod`. Example: `./eksctl/create_cluster.sh test`.
- Use `eksctl/create_cluster.sh {{env}}` to create EKS v1.13 cluster, replace `{{env}}` with `dev` or `stg` or `test` or `prod`. Example `./eksctl/get_cluster.sh test`.
- Use `eksctl/delete_cluster.sh {{env}}` to delete cluster, replace `{{env}}` with `dev` or `stg` or `test` or `prod`. Example: `./eksctl/delete_cluster.sh test`.


# Utils

Those scripts are installed in `/usr/local/bin` from `./utils/` directory.

- Use `change_namespace.sh test namespace-name` to change current namespace in `test` env to `namespace-name`.
- Use `pod_shell.sh env namespace-name pod-name` to bash into the pod.


# Deploy infra step-by-step

For each envs (`test`, `dev`, `staging`, `prod`), example for the `test` env:

- Create EKS v1.13 cluster: `./eksctl/create_cluster test`. you can drop the cluster via `./eksctl/delete_cluster.sh test`.
- Init Helm on the cluster: `testh.sh init`.
- Create local-storage storage class and mount NVMe volumes in `devstats`, `elastic` and `grimoire` node groups: `./local-storage/setup.sh test`. You can delete via `./local-storage/delete.sh test`.
- Install OpenEBS and NFS provisioner: `./openebs/setup.sh test`. You can delete via `./openebs/delete.sh test`.
- Install ElasticSearch Helm Chart: `./es/setup.sh test`. You can delete via `./es/delete.sh test`.
- When ES is up and running (all 5 ES pods should be in `Running` state: `testk.sh get po -n dev-analytics-elasticsearch`), test it via: `./es/test.sh test`.
- Clone `cncf/da-patroni` repo and change directory to that repo.
- Run `./setup.sh test` to deploy on `test` env.
- Run `./config.sh test` to configure patroni once it is up & running, check for for `3/3` Ready from `testk.sh get sts -n devstats devstats-postgres`.
- To delete run `./delete.sh test`.
- For each file in `redis/secrets/*.secret.example` create corresponding `redis/secrets/*.secret` file. `*.secret` files are not checked in the gitgub repository.
- Each file must be saved without new line at the end. `vim` automatically add one, to remove `truncate -s -a filename`.
- Run `./redis/setup.sh test` to deploy Redis on `test` env.
- Run `./redis/test.sh test` to test Redis installation.
- To delete Redis run `./redis/delete.sh test`.
- Clone `cncf/json2hat-helm` repo and change directory to that repo.
- Run `./setup.sh test` to deploy on `test` env.
- To delete run `./delete.sh test`.
- Clone `cncf/devstats-helm-lf` repo and change directory to that repo.
- Run `./setup.sh test` to deploy on `test` env. Note that this currently deploys only 4 projects (just a demo), all 65 projects will take days to provision.
- Run `./add_projects.sh test 4 8` to add 4 new projects with index 4, 5, 6, 7 (see `devstats-helm/values.yaml` for project indices.
- To delete run `./delete.sh test`.
- For each file in `mariadb/secrets/*.secret.example` create corresponding `mariadb/secrets/*.secret` file. `*.secret` files are not checked in the gitgub repository.
- Each file must be saved without new line at the end. `vim` automatically add one, to remove `truncate -s -a filename`.
- Install MariaDB database: `./mariadb/setup.sh test`. You can delete via `./mariadb/delete.sh test`.
- Once installed test if MariaDB works (should list databases): `./mariadb/test.sh test`.
- Provision Sorting Hat structure: `./mariadb/structure.sh test`.
- Popoulate merged `dev` and `staging` Sorting Hat data: `./mariadb/populate.sh test`. You will need `cncf/merge-sh-dbs` repo cloned in `../merge-sh-dbs` and actual merged data generated (that merged SQL is checked in the repo).
- Run `./mariadb/backups.sh test` to setup daily automatic backups.


# Merge Sorting Hat databases

If you want to merge `dev` and `staging` sorting hat databases:

- Clone `cncf/merge-sh-dbs`.
- Follow `README.md` instructions.


# MariadDB backups image

- Use `DOCKER_USER=... ./mariadb/backups_image.sh` to build MariaDB backups docker image.


# dev-analytics-sortinghat-api tests image

- Use `docker build -f Dockerfile -t "docker-user/dev-analytics-sortinghat-api" .` to build `dev-analytics-sortinghat-api` tests image, replace `docker-user` with your docker user.

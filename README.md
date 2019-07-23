# darst
darts jump box

# How to use

- First create the EC2 instance via: `AWS_PROFILE=lfproduct-test ./create_ec2_instance.sh`
- Wait for instance top be up and then: `./ssh_into_ec2_pem.sh` (it will use Key PEM file stored locally as `DaRstKey.pem` - not checked into the git repository - gitignred).
- When inside the instance, allow password login, create `darst` user that can `sudo` and logout.
- Login as `darst` user via: `./ssh_into_ec2.sh`. here you go. Passwords are stored in `passwords.secret` that is also gitignored.
- Finally if you have ssh keys defined on you machine, you can add them to the darst box, so you won't need to enter passwords anymore, run: `./add_ssh_keys.sh`.

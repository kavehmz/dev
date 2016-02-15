# dev
This is my personal code maintenance tool. This will help me to have all my shortcuts and the environment that I like automatically.

To use this tool you need to install vagrant:

https://www.vagrantup.com/downloads.html

You also need to install Virtualbox:

https://www.virtualbox.org/wiki/Downloads

Then you need to go and create a readonly github token in your github account:

https://github.com/settings/tokens

Then create a file in current directory in this path, "home/share/secret/github_token", and paste your token there.
Notice this path is inside the repo, "home". This is not your host "/home".

After this, vagrant can build your VM and it will clone all your repositories.

```$ vagrant up```

Later if you like, you can also copy your ssh key to be used in this VM.

```$ cp ~/.ssh/id_rsa root/.ssh/```

I have added .gitignore in different places to make sure no secret gets committed, but still be very careful if you want to do a change in this repo and commit it.

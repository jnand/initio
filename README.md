Expecto Initio
===============

*Endpoint and personal infra provisioning, like magic*

[![Build Status](https://travis-ci.org/jnand/initio.svg?branch=master)](https://travis-ci.org/jnand/initio)
[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)


![Wizards](https://i.giphy.com/media/5tlq0pRndGu8U/giphy.webp)


This is a collection of [ansible](https://www.ansible.com/) playbooks for provisioning a new laptop, server, or other endpoint in a bespoke setup. Ideally, new systems should be up and running within a few commands.


Quick Start
-----------

Edit [`default.config.yml`](.config/initio/default.config.yml) as needed. Most defaults are specific to my setup. [`config.yml`](.config/initio/config.yml) offers an easy way to override settings for testing. Remember to update the deploy key path for the "Secrets" repo before provisioning.

Use the included [`bootstrap.sh`](.local/share/initio/bootstrap.sh) file to setup and execute the runbook (locally and interactively).

```
❯ curl https://raw.githubusercontent.com/jnand/initio/master/.local/share/initio/bootstrap.sh --output bootstrap.sh
❯ ./bootstrap.sh --skip-tags="home"
```

The runbook will ask about the setup: laptop, workstation, headnode, fileserver, or compute node. Each type has its own role found in [`.config/initio/roles`](.config/initio/roles), useful for individual push-deploys. Use the ansible `--tags|--skip-tags=` flag to provision as a home or work box. Tasks tagged **`home`** include personal configs and repos; `--skip-tags=home` will exclude personal info and only uses common settings and public repos -- *i.e.* a box configured for work _**without**_ your personal dropbox, github keys, or fileserver creds etc... 



:exclamation: Remember to check the [Manual Post-Install](#manual-install) checklist.


Run Modes
----------

### Tags ###

|    Tag     | Description |
|:-----------|:------------|
|blockblock  | task raises a security dialog (macos) |
|development | dev tooling |
|home, personal | personal configs, secrets, and private repos |
|nobuild     | skip tasks during automated builds, i.e. downloading large binaries |
|bigdl       | large downloads |
|pamlockout  | might cause fail secure lockouts |
|prompt      | task raises a user prompt, cli/gui |
|symlink     | symlink creations |


`--skip-tags=prompt,blockblock` useful for pushing out changes via ansible ssh  
`--tags=symlink` useful when you only need to update config links  
`--tags=development` push out new dev tooling   

Built with
-----------

<dl>
	<dt>Ansible</dt>
	<dd>An IT automation suite for deploying and provisioning new systems (https://www.ansible.com/)</dd>
	<dt>Homebrew</dt>
	<dd>Package management for macOS (https://brew.sh/)</dd>
	<dt>Mackup</dt>
	<dd>App setting sync and backup (https://github.com/lra/mackup)</dd>
	<dt>YADM</dt>
	<dd>Dotfile management (https://thelocehiliosan.github.io/yadm/)</dd>
</dl>


XDG Base Dir Spec
------------------

initio aims to keep the home directory clean by consolidating files into `~/.config` and `~/.local`. Descriptions of where to find everything follow in the tree below:

`.config` is the new home of config dirs typically found cluttering `$HOME`
```
.config
├── git
├── gnupg
├── initio
...
├── ssh
└── zsh
```

Within `.config` is `initio`, where all ansible playbooks and support files are kept. The master playbook is [`runbook.yml`](.config/initio/runbook.yml). Additional requirements via ansible-galaxy are in the [`requirements.yml`](.config/initio/requirements.yml) file, see the [`bootstrap.sh`](.local/share/initio/bootstrap.sh) file for an example.
```
├── initio
   ├── config.yml
   ├── default.config.yml
   ├── hosts
   ├── playbooks
   │   ├── laptop.yml
   │   └── preflight.yml
   ├── requirements.yml
   ├── roles
   │   ├── dotfiles
   │   ├── gnupg
   │   ├── secrets
   │   ...
   │   └── zsh
   └── runbook.yml
```

XDG calls for all non configuration files to be stored in `~/.local`. External tools like YADM are cloned into the `lib` dir and symlinked to `bin`. The included `.zshrc` adds `~/.local/bin` to the user's `PATH` envar. Application data and infrequently used support scripts are kept in the `share` dir. YADM store encrypted secrets in `files.gpg` which is cloned from a private "secrets" repo during setup.

```
.local
├── bin
│   └── yadm -> ../lib/yadm/yadm
├── lib
│   ├── initio
│   │   └── initio.sh
│   └── yadm
└── share
    ├── initio
    │   └── bootstrap.sh
    └── yadm
        ├── encrypt
        ├── files.gpg -> ~/Secrets/Yadm/files.gpg
        └── repo.git
```



Included Stuff
--------------

* Ansible
* GnuPG
* Homebrew
* Mackup
* OpenSSH
* XDG Directory Spec
* YADM
* Yubikey PAM
* ZSH
* ZIM
* ... [more](.config/MANIFEST.md)


Manual Install
--------------

These software packages are tighly controlled by their vendors and need manual installation, and/or registering a cloud client.

| Install | Login | Config | License | Name        | URL |
|:-------:|:-----:|:------:|:-------:|:----------- |:----|
|         | [ ]   |        | [ ]     |Backblaze    | https://www.backblaze.com/
|         | [ ]   |        |         |Dropbox      | https://www.dropbox.com/install-linux
|         | [ ]   |        | [ ]     |GitKraken    | https://www.gitkraken.com/
|         | [ ]   |        | [ ]     |JetBrains    | https://account.jetbrains.com/login
| [ ]     |       |        | [ ]     |LittleSnitch | https://www.obdev.at/products/littlesnitch/index.html
|         | [ ]   |        | [ ]     |MS Office    | https://www.office.com/
| [ ]     | [ ]   | [ ]    |         |Sophos       | https://home.sophos.com
|         | [ ]   |        |         |Todoist      | https://todoist.com
|         | [ ]   |        |         |Toggl        | https://toggl.com/
|         |       |        | [ ]     |VMWare       | https://www.vmware.com/products/fusion.html


Testing
--------

### Travis ###

The included travis config checks syntax and smaller binary package installs. Any tasks requiring user intervention, security privileges, or large downloads are skipped.

### Vagrant ###

A full deployment test can be run against each spec'd target. `.config/initio/tests` contains a simplified `hosts` file and a `Vagrantfile` with configuration for provisioning those environments.

**From the host os**
```
❯ cd ~/.config/initio/tests
❯ vagrant up macos
```

**From the guest os**
```
❯ ~/.config/initio/tests/run_suite.sh
```

`run_suite.sh` will pass-through `ansible-playbook` arguments

After provisioning the `development` role, the [ansible-toolbox](https://github.com/larsks/ansible-toolbox) should be available in the host allowing more granular testing/development.

**Developing with vagrant**

The `bootstrap.sh` script checks out the initio repo into the vagrant user's home. If you have the guest os's home dir shared/mounted on your host you can develop/test directly. If share mounting isn't working, which is the case for BSD, you can set the guest os's home dir as a git remote in the repo on your host, and "push to test", a post-receive githook should catch the push and start ansible on the vm. _Note_ your ssh public key will need to be added to the vagrant user's authorized keys for this to work.

**Developement Quickstart**


_ENV vars for development_

| ENVar         | Description | 
|:-------------:|:-------:|
| INITIO_REPO   | repository uri/path |
| INITIO_BRANCH | git branch name |
| INITIO_TEST   | prevent bootstrap.sh from running the playbook |
| INITIO_YADM   | git repo uri/path | 
| INITIO_ZIM    | git repo uri/path |


To setup a VM without automatically running the playbook


1. Start up the VM
2. Ensure there is a shared directory between the host and guest os
3. Checkout the repo into the shared directory

    ```
    cd /vm_shared
    git clone https://github.com/jnand/initio.git
    ```
4. ssh into the guest vm

    ```
    ssh vagrant@guestvm
    ```
5. Boostrap initio from the repo cloned into the shared directory
    
    ```
    INITIO_REPO=/vm_shared/path INITIO_BRANCH=dev INITIO_TEST=true  ./bootstrap.sh --skip-tags="bigdl"
    ```

6. Optional. snapshot your vm.
7. Check that the dev deploy points to our shared repo, and update

    ```
    cd
    git remote -v
    git pull 
    ```

8. Run the test harness as needed, using `git pull` to get changes from the shared repo thats being edited on the host os.. 

    ```
    INITIO_REPO=/vm_shared/path INITIO_BRANCH=dev run_suite.sh --skip-tags="bigdl"
    ```








References
------------------

1. XDG Specification. https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
2. Dotfiles. https://dotfiles.github.io/
3. Mac Dev Playbook. https://github.com/geerlingguy/mac-dev-playbook
4. TravisCI & Ansible. https://www.jeffgeerling.com/blog/testing-ansible-roles-travis-ci-github
5. Ansible Homebrew. https://github.com/geerlingguy/ansible-role-homebrew/blob/master/README.md
6. Terminal Colors. https://github.com/mbadolato/iTerm2-Color-Schemes
7. MacOS Playbooks. https://github.com/mtneug/cfg_mgmt-macos
8. Macbuild. https://github.com/fgimian/macbuild
9. Zshenv. https://github.com/gverilla/dotfiles

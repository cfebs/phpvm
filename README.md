phpvm
=====

A php version manager for linux that strives to mirror the functionality of [rvm](https://rvm.io/)

### Disclaimer

This is just an experiment, lets see how it goes!


Install
-------

Clone the repo somewhere, in this example `~/phpvm_src`

    mkdir ~/phpvm_src && cd ~/phpvm_src
    git clone repo
    ln -s $PWD $HOME/.phpvm

    # add to ~/.bashrc
    [[ -s "$HOME/.phpvm/scripts/phpvm" ]] && . "$HOME/.phpvm/scripts/phpvm"

*TODO*
  - auto installer

Usage
-----

Install a php version

    phpvm install 5.3.13

Uninstall a php version

    phpvm remove 5.3.13

Apply a php version to current path

    phpvm use 5.3


TODO Usage
----------

Upgrade the tool

    phpvm up

Major installs

    phpvm install 5.3  # latest major version

Save a default version to load

    phpvm use --default 5.3  # sets a version as the default

Architecture
------------

This will change as I start to study rvm more closely

    $HOME/.phpvm
        script/
            # home of this script, functions, etc
        phps/
            php-5.3.13/
                # compiled and ready to use
        tmp/
            source/
                php-5.3.13/
                    # extracted source
            raw/
                php-5.3.13.tar.bz2
                    # raw download

Environment variables

    # this should be customizable
    $phpvm_home=$HOME/.phpvm

PHP will compile with these params by default

    --prefix="$PHPVM_HOME/phps/php-{version-num}" --without-pear

### For Quick Dev

Placing an empty ``.dev`` file in the ``~./phpvm`` directory will re-source itself before any command

Motivation
==========

One of the ways working with ruby is so pleasant is simple management scripts
and packages like gems, rvm and rbenv. composer is gaining some traction, but
getting up and running fast with php in a self contained environment is not as easy.

After learning the workflow of installing a ruby version once through rvm I was hooked.

These tools are fun to use, and they're just plain missing from PHP.
xampp is a relative of sorts, but it's not quite the same.

PHP 5.4 includes a builtin web server which is fantastic for this project.

That means that users can pull down a version of php and with very simple PATH modification and get up and running even faster.

One big TODO is going to be refining PATH/bin management for the traditional php dev environment, which I am really not sure how to tackle yet.

Goal
----

My goal is to replicate the main features of these tools for php in rough order of importance

1. Downloading and compiling specific versions
1. Dropping them in sub dir in a user's home
1. Managing the users's ``$PATH`` to swap out versions
1. Tight integration with PHP 3.4's embedded server
1. Tight integration with PHP 3.4's composer and packagist
1. Clean upgrades to new versions of this tool
1. Auto complete commands
1. Make it a viable alternative for real web servers, system level php
  - This is going to be tough!

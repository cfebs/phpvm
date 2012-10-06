PHP version manager
===================

One of the ways working with ruby is so pleasant is simple management scripts
and packages like gems, rvm and rbenv. composer is gaining some traction, but
getting up and running fast with php in a self contained environment is not as easy.

After learning the workflow of installing a ruby version once through rvm I was hooked.

These tools are fun to use, and they're just plain missing from PHP.
xampp is a close relative, but it's not quite the same.

### Disclaimer

This is just an experiment, lets see how it goes!

Goal
----

My goal is to replicate the main features of these tools for php.

1. Downloading and compiling specific versions
2. Dropping them in sub dir in a user's home
3. Managing the users's ``$PATH`` to swap out versions
4. Make it a viable alternative for real web servers, system level php
5. Clean upgrades to new versions of this tool
6. Tight integration with PHP 3.4's embedded server
7. Tight integration with PHP 3.4's composer and packagist

Hypothetical Usage
------------------

Install a php version

    phpvm install 5.3.13
    phpvm install 5.3  # latest major version

Uninstall a php version

    phpvm remove 5.3.13

Apply a php version to current path

    phpvm use 5.3
    phpvm use --default 5.3  # sets a version as the default

Upgrade the tool

    phpvm get


Architecture
------------

This will change as I start to study rvm more closely

    $HOME/.phpvm
        script/
            # home of this script (only 1 version for now)
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

PHP will complie with these params by default

    --prefix="$PHPVM_HOME/phps/php-{version-num}" --without-pear

The aim of this is to ditch PEAR for composer/packagist. Provide optional arg for configure args

Instalation
-----------

Aiming for really simple curl based auto-install design I have seen.

    curl -L url.com | bash -s

    mkdir $HOME/.phpvm
    # drop installation into the script dir, call it a day

### For Quick Dev

Links this source to our target install dir.

    ln -s $PWD $HOME/.phpvm
    . ./scripts/phpvm

Placing an empty ``.dev`` file in the ``~./phpvm`` directory will re-source itself before any command

More Writing
============

PHP 5.4 includes a builtin web server which is fantasitc for this project.

That means that users can pull down a version of php and with very simple PATH modification and get up and running even faster.

One big TODO is going to be refining PATH/bin management for the traditional php dev environment, which I am really not sure how to tackle yet.

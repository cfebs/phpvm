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
2. Dropping them in a user's home directory
3. Managing the users's $PATH
4. Clean upgrades to new versions of this tool

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
            5.3.13/
                # compiled and ready to use
        tmp/
            source/
                5.3.13/
                    # extracted source
            raw/
                5.3.13/
                    # raw download

Environment variables

    # this should be customizable
    $PHPVM_HOME=$HOME/.phpvm

PHP will complie with these params by default

    --prefix="$PHPVM_HOME/phps/php-{version-num}" --without-pear

The aim of this is to ditch PEAR for composer/packagist. Something to revert later or add option for if desired

Instalation
-----------

Aiming for really simple curl based auto-install design I have seen.

    mkdir $HOME/.phpvm
    mkdir $HOME/.phpvm/script
    # drop installation into the script dir

### For Quick Dev

Links this source to our target install dir.

    ln -s $PWD $HOME/.phpvm
    . ./scripts/phpvm

Placing a ``.dev`` file in the ``~./phpvm`` directory will re-source itself before any command

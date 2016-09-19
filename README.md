# phpvm

A php version manager for linux that stays out of your way.

## Quick start

Clone repo somewhere

```
phpvm ls-remote
phpvm install 7.0.4
```

## Commands

```
phpvm ls-remote
```

> Fetches http://php.net/downloads.php and http://php.net/releases/ and parses them for version numbers. Not 100% accurate, but not bad

```
phpvm install 7.0.4
```

> Creates directories `~/.phpvm/installs/7.0.4/bin` and `~/.phpvm/installs/7.0.4/src`. Downloads php, configures it, builds it, downloads composer. Then links php sapi cli bin to the `bin` directory and creates a composer bin file that just calls the downloaded `composer.phar` file with this version of php

```
phpvm ls
```

> Looks locally for installed cli bins

```
phpvm bin
```

> Outputs phpvm bin path, in this directory should be `php` and `composer` exes, so you can do: `$(phpvm bin 7.0.4)/php -r 'echo "hi";'` and `$(phpvm bin 7.0.4)/composer install`

## Reference

### Build dependencies

A list of some php deps required for building

#### Ubuntu

```
sudo apt-get install build-essential libxml2-dev
```

### Scope of features

This tool is meant to do a few things: download php, configure php, build php and make finding paths to php installs easy.

This is contrary to the more robust (and fantastic) tools like [rvm](https://github.com/rvm/rvm), [rbenv](https://github.com/rbenv/rbenv) and [nvm](https://github.com/creationix/nvm) - `phpvm` does less!

If phpvm doesn't do something you want, consider setting up functions or aliases in your own configuration.

```sh
# in ~/.bashrc
PHPVM_BIN="$HOME/src/phpvm/phpvm"
MY_PHP_VERSION='7.0.4'
alias pphp="$("$PHPVM_BIN" bin "$MY_PHP_VERSION")/php"
alias ccomposer="$("$PHPVM_BIN" bin "$MY_PHP_VERSION")/composer"
```

This way you could use `pphp` and `ccomposer` in your shell and be using the versions managed by phpvm.

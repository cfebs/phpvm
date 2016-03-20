#!/usr/bin/env bash

phpvm_path="$HOME/.phpvm"
old_rels_cache_path="$phpvm_path/tmp/old_releases.html"
rels_cache_path="$phpvm_path/tmp/releases.html"
downloads_path="$phpvm_path/tmp"

help() {
    echo "phpvm cmd"
    echo "Commands"
    echo -e "\thelp\t\tshow this"
    echo -e "\thelp cmd\tshow cmd specific help"
    echo -e "\tls\t\tlist installed php versions"
    echo -e "\tls-remote\tlist remote php versions"
    echo -e "\tinstall version\tinstalls a remote php version"
    echo -e "\tbin\t\tget bin path for an install"
}

deps() {
    echo "libxml2-dev"
}

dir_setup() {
    mkdir -p ~/.phpvm
    mkdir -p ~/.phpvm/tmp
    mkdir -p ~/.phpvm/current
}

ls_remote__get_releases() {
    wget -qO- 'http://php.net/releases/' > $old_rels_cache_path
    wget -qO- 'http://php.net/downloads.php' > $rels_cache_path
    return 0
}

ls_remote__versions() {
    local old_versions="$(cat $old_rels_cache_path| grep -o -e '[0-9]\+\.[0-9]\+\.[0-9]\+' | sort | uniq)"
    local new_versions="$(cat $rels_cache_path | grep -o -e '[0-9]\+\.[0-9]\+\.[0-9]\+' | sort | uniq)"
    echo "$old_versions"
    echo "$new_versions"
    return 0;
}

ls_remote() {
    local cache_time=$((60*15))
    #local cache_time=0 # for debug

    if [ -f "$old_rels_cache_path" ]
    then
        local last_mod_time=$(stat "$old_rels_cache_path" -c %Y)
        local cur_time=$(date +"%s")
        local time_diff=$(($cur_time - $last_mod_time))
        if [ "$time_diff" -gt "$cache_time" ]
        then
            ls_remote__get_releases
        fi
    else
        ls_remote__get_releases
    fi

    local old_versions="$(cat $old_rels_cache_path| grep -o -e '[0-9]\+\.[0-9]\+\.[0-9]\+' | sort | uniq)"
    local new_versions="$(cat $rels_cache_path | grep -o -e '[0-9]\+\.[0-9]\+\.[0-9]\+' | sort | uniq)"
    echo "Old versions:"
    echo "$old_versions"
    echo ""
    echo "Stable versions:"
    echo "$new_versions"
}

test_full_version() {
    local version="$1"
    if echo "$version" | grep -q -e '[0-9]\+\.[0-9]\+\.[0-9]\+'
    then
        return 0
    fi

    return 1
}

get_version_dir() {
    local version="$1"
    echo "$phpvm_path/installs/$version"
    return 0
}

get_tar_url() {
    local version="$1"
    echo "http://php.net/get/php-$version.tar.bz2/from/this/mirror"
}

install() {
    local version="$2"

    # init cache files
    ls_remote > /dev/null

    # search for version
    local versions="$(ls_remote__versions)"
    if test_full_version "$version"
    then
        echo "$version OK format"
    else
        echo "A full version not specified"
        return 1
    fi

    if echo "$versions" | grep -q -e "$version"
    then
        echo "$version in available versions"
    else
        echo "$version not in available versions, try again"
    fi

    echo "Starting install"

    local install_dir="$(get_version_dir "$version")"

    echo "Install dir: $install_dir"

    local install_src_dir="$(get_version_dir "$version")/src"

    local tar_url="$(get_tar_url "$version")"
    local tar_file="php-${version}.tar.bz2"
    local tar_path="$downloads_path/$tar_file"

    if [ ! -f "$tar_path" ]
    then
        echo "Getting: $tar_url saving to $tar_file"
        wget -O "$tar_path" "$tar_url"
    fi


    if [ ! -f "$tar_path" ]
    then
        echo "Cannot find $tar_path, check download"
        return 1
    fi

    mkdir -p "$install_src_dir"

    local extracted_dir="$install_src_dir/php-$version"

    # install dirs
    # /installs/$version/src
    # /installs/$version/

    # @todo don't necessarily know extracted dir pattern
    if [ -d "$extracted_dir" ]
    then
        echo "Extracted dir exists: $extracted_dir"
    else
        tar -xvf "$tar_path" -C "$install_src_dir"
    fi

    cd "$extracted_dir"

    # @todo configure options
    ./configure
    make

    return 0;
}

bin_path() {
    local version="$1"
    local version_dir="$(get_version_dir "$version")"
    local bin_dir="$version_dir/src/php-$version/sbin"

    echo "$bin_dir"
    if [ ! -d "$bin_dir" ]
    then
        echo "No bin dir found"
        exit 1
    fi

    echo "$bin_dir"
}

dir_setup
case "$1" in
    help)
        help
        exit 0
        ;;
    bin)
        bin_path "$@"
        exit 0
        ;;
    ls-remote)
        ls_remote
        exit 0;
        ;;
    install)
        install "$@"
        exit 0;
        ;;
    *)
        help
        exit 0
        ;;
esac

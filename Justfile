buildplans := "buildplan.toml"
iosevka_dir := quote(justfile_directory() / 'iosevka')

default: setup build copy clean

setup:
    #! /usr/bin/env -S nix shell nixpkgs#nodejs --command bash
    cp {{buildplans}} {{iosevka_dir}}/private-build-plans.toml
    cd {{iosevka_dir}} && npm install

build:
    #!/usr/bin/env -S nix shell nixpkgs#nodejs nixpkgs#ttfautohint --command bash
    cd {{iosevka_dir}}
    npm run build -- contents::SkyCode
    npm run build -- contents::SkyTerm

copy:
    #!/usr/bin/env bash
    mkdir -p {{justfile_directory()}}/fonts
    mkdir -p {{justfile_directory()}}/fonts/ttf
    mkdir -p {{justfile_directory()}}/fonts/woff2
    cd {{iosevka_dir}}/dist/SkyCode
    cp TTF/*.ttf {{justfile_directory()}}/fonts/ttf/
    cp WOFF2/*.woff2 {{justfile_directory()}}/fonts/woff2/
    cp SkyCode.css {{justfile_directory()}}/fonts/SkyCode.css
    cd {{iosevka_dir}}/dist/SkyTerm
    mkdir -p {{justfile_directory()}}/fonts
    mkdir -p {{justfile_directory()}}/fonts/ttf
    mkdir -p {{justfile_directory()}}/fonts/woff2
    cp TTF/*.ttf {{justfile_directory()}}/fonts/ttf/
    cp WOFF2/*.woff2 {{justfile_directory()}}/fonts/woff2/
    cp SkyTerm.css {{justfile_directory()}}/fonts/SkyTerm.css

clean:
    rm -rf "{{iosevka_dir}}/dist"

list:
    @just --list --list-heading 'available recipes:'

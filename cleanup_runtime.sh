#!/bin/bash

rm -rf \
  runtime/autoload/netrw.vim \
  runtime/autoload/netrwFileHandlers.vim \
  runtime/autoload/netrwSettings.vim \
  runtime/autoload/netrw_gitignore.vim \
  runtime/autoload/tar.vim \
  runtime/autoload/vimball.vim \
  runtime/autoload/zip.vim \
  runtime/plugin/gzip.vim \
  runtime/plugin/netrwPlugin.vim \
  runtime/plugin/tarPlugin.vim \
  runtime/plugin/vimballPlugin.vim \
  runtime/plugin/zipPlugin.vim \
  runtime/syntax/netrw.vim \

echo "Done! Now commit the changes."


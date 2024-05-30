#!/bin/bash

ACTION="${ACTION:-pull}"

git subtree $ACTION --prefix runtime/pack/dist/opt/lightline.vim/ lightline master --squash
git subtree $ACTION --prefix runtime/pack/dist/opt/lightline-bufferline/ lightline-bufferline master --squash
git subtree $ACTION --prefix runtime/pack/dist/opt/rainglow-vim/ rainglow-vim master --squash
git subtree $ACTION --prefix runtime/pack/dist/opt/vim9-stargate/ vim9-stargate main --squash
git subtree $ACTION --prefix runtime/pack/dist/opt/lsp/ lsp main --squash
git subtree $ACTION --prefix runtime/pack/dist/opt/litesnip/ litesnip devel --squash


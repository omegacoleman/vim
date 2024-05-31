litesnip
========

A lightweight snip plugin written in vim9script.

## 1. writing snips

First, create a folder named `litesnips/<filetype>` under vim runpath, for example, `~/.vim/litesnips/cpp`

Then you can add snips to it, for example, `~/.vim/litesnips/cpp/main.snip`

```
int main(int argc, char** argv) {
####
  return EXIT_SUCCESS;
}
```

the `####` is where the cursor will be placed after expansion, if not present, the cursor is placed after the end.

## 2. usage

In insert mode, type `<c-s>` to expand snips.

e.g. when editing cpp files, to expand the above example, pressing Ctrl+S with the current buffer:

```
main|
```

will be expanded to:

```
int main(int argc, char** argv) {
|
  return EXIT_SUCCESS;
}
```

`|` resembles the cursor position


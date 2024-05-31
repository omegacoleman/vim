vim9script

def ControllerHandler(ch: channel, msg: string): void
  execute msg
enddef

var rpath = 'fifo:/tmp/vim-controller-' .. string(getpid())

var rchan = ch_open(rpath, {
  "mode": "nl",
  "callback": ControllerHandler
})

if !exists("g:rex_path_prefix")
    g:rex_path_prefix = "/tmp/vim-rex-"
endif

export def g:ControllerChannel(): channel
  return rchan
enddef

autocmd VimLeave * ch_close(rchan)


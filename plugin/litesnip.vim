vim9script noclear

if get(g:, 'loaded_litesnip', false)
  finish
endif
g:loaded_litesnip = true

def AsMatcher(str: string): list<string>
  return reverse(split(str, '\zs'))
enddef

def GetLineBeforeCur(): string
  if col('.') <= 1
    return ''
  endif
  return getline('.')[ : col('.') - 2]
enddef

def ExpandSnip(snip: list<string>, dels: number)
  if len(snip) < 1
    return
  endif

  var line = getline('.')
  var oldcur = col('.') - 1
  var before = strpart(line, 0, oldcur - dels)
  var after = strpart(line, oldcur)

  var toset = copy(snip)
  var overridecur = -1
  var overridecurline = 0
  for ii in range(len(toset))
    var idx = stridx(toset[ii], '####')
    if idx != -1
      overridecur = idx
      if overridecurline == 0
        overridecur += oldcur - dels
      endif
      toset[ii] = strpart(toset[ii], 0, idx) .. strpart(toset[ii], idx + 4)
      break
    endif
    overridecurline += 1
  endfor
  overridecurline += line('.')

  toset[0] = before .. toset[0]
  var newcur = len(toset[len(toset) - 1])
  var newcurline = line('.') + len(toset) - 1
  toset[len(toset) - 1] = toset[len(toset) - 1] .. after
  if len(toset) > 1
    append(line('.'), range(len(toset) - 1))
  endif
  setline('.', toset)
  if overridecur != -1
    cursor(overridecurline, overridecur + 1)
  else
    cursor(newcurline, newcur + 1)
  endif
enddef

class SnipTree
  var snips: dict<list<string>>
  var targets: dict<string>
  var the_tree: list<dict<number>>

  def new()
    this.Clear()
  enddef

  def ClearTree()
    this.the_tree = [{}]
    this.targets = {}
  enddef

  def Clear()
    this.ClearTree()
    this.snips = {}
  enddef

  def LoadSnips(path: string)
    var fp = fnamemodify(path, ':p')
    if !isdirectory(fp)
      echoerr 'LiteSnip: LoadSnips: not a dir: ' .. path
      return
    endif
    for fn in glob(fp .. '*.snip', false, true)
      var bare = fnamemodify(fn, ':t:r')
      var text = readfile(fn)
      this.snips[bare] = text
    endfor
  enddef

  def BuildTree()
    this.ClearTree()
    for smatcher in keys(this.snips)
      var matcher = AsMatcher(smatcher)
      var curr = 0
      for it in matcher
        if !has_key(this.the_tree[curr], it)
          add(this.the_tree, {})
          this.the_tree[curr][it] = len(this.the_tree) - 1
        endif
        curr = this.the_tree[curr][it]
      endfor
      this.targets[curr] = smatcher
    endfor
  enddef

  def Match(smatcher: string): number
    var matcher = AsMatcher(smatcher)
    var curr = 0
    for it in matcher
      if has_key(this.the_tree[curr], it)
        curr = this.the_tree[curr][it]
      else
        return curr
      endif
    endfor
    return curr
  enddef

  def AttemptExpand(): bool
    var bc = GetLineBeforeCur()
    var n = this.Match(bc)
    if has_key(this.targets, n)
      ExpandSnip(this.snips[this.targets[n]], len(this.targets[n]))
      return true
    else
      return false
    endif
  enddef
endclass

var byft: dict<SnipTree> = {}

export def g:LiteSnipLoadForFiletype(ft: string)
  var cft = ft == '' ? 'noft' : ft
  if has_key(byft, ft)
    return
  endif
  for it in split(&runtimepath, ',')
    if isdirectory(it)
      var sub = fnamemodify(it, ':p') .. 'litesnips'
      if isdirectory(sub)
        var ftsub = fnamemodify(sub, ':p') .. cft
        if isdirectory(ftsub)
          byft[cft] = SnipTree.new()
          byft[cft].LoadSnips(ftsub)
          byft[cft].BuildTree()
        endif
      endif
    endif
  endfor
enddef

export def g:LiteSnipAttemptExpand(): bool
  var cft = &filetype == '' ? 'noft' : &filetype
  if !has_key(byft, cft)
    return false
  endif
  return byft[cft].AttemptExpand()
enddef

export def g:LiteSnipExpand()
  if !g:LiteSnipAttemptExpand()
    echo "LiteSnip: snippet not found"
  endif
enddef

# defcompile

autocmd BufNewFile,BufReadPost * call g:LiteSnipLoadForFiletype(&filetype)
inoremap <silent> <c-s> <c-\><c-o>:call g:LiteSnipExpand()<cr>


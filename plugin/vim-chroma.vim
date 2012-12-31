"gvim plugin for highlighting hex codes to help with tweaking colors
"Last Change: 2010 Jan 21
"Maintainer: Yuri Feldman <feldman.yuri1@gmail.com>
"License: WTFPL - Do What The Fuck You Want To Public License.
"Email me if you'd like.

" Modified by Luke Gruber <luke.gru@gmail.com> to match 3-digit hex strings
" as well as rgb color values for CSS. Changed name to 'vim-chroma', Yuri
" Feldman's version is called 'HexHighlight'. Same license (WTFPL).
"
" Should highlight all of the following:
" #ffffff
" #fff
" rgb(255, 255, 255)
" rgba(255, 255, 255, 0.5)
"
" To enable, map something to ':call g:chromaHighlight()<CR>'
" ex: map <Leader>h :call g:chromaHighlight()<CR>

if exists("g:loaded_chroma") || &cp
  finish
endif
let g:loaded_chroma = 1

let s:colored = 0
let s:matches = []
let s:lastMatch = -1

let s:hexMatch = '#\(\x\{6}\|\x\{3}\)'
let s:rgbMatch = 'rgba\?(\(\d\{1,3}\)\s*,\s*\(\d\{1,3}\)\s*,\s*\(\d\{1,3}\).*)'
let s:matchPats = [s:hexMatch, s:rgbMatch]

function! g:chromaHighlight()
  if !has("gui_running")
    echo "Highlighting only works with a graphical version of vim"
    return
  elseif s:colored == 1
    echo "Unhighlighting colors"
    for c in s:matches
      call matchdelete(c)
    endfor
    let s:matches = []
    let s:colored = 0
    return
  endif

  echo "Highlighting colors"
  let matchGroup = 4
  let lineNumber = 0

  while lineNumber <= line("$")
    let curLine = getline(lineNumber)
    let searchOccurence = 1
    while s:findMatch(curLine, searchOccurence) !=# -1
      let color = s:extractHexColor()
      exe 'hi hexColor'.matchGroup.' guifg='.color.' guibg='.color
      exe 'let m = matchadd("hexColor'.matchGroup.'", "'.s:lastMatch.'", 25, '.matchGroup.')'
      call add(s:matches, m)
      let matchGroup += 1
      let searchOccurence += 1
    endwhile
    let lineNumber += 1
  endwhile
  let s:colored = 1
endfunction

" Sets s:lastMatch and returns it. -1 if no match, matchstring if there's a match
function! s:findMatch(curLine, searchOccurence)
  for pat in s:matchPats
    let _match = matchstr(a:curLine, pat, 0, a:searchOccurence)
    if empty(_match)
      let s:lastMatch = -1
    else
      let s:lastMatch = _match
      return s:lastMatch
    endif
  endfor
  return s:lastMatch
endfunction

" extracts hex color from s:lastMatch in format: '#000000'
function! s:extractHexColor()
  if strpart(s:lastMatch, 0, 1) == '#'
    return s:lastMatch
  endif
  " it's an rgb match
  let matchList = matchlist(s:lastMatch, s:rgbMatch)
  let hex = '#'
  for i in matchList[1:3]
    let hex .= printf("%X", i)
  endfor
  return hex
endfunction

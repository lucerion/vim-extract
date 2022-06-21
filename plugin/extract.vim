" ==============================================================
" Description:  Extract selection to a new buffer
" Author:       Alexander Skachko <alexander.skachko@gmail.com>
" Homepage:     https://github.com/lucerion/vim-extract
" Version:      1.1.0 (2022-06-21)
" Licence:      BSD-3-Clause
" ==============================================================

if exists('g:loaded_extract') || &compatible || v:version < 700
  finish
endif
let g:loaded_extract = 1

if !exists('g:extract_hidden')
  let g:extract_hidden = 0
endif

func! s:extract(start_line, end_line, count, clear, mods, name) abort
  let l:selection = {
    \ 'start_line': a:start_line,
    \ 'end_line': a:end_line,
    \ 'count': a:count
    \ }

  let l:buffer_options = {
    \ 'name': a:name,
    \ 'clear': a:clear,
    \ 'mods': a:mods
    \ }

  call extract#extract(l:selection, l:buffer_options)
endfunc

comm! -nargs=? -range=0 -bang Extr call s:extract(<line1>, <line2>, <count>, !empty('<bang>'), <q-mods>, <q-args>)

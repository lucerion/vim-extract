" ==============================================================
" Description:  Extract selection to a new buffer
" Author:       Alexander Skachko <alexander.skachko@gmail.com>
" Homepage:     https://github.com/lucerion/vim-extract
" Version:      1.0.0 (2017-09-03)
" Licence:      BSD-3-Clause
" ==============================================================

if exists('g:loaded_extract') || &compatible || v:version < 700
  finish
endif
let g:loaded_extract = 1

if !exists('g:extract_buffer_name')
  let g:extract_buffer_name = '_{filename}'
endif

if !exists('g:extract_hidden')
  let g:extract_hidden = 0
endif

let s:allowed_args = ['-top', '-bottom', '-left', '-right', '-tab']

func! s:autocompletion(A, L, C)
  return s:allowed_args
endfunc

func! s:extract(start_line, end_line, count, clear, ...)
  let l:selection = {
    \ 'start_line': a:start_line,
    \ 'end_line': a:end_line,
    \ 'count': a:count
    \ }
  let l:buffer_options = { 'clear': a:clear }

  let l:name_args_filter = 'index(s:allowed_args, v:val) < 0'
  let l:name_args = filter(copy(a:000), l:name_args_filter)
  if len(l:name_args)
    let l:buffer_options.name = join(l:name_args)
  endif

  let l:position_args_filter = 'index(s:allowed_args, v:val) >= 0'
  let l:position_args = filter(copy(a:000), l:position_args_filter)
  if len(l:position_args)
    let l:position_arg = get(l:position_args, -1)
    let l:buffer_options.position = substitute(l:position_arg, '-', '', 'g')
  endif

  call extract#extract(l:selection, l:buffer_options)
endfunc

comm! -nargs=* -range=0 -bang -complete=customlist,s:autocompletion Extr
  \ call s:extract(<line1>, <line2>, <count>, !empty('<bang>'), <f-args>)

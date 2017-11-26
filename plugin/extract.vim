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

if !exists('g:extract_default_position')
  let g:extract_default_position = 'top'
endif

let s:allowed_position_args = ['-top', '-bottom', '-left', '-right', '-tab']

func! s:autocompletion(input, command_line, cursor_position) abort
  return filter(s:allowed_args, 'v:val =~ a:input')
endfunc

func! s:extract(start_line, end_line, count, clear, ...) abort
  let l:selection = {
    \ 'start_line': a:start_line,
    \ 'end_line': a:end_line,
    \ 'count': a:count
    \ }
  let l:buffer_options = { 'clear': a:clear }

  let l:name_args = filter(copy(a:000), 'index(s:allowed_position_args, v:val) < 0')
  if len(l:name_args)
    let l:buffer_options.name = join(l:name_args)
  endif

  let l:buffer_options.position = g:extract_default_position
  let l:position_args = filter(copy(a:000), 'index(s:allowed_position_args, v:val) >= 0')
  if len(l:position_args)
    let l:buffer_options.position = substitute(l:position_args[-1], '-', '', 'g')
  endif

  call extract#extract(l:selection, l:buffer_options)
endfunc

comm! -nargs=* -range=0 -bang -complete=customlist,s:autocompletion Extr
  \ call s:extract(<line1>, <line2>, <count>, !empty('<bang>'), <f-args>)

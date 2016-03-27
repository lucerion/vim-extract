" ==============================================================
" Description:  Extract selection to a new buffer
" Author:       Alexander Skachko <alexander.skachko@gmail.com>
" Homepage:     https://github.com/lucerion/vim-extract
" Version:      0.3
" Licence:      MIT
" ==============================================================

if exists('g:loaded_extract') || &compatible || (v:version < 700)
  finish
endif

if !exists('g:extract_name')
  let g:extract_name = '_{filename}'
endif

if !exists('g:extract_append')
  let g:extract_append = 1
endif

let s:allowed_args = ['-top', '-bottom', '-left', '-right', '-tab']

func! s:autocompletion(A, L, C)
  return s:allowed_args
endfunc

func! s:extract(start_line, end_line, count, ...)
  let l:name_args_filter = 'index(s:allowed_args, v:val) < 0'
  let l:position_args_filter = 'index(s:allowed_args, v:val) >= 0'
  let l:name_args = filter(copy(a:000), l:name_args_filter)
  let l:position_args = filter(copy(a:000), l:position_args_filter)

  let l:buffer_options = {}
  if len(l:name_args)
    let l:buffer_options['name'] = join(l:name_args)
  endif
  if len(l:position_args)
    let l:position_arg = get(l:position_args, -1)
    let l:buffer_options['position'] = substitute(l:position_arg, '-', '', 'g')
  endif

  call extract#extract(a:start_line, a:end_line, a:count, l:buffer_options)
endfunc

comm! -nargs=* -range=0 -complete=customlist,s:autocompletion Extr
  \ call s:extract(<line1>, <line2>, <count>, <f-args>)

let g:loaded_extract = 1

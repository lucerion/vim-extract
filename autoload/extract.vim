" ==============================================================
" Description:  Extract selection to a new buffer
" Author:       Alexander Skachko <alexander.skachko@gmail.com>
" Homepage:     https://github.com/lucerion/vim-extract
" Version:      0.3
" Licence:      MIT
" ==============================================================

func! extract#extract(start_line, end_line, count, buffer_options)
  let s:buffer_options = a:buffer_options

  if exists('g:loaded_buffr')
    call s:extract(a:start_line, a:end_line, a:count)
  else
    call s:show_error('Please, install vim-buffr')
    return
  endif
endfunc

func! s:extract(start_line, end_line, count)
  let l:selection = getline(a:start_line, a:end_line)

  if a:count
    call s:delete_lines(a:start_line, a:end_line)
  endif
  call s:open_buffer()
  if a:count
    call s:clear_buffer()
    call s:insert_selection(l:selection)
  endif
endfunc

func! s:open_buffer()
  call buffr#open_or_create_buffer(s:buffer_options())
  call s:set_buffer_defaults()
endfunc

func! s:buffer_options()
  let l:default_buffer_options = {
  \  'name': substitute(g:extract_name, '{filename}', expand('%:t'), 'g'),
  \ }

  return extend(l:default_buffer_options, s:buffer_options)
endfunc

func! s:clear_buffer()
  if !g:extract_append
    silent exec 'normal! ggVGd'
  endif
endfunc

func! s:insert_selection(selection)
  let l:last_line = line('$')
  if l:last_line == 1
    call append(0, a:selection)
    silent exec 'normal! Gdd'
  else
    call append(l:last_line, a:selection)
    silent exec 'normal! G'
  endif
endfunc

func! s:delete_lines(start_line, end_line)
  exec a:start_line . ',' . a:end_line . ' delete'
endfunc

func! s:set_buffer_defaults()
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal nobuflisted
  setlocal noswapfile
endfunc

func! s:show_error(message)
  echohl ErrorMsg | echomsg a:message | echohl None
endfunc

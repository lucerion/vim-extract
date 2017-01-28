" ==============================================================
" Description:  Extract selection to a new buffer
" Author:       Alexander Skachko <alexander.skachko@gmail.com>
" Homepage:     https://github.com/lucerion/vim-extract
" Version:      0.4.0 (2016-09-19)
" Licence:      BSD-3-Clause
" ==============================================================

func! extract#extract(selection, buffer_options)
  if exists('g:loaded_buffr')
    call s:extract(a:selection, a:buffer_options)
  else
    call s:show_error('Please, install vim-buffr')
    return
  endif
endfunc

func! s:extract(selection, buffer_options)
  let l:selection = getline(a:selection.start_line, a:selection.end_line)

  if a:selection.count
    call s:delete_lines(a:selection.start_line, a:selection.end_line)
  endif
  call s:open_buffer(a:buffer_options)
  if a:selection.count
    if a:buffer_options.clear
      call s:clear_buffer()
    end
    call s:insert_selection(l:selection)
    if g:extract_hidden
      call s:close_buffer()
    endif
  endif
endfunc

func! s:open_buffer(buffer_options)
  call buffr#open_or_create_buffer(s:buffer_options(a:buffer_options))
  call s:set_buffer_defaults()
endfunc

func! s:close_buffer()
  silent exec 'close'
endfunc

func! s:buffer_options(buffer_options)
  let l:default_buffer_options = {
  \  'name': substitute(g:extract_buffer_name, '{filename}', expand('%:t'), 'g')
  \ }

  return extend(l:default_buffer_options, a:buffer_options)
endfunc

func! s:clear_buffer()
  silent exec 'normal! ggVGd'
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

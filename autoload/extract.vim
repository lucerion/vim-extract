" ==============================================================
" Description:  Extract selection to a new buffer
" Author:       Alexander Skachko <alexander.skachko@gmail.com>
" Homepage:     https://github.com/lucerion/vim-extract
" Version:      0.1
" Licence:      MIT
" ==============================================================

func! extract#extract(start_line, end_line)
  if exists('g:loaded_buffr')
    call s:extract(a:start_line, a:end_line)
  else
    call s:show_error('Please, install vim-buffr')
    return
  endif
endfunc

func! s:extract(start_line, end_line)
  let l:selection = getline(a:start_line, a:end_line)
  let l:in_visual_mode = s:in_visual_mode()

  if l:in_visual_mode && len(l:selection)
    call s:delete_lines(a:start_line, a:end_line)
  endif
  call s:open_buffer()
  if l:in_visual_mode && len(l:selection)
    call s:clear_buffer()
    call s:insert_selection(l:selection)
  endif
endfunc

func! s:open_buffer()
  let l:buffer_name = substitute(g:extract_name, '{filename}', expand('%:t'), 'g')
  call buffr#open_or_create_buffer(l:buffer_name, g:extract_position)
  call s:set_buffer_defaults()
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

func! s:in_visual_mode()
  return visualmode(1) =~? '.*v'
endfunc

func! s:show_error(message)
  echohl ErrorMsg | echomsg a:message | echohl None
endfunc

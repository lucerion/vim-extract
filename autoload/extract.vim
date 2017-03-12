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
  if a:buffer_options.clear
    call s:clear_buffer()
  end
  if a:selection.count
    call s:insert_selection(l:selection)
    if g:extract_hidden
      call s:close_buffer()
    endif
  endif
endfunc

func! s:open_buffer(buffer_options)
  let l:buffer_options = s:buffer_options(a:buffer_options)
  call buffr#open_or_create_buffer(l:buffer_options)
  call s:set_buffer_defaults(l:buffer_options)
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

func! s:set_buffer_defaults(buffer_options)
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal nobuflisted
  setlocal noswapfile

  let s:buffer_options = a:buffer_options
  augroup ExtractLeaveWihoutSave
    autocmd!
    autocmd BufUnload * call s:save_state()
    autocmd BufEnter * call s:load_state()
  augroup END
endfunc

func! s:save_state()
  if expand('<afile>') == s:buffer_options.name && !s:is_buffer_empty()
    exec 'write /tmp/' . s:buffer_options.name
  endif
endfunc

func! s:load_state()
  let l:file = '/tmp/' . s:buffer_options.name
  if expand('<afile>') == s:buffer_options.name && filereadable(l:file)
    if !s:buffer_options.clear
      call append(0, readfile(l:file))
      silent exec 'normal! Gdd'
    endif
    exec '!rm ' . l:file
  endif
endfunc

func! s:is_buffer_empty()
  return line('$') == 1 && getline(1) == '' ? 1 : 0
endfunc

func! s:show_error(message)
  echohl ErrorMsg | echomsg a:message | echohl None
endfunc

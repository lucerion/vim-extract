" ==============================================================
" Description:  Extract selection to a new buffer
" Author:       Alexander Skachko <alexander.skachko@gmail.com>
" Homepage:     https://github.com/lucerion/vim-extract
" Version:      0.1
" Licence:      MIT
" ==============================================================

if exists('g:loaded_extract') || &compatible || (v:version < 700)
  finish
endif

if !exists('g:extract_name')
  let g:extract_name = '_{filename}'
endif

if !exists('g:extract_position')
  let g:extract_position = 'top'
endif

if !exists('g:extract_append')
  let g:extract_append = 1
endif

comm! -nargs=0 -range=0 VExtract call extract#extract(<line1>, <line2>)

let g:loaded_extract = 1

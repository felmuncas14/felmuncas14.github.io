" VimTeX - LaTeX plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

" Inicio de mi configuración
"

let g:vimtex_compiler_latexmk = {
        \ 'aux_dir' : 'build/',
        \ '-xelatex' : '',
        \}
let g:vimtex_compiler_latexmk_engines = {                                      
        \ '_'                : '-xelatex',                                             
        \ 'pdfdvi'           : '-pdfdvi',                                          
        \ 'pdfps'            : '-pdfps',                                           
        \ 'pdflatex'         : '-pdf',                                             
        \ 'luatex'           : '-lualatex',                                        
        \ 'lualatex'         : '-lualatex',                                        
        \ 'xelatex'          : '-xelatex',                                         
        \ 'context (pdftex)' : '-pdf -pdflatex=texexec',                        
        \ 'context (luatex)' : '-pdf -pdflatex=context',                        
        \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',              
        \}
let g:vimtex_view_general_viewer = 'qpdfview'                                    
let g:vimtex_view_general_options                                                
    \ = '--unique @pdf\#src:@tex:@line:@col'

let b:vimtex_main = "principal.tex"     " Esto establece el archivo
" principal por defecto

" Fin de mi configuración
"

if !get(g:, 'vimtex_enabled', 1) | finish | endif
if exists('g:loaded_vimtex') | finish | endif
let g:loaded_vimtex = 1


command! -nargs=* VimtexInverseSearch
      \ call call('vimtex#view#inverse_search_cmd', s:parse_args(<q-args>))


function! s:parse_args(args) abort
  " Examples:
  "   parse_args("foobar")    = [-1, '', 0]
  "   parse_args("5 a.tex")   = [5, 'a.tex', 0]
  "   parse_args("5 'a.tex'") = [5, 'a.tex', 0]
  "   parse_args("5:3 a.tex") = [5, 'a.tex', 3]
  let l:matchlist = matchlist(a:args, '^\s*\(\d\+\)\%(:\(-\?\d\+\)\)\?\s\+\(.*\)')
  if empty(l:matchlist) | return [-1, '', 0] | endif
  let l:lnum = str2nr(l:matchlist[1])
  let l:cnum = str2nr(l:matchlist[2])
  let l:file = l:matchlist[3]

  let l:file = substitute(l:file, '\v^([''"])(.*)\1\s*', '\2', '')
  if empty(l:file) | return [-1, '', 0] | endif

  return [l:lnum, l:file, l:cnum]
endfunction

set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'Valloric/YouCompleteMe' 
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'scrooloose/nerdcommenter' "注释
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'vim-syntastic/syntastic' "代码语法检查

"markdown
Plugin 'iamcco/markdown-preview.vim'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

" 主题
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'


" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required



" custom settings
syntax on
if has('gui_running')
  set background=dark
  colorscheme solarized
else
  colorscheme zenburn
endif
"
set shell=/bin/bash     "shell
set encoding=utf-8      "编码
set rnu                 "显示行号
set mouse=a             "允许使用鼠标
set tabstop=2
set expandtab           "tab
set shiftwidth=4        "tab 
set backspace=2         "使用退格删除
set hlsearch            "设置高亮搜索

" 自动扩展路径到打开文件目录
"set autochdir
autocmd BufEnter * if expand("%:p:h") !~ '^/tmp' | silent! lcd %:p:h | endif
"
" 设置超过80长度提示
set colorcolumn=81
"
" 当光标一段时间保持不动了，就禁用高亮
autocmd cursorhold * set nohlsearch
" 当输入查找命令时，再启用高亮
noremap n :set hlsearch<cr>n
noremap N :set hlsearch<cr>N
noremap / :set hlsearch<cr>/
noremap ? :set hlsearch<cr>?
noremap * *:set hlsearch<cr>

"markdown
"for normal mode
nmap <silent> <F8> <Plug>MarkdownPreview
"for insert mode
imap <silent> <F8> <Plug>MarkdownPreview
"for normal mode
nmap <silent> <F9> <Plug>StopMarkdownPreview
"for insert mode
imap <silent> <F9> <Plug>StopMarkdownPreview

let g:vim_markdown_toc_autofit = 1

set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8


" 自动空格
au BufNewFile,BufRead *.py, *.sh
\ set tabstop=4 |
\ set softtabstop=4 |
\ set shiftwidth=4 |
\ set textwidth=79 |
\ set expandtab |
\ set autoindent |
\ set fileformat=unix

au BufNewFile,BufRead *.js, *.html, *.css, *.yml
\ set tabstop=2 |
\ set expandtab |
\ set softtabstop=2 |
\ set shiftwidth=2

""""""""""""""""""""""
"auto NERDTree
""""""""""""""""""""""
"autocmd vimenter * NERDTree

""""""""""""""""""""""
"
" 关闭NERDTree快捷键
map <leader>t :NERDTreeToggle<CR>
" 显示行号
let NERDTreeShowLineNumbers=1
let NERDTreeAutoCenter=1
" 是否显示隐藏文件
let NERDTreeShowHidden=0
" 设置宽度
let NERDTreeWinSize=26
" 在终端启动vim时，共享NERDTree
let g:nerdtree_tabs_open_on_console_startup=1
" 忽略一下文件的显示
let NERDTreeIgnore=['\.pyc','\~$','\.swp']
" 显示书签列表
let NERDTreeShowBookmarks=1

"""""""""""""""""""""
" NERDTree git 
"""""""""""""""""""""
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }

""""""""""""""""""""""
"Quickly Run
""""""""""""""""""""""
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!time java %<"
    elseif &filetype == 'sh'
        :!time bash %
    elseif &filetype == 'python'
        exec "!time python3.6 %"
    elseif &filetype == 'html'
        exec "!firefox % &"
    elseif &filetype == 'go'
"        exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'mkd'
        exec "!~/.vim/markdown.pl % > %.html &"
        exec "!firefox %.html &"
    endif
endfunc

"statusline  

set laststatus=2                                          "长久显示：2, 不显示：0
set statusline=  
set statusline+=%7*\[%n]                                  "buffernr  
set statusline+=%1*\ %<%F\                                "文件路径  
set statusline+=%2*\ %y\                                  "文件类型  
set statusline+=%3*\ %{''.(&fenc!=''?&fenc:&enc).''}      "编码1  
set statusline+=%3*\ %{(&bomb?\",BOM\":\"\")}\            "编码2  
set statusline+=%4*\ %{&ff}\                              "文件系统(dos/unix..)   
set statusline+=%5*\ %{&spelllang}\%{HighlightSearch()}\  "语言 & 是否高亮，H表示高亮?  
set statusline+=%8*\ %=\ row:%l/%L\ (%03p%%)\             "光标所在行号/总行数 (百分比)  
set statusline+=%9*\ col:%03c\                            "光标所在列  
set statusline+=%0*\ \ %m%r%w\ %P\ \                      "Modified? Read only? Top/bottom  
function! HighlightSearch()  
      if &hls  
          return 'H'  
      else  
          return ''  
      endif  
endfunction  
hi User1 ctermfg=white  ctermbg=darkred  
hi User2 ctermfg=blue  ctermbg=58  
hi User3 ctermfg=white  ctermbg=100  
hi User4 ctermfg=darkred  ctermbg=95  
hi User5 ctermfg=darkred  ctermbg=77  
hi User7 ctermfg=darkred  ctermbg=blue  cterm=bold  
hi User8 ctermfg=231  ctermbg=blue  
"hi User9 ctermfg=#ffffff  ctermbg=#810085  
hi User0 ctermfg=yellow  ctermbg=138

""------------------------------my-vimrc-----------------------------------""
"set rtp+=/usr/lib/python3.7/site-packages/powerline/bindings/vim
""-------------------------------------------------------------------------""
call plug#begin('~/.vim/plugged')
"
Plug 'vim-scripts/indentpython.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdcommenter' "注释
Plug 'jistr/vim-nerdtree-tabs'
"Plug 'vim-syntastic/syntastic' "代码语法检查

"markdown
Plug 'iamcco/markdown-preview.vim'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

" ctags
"Plug 'ludovicchabant/vim-gutentags'

" 动态检查
Plug 'w0rp/ale'

" 修改比较
Plug 'mhinz/vim-signify'

"Emoji
Plug 'junegunn/vim-emoji'

" 主题
Plug 'jnurmine/Zenburn'
Plug 'itchyny/lightline.vim'

call plug#end()
"
""-------------------------power-line--------------------------------------""
"" 指定使用 python3
"let g:powerline_pycmd="py3"
"let g:powerline_pyeval="py3eval"

""-------------------------------------------------------------------------""
""-------------------------------------------------------------------------""
""-----custom settings---------""
"" 使用 \ sudo 或者 :w!! 保存需要root权限的文件
nnoremap <leader>sudo :w !sudo tee %
cmap w!! w !sudo tee %
""
syntax on
if has('gui_running')
  set background=dark
  colorscheme desert
  set guifont=Noto\ Mono\ for\ Powerline\ Regular\ 11
  set lines=49 columns=130
  set sessionoptions+=resize,winpos
else
  colorscheme zenburn
endif
set t_Co=256
"
"" 匹配括号 颜色 brackets-color
hi MatchParen ctermbg=Magenta guibg=tan1
"
set shell=/bin/bash              "shell
set encoding=utf-8               "编辑编码
set fileencoding=utf-8           "保存编码
set fileencodings=utf-8,gbk,gb2312,ucs-bom,gb18030,cp936
set termencoding=utf-8           "终端编码

"" 插入模式不显示相对行号
augroup relative_numbser
    autocmd!
    autocmd InsertEnter * :set norelativenumber
    autocmd InsertLeave * :set relativenumber
augroup END
"
set mouse=a                      "允许使用鼠标
set tabstop=2                    "Tab两个空格
set expandtab                    "tab
set shiftwidth=4                 "tab
set backspace=2                  "使用退格删除
set hlsearch                     "设置高亮搜索
set nu                           "显示相对行号
set rnu                          "显示行号
""-------------------------------------------------------------------------""
""----------------------Syntastic------------------------------------------""
""Syntastic
"let g:syntastic_python_checkers = ['pylint']
"let g:syntastic_python_pylint_post_args="--max-line-length=120"
""-------------------------------------------------------------------------""
" gvim 默认不显示bar
function! ToggleGUICruft()
  if &guioptions=='i'
    exec('set guioptions=imTrL')
  else
    exec('set guioptions=i')
  endif
endfunction

map <F11> <Esc>:call ToggleGUICruft()<cr>

""---by default, hide gui menus----""
set guioptions=i 
"
""----------------------ctag-----------------------------------------------""
" ctag
"set tags=./.tags;,.tags

"" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
"let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
"
"" 所生成的数据文件的名称
"let g:gutentags_ctags_tagfile = '.tags'
"
"" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
"let s:vim_tags = expand('~/.cache/tags')
"let g:gutentags_cache_dir = s:vim_tags
"
"" 配置 ctags 的参数
"let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
"let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
"let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
"
"" 检测 ~/.cache/tags 不存在就新建
"if !isdirectory(s:vim_tags)
"   silent! call mkdir(s:vim_tags, 'p')
"endif
"
""-----------------------ale-动态检查--------------------------------------""
" 始终开启标志列
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
" 自定义error和warning图标
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '>>'
" 在vim自带的状态栏中整合ale
let g:ale_statusline_format = ['✗ %d', '>> %d', '✔ OK']
" 显示Linter名称,出错或警告等相关信息
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" 普通模式下，sp前往上一个错误或警告，sn前往下一个错误或警告
nmap sp <Plug>(ale_previous_wrap)
nmap sn <Plug>(ale_next_wrap)
" <Leader> s 触发/关闭语法检查
nmap <Leader>s :ALEToggle<CR>
" <Leader> d 查看错误或警告的详细信息
nmap <Leader>d :ALEDetail<CR>
let g:ale_python_executable='python3'
let g:ale_python_pylint_use_global=1
""---忽略79宽度提示
let g:ale_python_flake8_options = '--ignore=E501,W291,N806,F405'
""------ale-状态栏-错误提示-函数-----""
function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? 'OK' : printf(
  \   '%dW %dE',
  \   all_non_errors,
  \   all_errors
  \)
endfunction
"
""--------------------自动扩展路径到打开文件目录---------------------------""
"" set autochdir " 这种方法对特殊字符名文件不好
" 打开 /tmp 路径文件时不扩展
autocmd BufEnter * if expand("%:p:h") !~ '^/tmp' | silent! lcd %:p:h | endif
"
""--------当光标一段时间保持不动了，就禁用高亮-----------------------------""
autocmd cursorhold * set nohlsearch
"" 当输入查找命令时，再启用高亮
noremap n :set hlsearch<cr>n
noremap N :set hlsearch<cr>N
noremap / :set hlsearch<cr>/
noremap ? :set hlsearch<cr>?
noremap * *:set hlsearch<cr>

""-------------------markdown----------------------------------------------""
"" 'iamcco/markdown-preview.vim'
"" 'godlygeek/tabular'
"" 'plasticboy/vim-markdown'
"for normal mode
nmap <silent> <F8> <Plug>MarkdownPreview
"for insert mode
imap <silent> <F8> <Plug>MarkdownPreview
"for normal mode
nmap <silent> <F9> <Plug>StopMarkdownPreview
"for insert mode
imap <silent> <F9> <Plug>StopMarkdownPreview

let g:vim_markdown_toc_autofit = 1

"" 
au FileType php setl ofu=phpcomplete "CompletePHP
au FileType ruby,eruby setl ofu=rubycomplete "Complete
au FileType html,xhtml setl ofu=htmlcomplete "CompleteTags
au FileType css setl ofu=csscomplete "CompleteCSS
au FileType python setl ofu=pythoncomplete "Complete

""---------------根据文件名自动空格等设置----------------------------------""
"" tab 使用空格代替
set colorcolumn=81  "" 默认
au BufNewFile,BufRead *.py
\ set tabstop=4 |
\ set softtabstop=4 |
\ set shiftwidth=4 |
\ set textwidth=120 |
\ set expandtab |
\ set autoindent |
\ set fileformat=unix |
\ set colorcolumn=120    "" 120字符宽度提示
"
au BufNewFile,BufRead *.js,*.html,*.css,*.yml,*.sh
\ set tabstop=2 |
\ set softtabstop=2 |
\ set shiftwidth=2 |
\ set expandtab |
\ set softtabstop=2 |
\ set shiftwidth=2 |
\ set fileformat=unix |
\ set colorcolumn=81    "" 80字符宽度提示
"
""----------------------NERDTree-------------------------------------------""
"" 提供文件目录列表功能
" 是目录时自动打开
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 &&
 \ isdirectory(argv()[0]) &&
 \ !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
"
" 打开关闭NERDTree快捷键
map <leader>t :NERDTreeToggle<CR>
" 显示行号
let NERDTreeShowLineNumbers=1
let NERDTreeAutoCenter=1
"" 是否显示隐藏文件
let NERDTreeShowHidden=0
"" 设置宽度
let NERDTreeWinSize=26
" 在终端启动vim时，共享NERDTree。会自动打开
"let g:nerdtree_tabs_open_on_console_startup=1
" 忽略以下文件的显示
let NERDTreeIgnore=['\.pyc','\~$','\.swp']
" 显示书签列表
let NERDTreeShowBookmarks=1

""-------------------NEEDTree-git------------------------------------------""
"" git 文件 needTree 提示状态信息
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

""-------------------quickly-run-------------------------------------------""
"" F5 快速运行文件
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
        exec "!time python3.7 %"
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

""------------------status-line--------------------------------------------""
set laststatus=2                                          "长显：2; 不显：0
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
set statusline+=%10*\ \ %m%r%w\ %P\ \                     "可改? 只读? 顶/底部
set statusline+=%11*\ %{LinterStatus()}                   "ALE 错误数量

function! HighlightSearch()
  if &hls
    return 'H'
  else
    return ''
  endif
endfunction

hi User7  ctermfg=darkred  ctermbg=blue     cterm=bold
hi User1  ctermfg=white    ctermbg=darkred
hi User2  ctermfg=blue     ctermbg=58
hi User3  ctermfg=white    ctermbg=100
hi User4  ctermfg=darkred  ctermbg=95
hi User5  ctermfg=darkred  ctermbg=77
hi User8  ctermfg=231      ctermbg=blue
hi User9  ctermfg=magenta  ctermbg=white
hi User10 ctermfg=yellow   ctermbg=51
hi User11 ctermfg=red      ctermbg=cyan

""-------------------------------------------------------------------------""


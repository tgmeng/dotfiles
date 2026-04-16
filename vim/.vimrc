"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LAZYFABRIC VIMRC
" 基于: ambix/vimrc
"
" 主要区块:
"   - 插件加载
"   - 通用设置
"   - Vim 界面
"   - 文件、备份与撤销
"   - 移动、Tab、窗口与 buffer
"   - Visual 模式相关
"   - 编辑映射
"   - 插件相关设置
"   - 杂项
"   - 辅助函数
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 插件加载 {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 加载同目录下可选的插件列表配置。
let s:vimrc_bundle = expand('<sfile>:p:h') . '/.vimrc.bundles'
if filereadable(s:vimrc_bundle)
    execute 'source ' . fnameescape(s:vimrc_bundle)
endif

" 禁用 netrw，避免打开目录时接管界面。
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

" 如果存在 sensible.vim，则顺手加载一组更合理的默认值。
runtime! plugin/sensible.vim


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 通用设置 {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 使用逗号作为自定义映射的 Leader 键。
let mapleader = ','
let g:mapleader = ','

" 当 Leader 是逗号时，也让 "\" 等价于 ","。
if mapleader ==? ','
    noremap \ ,
endif

" 快速保存与重新载入当前文件。
nmap <leader>w :w!<cr>
nmap <F5> :e!<cr>

" Session 行为。
" 让 Session 文件里的路径更便于跨目录复用。
" set sessionoptions-=curdir
" set sessionoptions+=sesdir
set sessionoptions+=slash
set sessionoptions+=unix
set sessionoptions-=help
set sessionoptions-=buffers

" 全局开启鼠标支持。
set mouse=a

if has("mac") || has("macunix")
    silent! set macmeta
endif

" 为 `:!` 等 shell 集成功能显式指定系统自带 zsh。
set shell=/bin/zsh


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim 界面 {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 光标上下各保留一些可见上下文。
set scrolloff=7

set encoding=utf8
set fileencodings=utf-8,chinese,latin-1

if has("win32")
    set fileencoding=chinese
else
    set fileencoding=utf-8
endif

" 修复菜单乱码。
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" 修复终端消息乱码。
language messages zh_CN.utf-8

" 文件名补全时忽略常见生成文件。
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

" 为消息和命令输出预留两行高度。
set cmdheight=2

" 切换 buffer 时，保留已修改内容而不是强制关闭。
set hidden

" 允许左右移动键和 h/l 跨行移动。
set whichwrap+=<,>,h,l

" 搜索时默认忽略大小写；若模式里有大写则自动区分大小写。
set ignorecase
set smartcase

" 高亮搜索结果。
set hlsearch

" 执行宏和脚本时减少重绘。
set lazyredraw

" 正则默认启用 magic 模式。
set magic

" 短暂跳转到匹配括号。
set showmatch
set matchtime=2

" 关闭提示铃声，并设置一个合适的按键等待时间。
set noerrorbells
set novisualbell
set t_vb=
set timeoutlen=500

" 显示折叠列，并同时开启绝对/相对行号。
set foldcolumn=1
set number relativenumber

" 高亮当前行。
set cursorline
" set cursorcolumn

" 显式定义各模式的光标形状，避免在 tmux 里退回到终端默认光标。
" normal / visual / command-line 使用块状；insert 使用竖线；replace 使用下划线。
if exists('&guicursor')
    set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
endif

" 终端版 Vim 在部分终端 / tmux 组合下不会可靠使用 guicursor；
" 显式设置 DECSCUSR 序列作为后备，确保普通模式为块状、插入模式为竖线。
if !has('gui_running')
    let &t_EI = "\e[2 q"
    let &t_SI = "\e[6 q"
    let &t_SR = "\e[4 q"
endif

" 用可见符号显示 Tab 和行尾。
set listchars=tab:▸\ ,eol:¬

""""""""""""""""""""""""""""""
" 文本、缩进与换行 {{{2
""""""""""""""""""""""""""""""
" 用空格替代 Tab。
set expandtab

" 使用 Tab 时启用更智能的行为。
" set smarttab

" 统一四个空格缩进。
set shiftwidth=4
set tabstop=4

" 优先采用较宽的文本宽度，并让长行按单词边界换行。
set linebreak
set textwidth=500

set autoindent
set smartindent
set wrap

""""""""""""""""""""""""""""""
" 颜色与字体 {{{2
""""""""""""""""""""""""""""""
try
    if has('termguicolors')
        set termguicolors
    endif
    colorscheme catppuccin_mocha
catch
endtry

set background=dark

" GUI Vim / MacVim 的额外设置。
if has("gui_running")
    " 去掉工具栏和菜单栏的冗余元素。
    set guioptions-=T
    set guioptions-=m
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
    set lines=50 columns=150

    if has('win32')
        set guifont=Consolas:h10.5
    elseif has('gui_macvim')
        set guifont=Hack\ Nerd\ Font:h12
    else
        set guifont=Monospace\ 12
    endif
endif

" 优先使用 Unix 换行，同时兼容 DOS 和旧版 Mac 文件。
set fileformats=unix,dos,mac

""""""""""""""""""""""""""""""
" 状态栏 {{{2
""""""""""""""""""""""""""""""
" 状态栏格式可在这里继续补充。


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 文件、备份与撤销 {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("vms")
    " 在 VMS 上使用系统版本机制，不使用 Vim 备份文件。
    set nobackup
    set nowritebackup
    set noswapfile
else
    " 把持久备份统一放到 ~/vimtmp。
    " `backup` 会在保存后保留备份文件。
    " `nowritebackup` 会关闭“写入过程中的临时备份”。
    let s:vimtmp = expand('~/vimtmp')

    if !isdirectory(s:vimtmp)
        call mkdir(s:vimtmp, 'p', 0700)
    endif

    if isdirectory(s:vimtmp) && filewritable(s:vimtmp) == 2
        set backup
        set nowritebackup
        let &backupdir = s:vimtmp . '//'
        let &directory = s:vimtmp . '//'
    endif
endif

augroup SetFiletypeAs
    autocmd!
" 为常见扩展名指定 filetype。
    autocmd BufNewFile,BufReadPost *.md set filetype=markdown
    autocmd BufNewFile,BufReadPost *.ftl set filetype=html.ftl
augroup END

augroup Other
    autocmd!
    " 保存文件前自动补齐不存在的父目录。
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 移动、Tab、窗口与 buffer {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 在长行里移动时按屏幕换行后的视觉行处理。
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" 用空格触发 `/` 搜索。
map <space> /

" 用 `<leader><space>` 清除搜索高亮。
" map <silent> <leader><cr> :noh<cr>
map <silent> <leader><space> :noh<cr>

" 更方便地在窗口间移动。
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" 快速最大化或均分分屏。
nnoremap <C-w>M <C-w>\|<C-w>_
nnoremap <C-w>m <C-w>=

" 快速退出当前窗口。
map <leader>q :q<CR>

" 关闭当前 buffer。
map <leader>bd :Bclose<cr>:q<cr>

" 关闭所有 buffer。
map <leader>ba :bufdo bd<cr>

" 常用 Tab 管理映射。
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 

map <leader>th :execute "tabmove" tabpagenr() - 2 <CR>
map <leader>tl :execute "tabmove" tabpagenr() + 1<CR>

" 在 Tab 之间切换。
nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT
map <leader>l gt
map <leader>h gT

" 记录上一个 Tab，方便快速来回切换。
let g:lasttab = 1
nmap <Leader>t<leader> :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" 以当前文件所在目录为起点新开一个 Tab。
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" 把当前工作目录切到当前文件所在目录。
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" 指定 buffer 切换行为。
try
    set switchbuf=useopen,usetab,newtab
    set stal=2
catch
endtry

" 打开文件时回到上次编辑位置。
" autocmd BufReadPost *
"      \ if line("'\"") > 0 && line("'\"") <= line("$") |
"      \   exe "normal! g`\"" |
"      \ endif
" 退出时记录打开过的 buffer 信息。
" set viminfo^=%


""""""""""""""""""""""""""""""
" Visual 模式相关 {{{1
""""""""""""""""""""""""""""""
" 在 Visual 模式下用 `*` / `#` 搜索当前选区。
" 思路来自 Michael Naumann。
xnoremap * :<C-u>call <SID>VisualSelection('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VisualSelection('?')<CR>?<C-R>=@/<CR><CR>

" Visual 模式下的复制与粘贴。
vnoremap <leader>d "+d
vnoremap <leader>y "+y
vnoremap <leader>p "+p


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 编辑映射 {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 把 `0` 重映射为跳到行首第一个 non-blank 字符。
map 0 ^

" 清除高亮并刷新屏幕。
nnoremap <M-l> :nohl<CR><C-L>

" 普通模式下的复制与粘贴。
nnoremap <leader>d "+d
nnoremap <leader>y "+y
nnoremap <leader>p "+]p
nnoremap <leader>P "+[p

" 用 Alt+j / Alt+k 快速移动当前行或选区。
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has('win32')
    " 在 Windows 中打开资源管理器并选中当前文件。
    nnoremap <F11> :<C-U>!start explorer /select,%:p<CR>
endif

" 让插入模式下的 `<C-W>` 拥有更合理的撤销边界。
" inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" 在命令行模式下，`%%` 展开为当前文件所在目录。
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
map <leader>ew :edit %%
map <leader>es :split %%
map <leader>ev :vsplit %%
map <leader>et :tabedit %%

" 重复上一次替换命令时保留上次的参数标记。
nnoremap & :&&<CR>
xnoremap & :&&<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 插件相关设置 {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-grepper
if executable('rg')
    let g:grepper = { 'tools': ['rg', 'git', 'ag'] }
    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
elseif executable('ag')
    let g:grepper = { 'tools': ['ag', 'git'] }
else
    let g:grepper = { 'tools': ['git'] }
endif

nnoremap <leader>g :Grepper<Space>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fb :Buffers<CR>
if executable('rg')
    nnoremap <leader>fr :Rg<Space>
endif

" UltiSnips
let g:UltiSnipsExpandTrigger="<leader><tab>"
" `:UltiSnipsEdit` 使用垂直分屏打开。
let g:UltiSnipsEditSplit="vertical"

" Fern
let g:fern#default_hidden = 1

nnoremap <leader>nn :Fern . -drawer -toggle -width=35<CR>
nnoremap <leader>nb :Fern ~ -drawer -toggle -width=35<CR>
nnoremap <leader>nf :Fern . -drawer -toggle -reveal=% -width=35<CR>

" Emmet
let g:user_emmet_leader_key = '<C-E>'

" Auto-pairs
let g:AutoPairsMapSpace = 0

" Git-Gutter
let g:gitgutter_map_keys = 0

nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk

" vim-expand-region
" 扩展默认文本对象（注意：启用前先删掉字典里的说明注释）
" call expand_region#custom_text_objects({
"       \ "\/\\n\\n\<CR>": 1, " 也支持移动命令；这里的例子会搜索一个空行
"       \ 'a]' :1, " 支持嵌套的方括号 around 文本对象
"       \ 'ab' :1, " 支持嵌套的圆括号 around 文本对象
"       \ 'aB' :1, " 支持嵌套的大括号 around 文本对象
"       \ 'ii' :0, " `inside indent`，需要额外安装 vim-textobj-indent
"       \ 'ai' :0, " `around indent`，需要额外安装 vim-textobj-indent
"       \ })

" lightline
set laststatus=2
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'catppuccin_mocha',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 杂项 {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 切换 paste 模式。
map <leader>PP :setlocal paste!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 辅助函数 {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 

function! s:VisualSelection(cmdtype)
  let temp = @"
  normal! vgv"sy
  let @/ = '\V' . substitute(escape(@", a:cmdtype.'\'), '\n', '\\n', 'g')
  let @" = temp
endfunction

" 删除 buffer 时尽量不要把当前窗口一起关掉。
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

" 保存文件时，如果目录不存在就自动创建。
function! s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction

" `:LogMessage` 命令。
command! -nargs=+ -complete=command LogMessage call LogMessage(<q-args>)
" 把命令输出放到新的 Tab。
function! LogMessage(cmd)
    redir => message
    silent execute a:cmd
    redir END
    if empty(message)
        echoerr "no output"
    else
        " 如果更喜欢分屏，可以把下面的 `tabnew` 改成 `new`。
        tabnew
        setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
        silent put=message
    endif
endfunction

" vim: fdm=marker

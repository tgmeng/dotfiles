"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MY VIMRC
" Based On: 
"       ambix/vimrc
"
" Sections:
"       Bundles
"       General
"       VIM user interface
"           - Text, tab and indent related
"           - Colors and Fonts
"           - Status line
"       Plugin related settings
"       Files, backups and undo
"       Moving around, tabs, windows and buffers
"       Visual mode related
"       Editing mappings
"       Plugin related mappings
"       Misc
"       Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Bundles {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:vimrc_bundle = expand('<sfile>:p:h') . '/.vimrc.bundles' 
if filereadable(s:vimrc_bundle)
    execute 'source ' . fnameescape(s:vimrc_bundle)
endif

" sensible.vim
runtime! plugin/sensible.vim


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" leader eq ',', then noremap \ to ,
if mapleader ==? ','
    noremap \ ,
endif

" Fast saving
nmap <leader>w :w!<cr>

" Reload
nmap <F5> :e!<cr>

" :W sudo saves the file 
" (useful for handling the permission-denied error)
command! W w !sudo tee % > /dev/null

" Session
" Path is relative to the session file
" set sessionoptions-=curdir
" set sessionoptions+=sesdir
" Unix / & \n
set sessionoptions+=slash
set sessionoptions+=unix

set mouse=a

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM user interface {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

set encoding=utf8
set fileencodings=utf-8,chinese,latin-1

if has("win32")
    set fileencoding=chinese
else
    set fileencoding=utf-8
endif

" Menu garbled characters 
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Console garbled characters
language messages zh_CN.utf-8

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch 
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Add a bit extra margin to the left
set foldcolumn=1

" set line number 
set number
" Highlight current line
set cursorline
" set cursorcolumn

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

""""""""""""""""""""""""""""""
" Text, tab and indent related {{{2
""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs
" set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

""""""""""""""""""""""""""""""
" Colors and Fonts {{{2
""""""""""""""""""""""""""""""
try
    " colorscheme desert
    " colorscheme solarized
    colorscheme molokai
catch
endtry

set background=dark

" Set extra options when running in GUI mode
if has("gui_running")
    " Remove toolbar
    set guioptions-=T
    " Remove menu bar
    set guioptions-=m
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
    set lines=50 columns=150

    if has('win32')
        set guifont=Consolas:h10.5
    elseif has('gui_macvim')
        set guifont=Monaco:h12
    else
        set guifont=Monospace\ 12
    endif
endif

" Use Unix as the standard file type
set ffs=unix,dos,mac

""""""""""""""""""""""""""""""
" Status line {{{2
""""""""""""""""""""""""""""""
" Format the status line below


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin related settings {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tags
let g:tagbar_ctags_bin = 'D:\tools\ctags58\ctags.exe'

" ctrlp custon ignore
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store'
let g:ctrlp_working_path_mode = 'w'

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" YCM
let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']


" NERDTree
augroup NERDTree
    autocmd! 
    " open a NERDTree automatically when vim starts up
    " autocmd vimenter * NERDTree

    " open a NERDTree automatically when vim starts up if no files were specified
    " autocmd StdinReadPre * let s:std_in=1
    " autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

    " close vim if the only window left open is a NERDTree
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

" NERDCommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
" let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Emmet
let g:user_emmet_leader_key = '<C-E>'

" Syntastic
let g:syntastic_mode_map = {'mode': 'passive'}
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Vim-javascript
let g:javascript_enable_domhtmlcss = 1
let g:javascript_ignore_javaScriptdoc = 1

" Vim-jsx
let g:jsx_ext_required = 0

" Auto-pairs
let g:AutoPairsMapSpace = 0

" Git-Gutter
let g:gitgutter_map_keys = 0

" Vim-expand-region
" Extend the global default (NOTE: Remove comments in dictionary before sourcing)
" call expand_region#custom_text_objects({
"       \ "\/\\n\\n\<CR>": 1, " Motions are supported as well. Here's a search motion that finds a blank line
"       \ 'a]' :1, " Support nesting of 'around' brackets
"       \ 'ab' :1, " Support nesting of 'around' parentheses
"       \ 'aB' :1, " Support nesting of 'around' braces
"       \ 'ii' :0, " 'inside indent'. Available through https://github.com/kana/vim-textobj-indent
"       \ 'ai' :0, " 'around indent'. Available through https://github.com/kana/vim-textobj-indent
"       \ })

" Yankstack
" let g:yankstack_map_keys = 0
" nmap <leader>o <Plug>yankstack_substitute_older_paste
" nmap <leader>O <Plug>yankstack_substitute_newer_paste

" Vim-session
let g:session_autoload = 'no'
let g:session_autosave = 'prompt'

" augroup HardMode
"     autocmd!
"     autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()
" augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Files, backups and undo {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("vms")
    " do not keep a backup file, use versions instead
    set nobackup
    set nowritebackup
    set noswapfile
else
    " keep a backup file
    let s:vimtmp=$HOME.'/vimtmp'

    if (!filewritable(s:vimtmp))
        silent execute '!mkdir "'.s:vimtmp.'"'
    endif

    set backup
    set nowritebackup

    let &backupdir=s:vimtmp.'//'
    let &directory=s:vimtmp.'//'
endif

augroup SetFiletypeAs
    autocmd!
    " .md to Markdown 
    autocmd BufNewFile,BufReadPost *.md set filetype=markdown
    " .ftl to HTML
    autocmd BufNewFile,BufReadPost *.ftl set filetype=html.ftl
    " .rgl to HTML
    autocmd BufNewFile,BufReadPost *.rgl set filetype=html
    " .mcss to CSS
    autocmd BufNewFile,BufReadPost *.mcss set filetype=css
    " .vue
    autocmd BufRead,BufNewFile *.vue set filetype=vue.javascript.html.css syntax=html
augroup END

augroup Other
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Moving around, tabs, windows and buffers {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Disable highlight when <leader><cr> is pressed
" map <silent> <leader><cr> :noh<cr>
map <silent> <leader><space> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Maximize splits
nnoremap <C-w>M <C-w>\|<C-w>_
nnoremap <C-w>m <C-w>=

" :q
map <leader>q :q<CR>

" Close the current buffer
map <leader>bd :Bclose<cr>:q<cr>

" Close all the buffers
map <leader>ba :bufdo bd<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 

map <leader>th :execute "tabmove" tabpagenr() - 2 <CR>
map <leader>tl :execute "tabmove" tabpagenr() + 1<CR>

" Move between tabs
nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT
map <leader>l gt
map <leader>h gT

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>t<leader> :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers 
try
    set switchbuf=useopen,usetab,newtab
    set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
" autocmd BufReadPost *
"      \ if line("'\"") > 0 && line("'\"") <= line("$") |
"      \   exe "normal! g`\"" |
"      \ endif
" Remember info about open buffers on close
" set viminfo^=%


""""""""""""""""""""""""""""""
" Visual mode related {{{1
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

" copy and paste
vnoremap <leader>d "+d
vnoremap <leader>y "+y
vnoremap <leader>p "+p


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing mappings {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Redraw & clear highlight
nnoremap <M-l> :nohl<CR><C-L>

" copy and paste
nnoremap <leader>d "+d
nnoremap <leader>y "+y
nnoremap <leader>p "+]p
nnoremap <leader>P "+[p

" Vimrc
nnoremap <leader>emv :tabedit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" JS-Beautify
map <leader>f :%!js-beautify -j -q -B -f -

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has('win32')
    " On windows start a explorer and select current file
    nnoremap <F11> :<C-U>!start explorer /select,%:p<CR>
endif

if has("mac") || has("macunix")
    nmap <D-j> <M-j>
    nmap <D-k> <M-k>
    vmap <D-j> <M-j>
    vmap <D-k> <M-k>
endif

" Insert mode, <C-W> & <C-U> undo
" inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" %% expands current file's directory path
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
map <leader>ew :edit %%
map <leader>es :split %%
map <leader>ev :vsplit %%
map <leader>et :tabedit %%

" & saves last flag
nnoremap & :&&<CR>
xnoremap & :&&<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin related mappings {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree plugin
nnoremap <leader>nn :NERDTreeToggle<cr>
nnoremap <leader>nb :NERDTreeFromBookmark 
nnoremap <leader>nf :NERDTreeFind<cr>

" Vim-session plugin
nnoremap <leader>so :OpenSession!<CR>
nnoremap <leader>ss :SaveSession<CR>

" Syntastic
nnoremap <leader>sc :SyntasticCheck<CR>
nnoremap <leader>sr :SyntasticReset<CR>

" Git-Gutter
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk

" ------------------------------------------------------------
" Ag searching and cope displaying
"    requires ag.vim - it's much better than vimgrep/grep
" When you press gv you Ag after the selected text
" vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Open Ag and put the cursor in the right position
" map <leader>g :Ag 
map <leader>g :Ack

" When you press <leader>r you can search and replace the selected text
" vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with Ag, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
" map <leader>cc :botright cope<cr>
" map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
" map <leader>n :cn<cr>
" map <leader>p :cp<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
" noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
" map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
" map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>PP :setlocal paste!<cr>

" Edit host
if has("win16") || has("win32")
    nmap <leader>eh :tabedit C:/Windows/System32/drivers/etc/hosts<cr>
endif

" :LogMessage
command! -nargs=+ -complete=command LogMessage call LogMessage(<q-args>)``


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Helper functions {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("Ag \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Don't close window, when deleting a buffer
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

" Make VIM remember position in file after reopen
" if has("autocmd")
"   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" mkdirp if path not exist when saving file
function! s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction

" Put command result to a new tab
function! LogMessage(cmd)
    redir => message
    silent execute a:cmd
    redir END
    if empty(message)
        echoerr "no output"
    else
        " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
        tabnew
        setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
        silent put=message
    endif
endfunction

" vim: fdm=marker

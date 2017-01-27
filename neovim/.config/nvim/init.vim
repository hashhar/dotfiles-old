"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM SPECIFIC OPTIONS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !has('nvim')
"""""""""""""""""""""""""""""""""""""""
" Be iMproved
set nocompatible

" Sets how many lines of history VIM has to remember
set history=10000

" Autoread a file if it was changed outside of VIM
set autoread

" Detect filetype and activate plugins and indents accordingly
filetype plugin indent on

" Autoindent
set autoindent
set smarttab

" Enable syntax highlighting
syntax enable

" Make backspace act like it should
set backspace=indent,eol,start

" Make <C-A> and <C-X> only consider single alphabets, decimal and hexadecimal numbers
set nrformats-=octal

" Highlight search results
set hlsearch

" Make search act like search in modern browsers
set incsearch

" Show as much as possible of the last line in a window instead of truncating
set display+=lastline
set laststatus=2

" Remove comment leading character when joining two comment lines
set formatoptions=jcroql

" Maximum number of tabs opened by -p command line args or :tab all
set tabpagemax=50

"""""""""""""""""""""""""""""""""""""""
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! <SID>GetGuiAttr(id)
  let l:gui = []
  if synIDattr(a:id, "bold", "gui")
    call add(l:gui, "bold")
  endif
  if synIDattr(a:id, "italic", "gui")
    call add(l:gui, "italic")
  endif
  if synIDattr(a:id, "reverse", "gui")
    call add(l:gui, "reverse")
  endif
  if synIDattr(a:id, "standout", "gui")
    call add(l:gui, "standout")
  endif
  if synIDattr(a:id, "undercurl", "gui")
    call add(l:gui, "undercurl")
  endif
  if synIDattr(a:id, "underline", "gui")
    call add(l:gui, "underline")
  endif
  return join(l:gui, ",")
endfunction

function! <SID>NormalizeColor(color_name)
  let l:color_name = a:color_name
  let l:normal_id = synIDtrans(hlID("Normal"))
  let l:normal_guibg = synIDattr(l:normal_id, "bg", "gui")
  let l:normal_guifg = synIDattr(l:normal_id, "fg", "gui")
  if l:color_name ==? "background" || l:color_name ==? "bg"
    let l:color_name = empty(l:normal_guibg) ? "bg" : l:normal_guibg
  elseif l:color_name ==? "fg" || l:color_name ==? "foreground"
    let l:color_name = empty(l:normal_guifg) ? "fg" : l:normal_guifg
  endif
  return l:color_name
endfunction

function! <SID>GetGuibgAttr(id)
  let l:guibg = synIDattr(a:id, "bg", "gui")
  return <SID>NormalizeColor(l:guibg)
endfunction

function! <SID>GetGuifgAttr(id)
  let l:guifg = synIDattr(a:id, "fg", "gui")
  return <SID>NormalizeColor(l:guifg)
endfunction

function! <SID>GetGuispAttr(id)
  let l:guisp = synIDattr(a:id, "sp", "gui")
  return <SID>NormalizeColor(l:guisp)
endfunction

function! <SID>FixHlGroup(id)
  let l:gui = <SID>GetGuiAttr(a:id)
  let l:guibg = <SID>GetGuibgAttr(a:id)
  let l:guifg = <SID>GetGuifgAttr(a:id)
  let l:guisp = <SID>GetGuispAttr(a:id)
  let l:name = synIDattr(a:id, "name")
  if !empty(l:guisp) && empty(l:guibg + l:guifg)
    let l:guifg = l:guisp
  endif
  execute "highlight " . l:name .
        \ " cterm=" . (empty(l:gui) ? "NONE" : l:gui) .
        \ " guifg=" . (empty(l:guifg) ? "NONE" : l:guifg) .
        \ " guibg=" . (empty(l:guibg) ? "NONE" : l:guibg)
endfunction

function! <SID>FixColorScheme()
  if has("gui_running") || !exists("&termguicolors") || !&termguicolors
    return
  endif
  let l:id = 0
  while 1
    let l:id = l:id + 1
    if synIDtrans(l:id) == 0
      break
    elseif synIDattr(l:id, "name") ==? "Normal"
      continue
    elseif synIDtrans(l:id) != l:id
      continue
    endif
    call <SID>FixHlGroup(l:id)
  endwhile
endfunction

autocmd ColorScheme * call <SID>FixColorScheme()

" UTF-8 FTW
if &encoding != "utf-8"
  set encoding=utf8
endif

" Full colour baby (Comment this to allow rainbow parentheses to work)
"set termguicolors

" Set mapleader for extra possible key combinations
let mapleader = ","
let g:mapleader = ","

" Quick save keymap
nnoremap <Leader>w :w!<CR>

" Sudo save a file
noremap <Leader>w!! :SudoWrite
" Use :W for sudo saving a file (if you don't have vim-eunuch plugin installed)
"cnoremap w!! w !sudo tee > /dev/null %

" Persistent backup and recovery files
set backup
set backupdir   =$HOME/.config/nvim/files/backup/
set backupext   =-vimbackup
set backupskip  =
set directory   =$HOME/.config/nvim/files/swap//
set updatecount =100
set undofile
set undodir     =$HOME/.config/nvim/files/undo/

if exists('*mkdir') && !isdirectory($HOME.'/.config/nvim/files')
  call mkdir($HOME.'/.config/nvim/files')
  call mkdir($HOME.'/.config/nvim/files/backup')
  call mkdir($HOME.'/.config/nvim/files/swap')
  call mkdir($HOME.'/.config/nvim/files/undo')
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM User Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Change cursor shape based on mode
if has('nvim')
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
endif

" Line numbers
set relativenumber
set number
set cursorline
noremap <F10> :call ToggleNumbers()<CR>

" Smarter cursorline
autocmd WinEnter * set cursorline
autocmd WinLeave * set nocursorline
autocmd InsertEnter * set nocursorline
autocmd InsertLeave * set cursorline

" By default wrap when a word ends
set wrap
set linebreak
" Toggle wrapping styles
noremap <F9> :call ToggleWrap()<CR>

" Show visual markers
set listchars=tab:»\ ,trail:·,extends:❯,precedes:❮,nbsp:·
set list
",eol:↲ or ¬ , tab: »·
set showbreak=↪\ \ \ 
set cpoptions+=n

" Show at least 1 line above and below the cursor when scrolling
" Set it to a very large value to keep cursor in middle of the screen
"set scrolloff=1
"set sidescrolloff=1
" Characters to scroll horiontally at a time when you move past the edge of a window
"set sidescroll=1

" Turn on wildmenu and make it smartcase
set wildmenu
set wildignorecase

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
set wildignore+=.git\*,.hg\*,.svn\*
endif

" Show typed commands
set showcmd

" Always show current position
set ruler

" Height of command bar
set cmdheight=1

" Yank and paste from clipboard
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y
nnoremap <Leader>yy "+yy
nnoremap <Leader>p "+p

" Ignore case only when all letters are lowercase
set smartcase
set ignorecase

" Redraw and resync everything
nnoremap <Leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><C-l>

" Show matching brackets when cursor is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set matchtime=1

" Don't enable folding by default
set nofoldenable

" No sound on erros
set noerrorbells
set novisualbell

" Toggle paste mode
set pastetoggle=<F2>

" Start search on current word under the cursor
nnoremap <Leader>/ /<CR>

" Start reverse search on current word under the cursor
nnoremap <Leader>? ?<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => GUI Options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make GVIM act like VIM
" Remove scrollbars
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
set guioptions-=b
set guioptions-=T " Remove the toolbar
set guioptions-=m " Remove menubar
set guioptions-=M " Don't even source the menubar
set guioptions+=c " Use console popups for simple choices
set guifont=Terminus\ 10 " Great fixed width bitmap font
set mouse-=a " Disabe mouse

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" I like tabs to set indentation levels and spaces for alignment
set noexpandtab " Insert tabs
" 1 tab == 4 spaces
set tabstop=4
set shiftwidth=4

" Autorun YAIFA and set indent settings after reading a file
autocmd BufWinEnter * if &l:buftype !=# 'help' | :YAIFAMagic | endif

" Only add 1 space after punctuation when joining lines
set nojoinspaces

" For autoindent, use same spaces/tabs mix as previous line, even if tabs/spaces are mixed. Helps for docblock, where the block comments have a space after the indent to align asterisks
set copyindent

" Try not to change the indent structure on "<<" and ">>" commands. I.e. keep block comments aligned with space if there is a space there.
set preserveindent

" Break line into two lines if it crosses 120 characters (0 disables it)
set textwidth=0

" Don't yank to default register when changing something
nnoremap c "xc
xnoremap c "xc

" Be smart about lists by detecting various types of lists
setlocal formatlistpat=^\\s*[\\[({]\\\?\\([0-9]\\+\\\|[iIvVxXlLcCdDmM]\\+\\\|[a-zA-Z]\\)[\\]:.)}]\\s\\+\\\|^\\s*[-+o*]\\s\\+
set formatoptions+=n

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows, buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Don't lose visual selection after shifting
xnoremap < <gv
xnoremap > >gv

" Automatically resize panes on resize
autocmd VimResized * :wincmd =

" Open new split panes to right, which feels more natural
set splitright

" Set winminheight/width to 0 to use <C-W>_ and <C-W>| optimally
set winminheight=0
set winminwidth=0

" Cylces through splits using a double press of enter in normal mode
nmap <Leader><CR> <C-w><C-w>

" Smart way to move between windows
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

" Switch between current and last buffer
nnoremap <Backspace> <C-^>

" Scroll the viewport faster
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>

" Moving up and down work as you would expect (Currently set to toggle with word wrap option
nmap  <expr> <Leader>b  TYToggleBreakMove()
let g:gmove = "yes"
onoremap <silent> <expr> j ScreenMovement("j")
onoremap <silent> <expr> k ScreenMovement("k")
"onoremap <silent> <expr> <Down> ScreenMovement("<Down>")
"onoremap <silent> <expr> <Up> ScreenMovement("<Up>")
onoremap <silent> <expr> 0 ScreenMovement("0")
onoremap <silent> <expr> ^ ScreenMovement("^")
onoremap <silent> <expr> $ ScreenMovement("$")
nnoremap <silent> <expr> j ScreenMovement("j")
nnoremap <silent> <expr> k ScreenMovement("k")
"nnoremap <silent> <expr> <Down> ScreenMovement("<Down>")
"nnoremap <silent> <expr> <Up> ScreenMovement("<Up>")
nnoremap <silent> <expr> 0 ScreenMovement("0")
nnoremap <silent> <expr> ^ ScreenMovement("^")
nnoremap <silent> <expr> $ ScreenMovement("$")
vnoremap <silent> <expr> j ScreenMovement("j")
vnoremap <silent> <expr> k ScreenMovement("k")
"vnoremap <silent> <expr> <Down> ScreenMovement("<Down>")
"vnoremap <silent> <expr> <Up> ScreenMovement("<Up>")
vnoremap <silent> <expr> 0 ScreenMovement("0")
vnoremap <silent> <expr> ^ ScreenMovement("^")
vnoremap <silent> <expr> $ ScreenMovement("$")
vnoremap <silent> <expr> j ScreenMovement("j")

" Close the current buffer
noremap <Leader>bd :bdelete<CR>:tabclose<CR>:tabprevious
" Close all the buffers
noremap <Leader>ba  %bdelete<CR>

" Useful mappings for managing tabs
noremap <Leader>tn :tabnew<CR>
noremap <Leader>to :tabonly<CR>
noremap <Leader>tc :tabclose<CR>
noremap <Leader>tm :tabmove
noremap <Leader>t<Leader> :tabnext

" Let '<Leader>tl' toggle between this and the last accessed tab
let g:lasttab = 1
nnoremap <Leader>tl :execute "tabnext ".g:lasttab<CR>
autocmd TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
noremap <Leader>te :tabedit <C-r>=expand("%:p:h")<CR>/

" Specify the behavior when switching between buffers and show tabline only if more than one tab is present
try
  set switchbuf=useopen,usetab,newtab
  set showtabline=1
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   execute "normal! g`\"" |
  \ endif

" Autoreload certain filetypes
"autocmd BufWritePost $MYVIMRC source $MYVIMRC
"autocmd BufWritePost ~/.Xresources call system('xrdb ~/.Xresources')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CScope
nnoremap <buffer> <Leader>cs :cscope find s  <C-r>=expand('<cword>')<cr><cr>
nnoremap <buffer> <Leader>cg :cscope find g  <C-r>=expand('<cword>')<cr><cr>
nnoremap <buffer> <Leader>cc :cscope find c  <C-r>=expand('<cword>')<cr><cr>
nnoremap <buffer> <Leader>ct :cscope find t  <C-r>=expand('<cword>')<cr><cr>
nnoremap <buffer> <Leader>ce :cscope find e  <C-r>=expand('<cword>')<cr><cr>
nnoremap <buffer> <Leader>cf :cscope find f  <C-r>=expand('<cfile>')<cr><cr>
nnoremap <buffer> <Leader>ci :cscope find i ^<C-r>=expand('<cfile>')<cr>$<cr>
nnoremap <buffer> <Leader>cd :cscope find d  <C-r>=expand('<cword>')<cr><cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ss will toggle and untoggle spell checking
noremap <Leader>ss :setlocal spell!<CR>

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Next misspelled word
noremap <Leader>sn ]s
" Previous misspelled word
noremap <Leader>sp [s
" Add word under cursor to dictionary
noremap <Leader>sa zg
" Suggest the correction
noremap <Leader>s? z=

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Quickly open a buffer for scribble
noremap <Leader>q :e ~/buffer<CR>

" Quickly open a markdown buffer for scribble
noremap <Leader>x :e ~/buffer.md<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map ; to :
"noremap : ;
"noremap ; :

" Smart mappings on the command line
cnoremap $h e ~/
cnoremap $d e ~/Desktop/
cnoremap $j e ./
cnoremap $c e <C-\>eCurrentFileDir("e")<cr>

" $q is super useful when browsing on the command line. It deletes everything until the last slash
cnoremap $q <C-\>eDeleteTillSlash()<cr>

" Bash like keys for the command line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>

" Up and down by default try to match commands that match the text you've already entered. We want to extend the behaviour to <C-N> and <C-P>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
func! DeleteTillSlash()
  let g:cmd = getcmdline()

  if has("win16") || has("win32")
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
  else
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
  endif

  if g:cmd == g:cmd_edited
    if has("win16") || has("win32")
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
    else
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
    endif
  endif

  return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
  return a:cmd . " " . expand("%:p:h") . "/"
endfunc

" :DiffOrig to show changes made in buffer to file on disk
command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
  \ | wincmd p | diffthis

" Toggle line wrapping
function! ToggleWrap()
  if (&wrap == 1)
    if (&linebreak == 0)
      set linebreak
      let g:gmove=1
    else
      set nowrap
      let g:gmove=0
    endif
  else
    set wrap
    set nolinebreak
    let g:gmove=1
  endif
endfunction

" Toggle line number styles
function! ToggleNumbers()
  set relativenumber!
endfunction

function! ScreenMovement(movement)
  if &wrap && g:gmove == 'yes'
    return "g" . a:movement
  else
    return a:movement
  endif
endfunction

function! TYToggleBreakMove()
  if exists("g:gmove") && g:gmove == "yes"
    let g:gmove = "no"
  else
    let g:gmove = "yes"
  endif
endfunction

" VimAwesome.com search
function! VimAwesomeComplete() abort
  let prefix = matchstr(strpart(getline('.'), 0, col('.') - 1), '[.a-zA-Z0-9_/-]*$')
  echohl WarningMsg
  echo 'Downloading plugin list from VimAwesome'
  echohl None
ruby << EOF
  require 'json'
  require 'open-uri'

  query = VIM::evaluate('prefix').gsub('/', '%20')
  items = 1.upto(max_pages = 3).map do |page|
    Thread.new do
      url  = "http://vimawesome.com/api/plugins?page=#{page}&query=#{query}"
      data = open(url).read
      json = JSON.parse(data, symbolize_names: true)
      json[:plugins].map do |info|
        pair = info.values_at :github_owner, :github_repo_name
        next if pair.any? { |e| e.nil? || e.empty? }
        {word: pair.join('/'),
         menu: info[:category].to_s,
         info: info.values_at(:short_desc, :author).compact.join($/)}
      end.compact
    end
  end.each(&:join).map(&:value).inject(:+)
  VIM::command("let cands = #{JSON.dump items}")
EOF
  if !empty(cands)
    inoremap <buffer> <C-v> <C-n>
    augroup _VimAwesomeComplete
      autocmd!
      autocmd CursorMovedI,InsertLeave * iunmap <buffer> <C-v>
         \| autocmd! _VimAwesomeComplete
    augroup END

    call complete(col('.') - strchars(prefix), cands)
  endif
  return ''
endfunction

augroup VimAwesomeComplete
  autocmd!
  autocmd FileType vim inoremap <C-x><C-v> <C-r>=VimAwesomeComplete()<CR>
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable unused default plugins
let g:loaded_2html_plugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logipat = 1
let g:loaded_rrhelper = 1
let g:loaded_tarPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zipPlugin = 1

" Helper for coditional activation of plugins
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

if has('nvim')
  let g:python_host_prog = '/usr/bin/python2'
  let g:python3_host_prog = '/usr/bin/python3'
endif

" Auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')

" Ruby
"""""""""""""""""""""""""""""""""""""""
Plug 'tpope/vim-projectionist'                   " Project configurations
Plug 'tpope/vim-rails'                           " Ruby on Rails power tools
Plug 'tpope/vim-rake'                            " vim-rails for normal ruby projects
Plug 'tpope/vim-bundler'                         " Integrates bundler
Plug 'thoughtbot/vim-rspec'                      " Run rspec tests from within vim
Plug 'tpope/vim-rvm'                             " Switch ruby versions from within vim
Plug 'tpope/vim-endwise'                         " Wisely insert end, endif, endfunction etc.

" Python
"""""""""""""""""""""""""""""""""""""""
Plug 'klen/python-mode'                          " Pylint, Rope, Pydoc, Pyflakes, PEP8, autopep8 and McCabe complexity all in one
Plug 'hdima/python-syntax'                       " Syntax highlighting for python

" C/C++
"""""""""""""""""""""""""""""""""""""""
Plug 'octol/vim-cpp-enhanced-highlight'          " Additional syntax highlighting for C++ 11/14
Plug 'jeaye/color_coded', { 'do': 'cd ~/.vim/plugged/color_coded && mkdir -p build && cmake . -DDOWNLOAD_CLANG=0 && make && make install && make clean && make clean_clang' }                        " libclang based syntax highlighting
Plug 'DoxygenToolkit.vim'                        " DoxyGen supprt for C++
Plug 'rhysd/vim-clang-format'                    " Run clang-format from within vim
Plug 'a.vim'                                     " Switch between .cpp and .h files

" TypeScript
"""""""""""""""""""""""""""""""""""""""
Plug 'leafgarland/typescript-vim'                " Typescript syntax highlighting
Plug 'clausreinke/typescript-tools.vim', { 'do': 'npm install -g clausreinke/typescript-tools' } " Typescript tools integration

" Markup
"""""""""""""""""""""""""""""""""""""""
Plug 'godlygeek/tabular'                         " Text alignment
Plug 'plasticboy/vim-markdown'                   " Markdown syntax, matching rules and mappings
Plug 'kannokanno/previm'                         " Realtime markdown preview
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
Plug 'tpope/vim-liquid'                          " Liquid runtime files with Jekyll enhancements
Plug 'amix/vim-zenroom2'                         " iA Writer environment in vim
Plug 'junegunn/goyo.vim'                         " Distraction free writing
Plug 'junegunn/limelight.vim'                    " Focused markdown editing

" HTML, CSS/LESS/SCSS, JavaScript
"""""""""""""""""""""""""""""""""""""""
Plug 'mattn/emmet-vim'                           " Emmet for vim
Plug 'othree/html5.vim'                          " Syntax highlighting and omnicomplete for HTML
Plug 'amirh/html-autoclosetag'                   " Autoclose HTML tags
Plug 'valloric/matchtagalways'                   " Always highlight matching HTML tags

Plug 'lilydjwg/colorizer'                        " Colorize all text that specifies a color
Plug 'JulesWang/css.vim'                         " CSS syntax highlighting
Plug 'hail2u/vim-css3-syntax'                    " CSS3 syntax highlighting
Plug 'csscomb/vim-csscomb', { 'do': 'npm install -g csscomb' } " CSSComb for vim
Plug 'groenewege/vim-less'                       " Less syntax highlighting
Plug 'cakebaker/scss-syntax.vim'                 " SCSS syntax highlighting

Plug 'moll/vim-node'                             " NodeJS development tools
Plug 'pangloss/vim-javascript'                   " JavaScript indentation and syntax highlighting
Plug 'mxw/vim-jsx'                               " React JSX indentation and syntax highlighting
Plug 'heavenshell/vim-jsdoc'                     " Generate JSDoc comments
Plug 'othree/javascript-libraries-syntax.vim'    " Syntax highlighting for JavaScript libraries (jQuery, Angular, React, Handlebars, lo-dash etc.

" JSON
"""""""""""""""""""""""""""""""""""""""
Plug 'elzr/vim-json'                             " Syntax highlighting for JSON

" PHP
"""""""""""""""""""""""""""""""""""""""
Plug 'stanangeloff/php.vim'                      " PHP syntax highlighting
Plug 'shawncplus/phpcomplete.vim'                " Improved PHP omnicompletion
Plug 'tobys/pdv'                                 " Generates PHP doc comments

" LaTeX
"""""""""""""""""""""""""""""""""""""""
Plug 'latex-box-team/latex-box'                  " Toolbox for LaTeX
Plug 'vim-latex/vim-latex'                       " Enhanced LaTeX support

Plug 'PotatoesMaster/i3-vim-syntax'              " Syntax files for i3 configuration files
Plug 'tmux-plugins/vim-tmux'                     " Syntax files for tmux.conf

" Code Completion
"""""""""""""""""""""""""""""""""""""""
Plug 'raimondi/delimitMate'                      " Insert mode autocompletion for quotes, parenthesis, brackets etc.
Plug 'Valloric/YouCompleteMe', { 'do': 'cd ~/.vim/plugged/YouCompleteMe && /usr/bin/python3 install.py --tern-completer --clang-completer'} " Semantic autocompletion
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'} " Generates config files for YCM and ColorCoded (NOTE: Default branch is called 'stable')
Plug 'SirVer/ultisnips'                          " Snippets for vim
Plug 'honza/vim-snippets'                        " Legacy vim snippets

" Color Schemes
"""""""""""""""""""""""""""""""""""""""
Plug 'vim-scripts/AfterColors.vim'               " Colourscheme customization
Plug 'godlygeek/csapprox'                        " Makes Gvim colourschemes works in vim

Plug 'Son-of-Obisidian'
Plug 'sjl/badwolf'
Plug 'junegunn/seoul256.vim'
Plug 'mhartington/oceanic-next'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'Zenburn'
Plug 'notpratheek/vim-luna'
Plug 'sfsekaran/cobalt.vim'
Plug 'sickill/vim-monokai'
Plug 'morhetz/gruvbox'
Plug 'altercation/vim-colors-solarized'
Plug 'nanotech/jellybeans.vim'
Plug 'jpo/vim-railscasts-theme'
Plug 'oguzbilgic/sexy-railscasts-theme'

" Code Display
"""""""""""""""""""""""""""""""""""""""
"Plug 'Yggdroot/indentLine'             " Mark indents and leading spaces
"Plug 'nathanaelkane/vim-indent-guides' " Mark indent levels
Plug 'majutsushi/tagbar'               " Display tags ordered by scope
Plug 'ntpeters/vim-better-whitespace'  " Better whitespace highlighting
Plug 'eapache/rainbow_parentheses.vim' " Rainbow parentheses support
Plug 'sunaku/vim-hicterm'              " Highlight ncurses color codes for editing weechat configs
Plug 'chrisbra/csv.vim'                " View csv files properly

" Integrations
"""""""""""""""""""""""""""""""""""""""
" Vim HardTime
" Plug 'takac/vim-hardtime'
Plug 'KabbAmine/zeavim.vim', {'on': [
            \    'Zeavim', 'Docset',
            \    '<Plug>Zeavim',
            \    '<Plug>ZVVisSelection',
            \    '<Plug>ZVKeyDocset',
            \    '<Plug>ZVMotion'
            \ ]}
Plug 'tmux-plugins/vim-tmux-focus-events' " FocusGained and FocusLost autocommand events are not working in terminal vim. This plugin restores them when using vim inside Tmux.
Plug 'tpope/vim-eunuch'                " Common unix commands from vim including SudoWrite
Plug 'tpope/vim-fugitive'              " Git commands from within vim
Plug 'tpope/vim-git'                   " Git runtime files for vim
Plug 'junegunn/gv.vim'                 " Git commit browser
Plug 'mhinz/vim-signify'               " Git/svn/hg gutter
Plug 'airblade/vim-gitgutter'          " Aynschronous git gutter
Plug 'jaxbot/github-issues.vim'        " GitHub issues from within vim
Plug 'rhysd/conflict-marker.vim'       " Highlight VCS conflict markers
Plug 'mileszs/ack.vim'                 " Use ack to search code
Plug 'rking/ag.vim'                    " Use ag to search code
Plug 'editorconfig/editorconfig-vim'   " Editorconfig support
Plug 'jpalardy/vim-slime'              " Pass text from a buffer to a REPL in a tmux session
Plug 'xolox/vim-misc' | Plug 'xolox/vim-easytags' " Automatic tag generation
Plug 'chazy/cscope_maps'               " Recommended keymaps for cscope
Plug 'brookhong/cscope.vim'            " CScope support
Plug 'benekastah/neomake'              " Asynchronous make utility
Plug 'tpope/vim-dispatch'              " Test dipatcher for vim
Plug 'wakatime/vim-wakatime'           " Wakatime integration
Plug 'jamessan/vim-gnupg'              " GNUPG integration

" Interface
"""""""""""""""""""""""""""""""""""""""
Plug 'itchyny/lightline.vim'           " Lightweight statusline
Plug 'ctrlpvim/ctrlp.vim'              " Fuzzy file, buffer, mru, tag finder
Plug 'fholgado/minibufexpl.vim'        " Buffer list as a window
Plug 'Xuyuanp/nerdtree-git-plugin' | Plug 'scrooloose/nerdtree' " File browser with git status integration
Plug 'mhinz/vim-startify'              " Fancy start page
Plug 'kshenoy/vim-signature'           " Display, toggle and navigate marks
Plug 'sjl/gundo.vim'                   " Visualize the undo tree
Plug 'vim-scripts/Tabmerge'            " Merge windows from two or more tabs

" Commands
"""""""""""""""""""""""""""""""""""""""
"Plug 'ericfortis/vim-indenter'         " Double or halve the indentation
Plug 'terryma/vim-multiple-cursors'    " Multi cursor support
Plug 'airblade/vim-rooter'             " Change to root directory (.git, project.json, etc.)
Plug 'scrooloose/nerdcommenter'        " Comment toggle
Plug 'haya14busa/incsearch-easymotion.vim' | Plug 'haya14busa/incsearch.vim' " Highlight all pattern matches during an incsearch
Plug 'haya14busa/vim-asterisk'         " Plugin to not move on * search function
Plug 'easymotion/vim-easymotion'       " Highlight the candidates of a motion for faster motions
Plug 'tpope/vim-surround'              " Surround text objects
Plug 'tpope/vim-repeat'                " Repeat any arbitrary command
Plug 'tpope/vim-abolish'               " Simplify the search, replace and abbreviation on multiple variants of a word
Plug 'tpope/vim-unimpaired'            " Pair style mappings
Plug 'junegunn/vim-easy-align'         " Text alignment
Plug 'raimondi/yaifa'                  " Indent finder
Plug 'terryma/vim-expand-region'       " Expand selection to a larger or smaller region
Plug 'bronson/vim-visual-star-search'  " Start a * or # search from a visual block
Plug 'matchit.zip'                     " Extended % matching
Plug 'Smart-Tabs'                      " Tabs for alignment, spaces for alignment
Plug 'YankRing.vim'                    " Maintain yanks within a ring
Plug 'chrisbra/unicode.vim'            " Unicode character search and completion

" Text Objects
"""""""""""""""""""""""""""""""""""""""
Plug 'wellle/targets.vim'
Plug 'coderifous/textobj-word-column.vim'
Plug 'kana/vim-textobj-fold'
Plug 'kana/vim-operator-replace'
Plug 'christoomey/vim-sort-motion'

Plug 'michaeljsmith/vim-indent-object'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-line'
Plug 'michaeljsmith/vim-indent-object'
Plug 'mattn/vim-textobj-url'
Plug 'Julian/vim-textobj-brace'
Plug 'rhysd/vim-textobj-continuous-line'
Plug 'libclang-vim/vim-textobj-clang'
Plug 'bps/vim-textobj-python'
Plug 'jasonlong/vim-textobj-css'
Plug 'rbonvall/vim-textobj-latex'
Plug 'akiyan/vim-textobj-php'
Plug 'nelstrom/vim-textobj-rubyblock'

call plug#end()

" Colourscheme
set background=dark
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark="hard"
colorscheme gruvbox

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Useful keybindings for Plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" H to open help docs
function! s:plug_doc()
  let name = matchstr(getline('.'), '^- \zs\S\+\ze:')
  if has_key(g:plugs, name)
    for doc in split(globpath(g:plugs[name].dir, 'doc/*.txt'), '\n')
      execute 'tabe' doc
    endfor
  endif
endfunction

augroup PlugHelp
  autocmd!
  autocmd FileType vim-plug nnoremap <buffer> <silent> H :call <sid>plug_doc()<cr>
augroup END

" gx to go to github url of plugin
function! s:plug_gx()
  let line = getline('.')
  let sha  = matchstr(line, '^  \X*\zs\x\{7}\ze ')
  let name = empty(sha) ? matchstr(line, '^[-x+] \zs[^:]\+\ze:')
            \ : getline(search('^- .*:$', 'bn'))[2:-2]
  let uri  = get(get(g:plugs, name, {}), 'uri', '')
  if uri !~ 'github.com'
    return
  endif
  let repo = matchstr(uri, '[^:/]*/'.name)
  let url  = empty(sha) ? 'https://github.com/'.repo
            \ : printf('https://github.com/%s/commit/%s', repo, sha)
  call netrw#BrowseX(url, 0)
endfunction

augroup PlugGx
  autocmd!
  autocmd FileType vim-plug nnoremap <buffer> <silent> gx :call <sid>plug_gx()<cr>
augroup END

" J / K to scroll the preview window
function! s:scroll_preview(down)
  silent! wincmd P
  if &previewwindow
    execute 'normal!' a:down ? "\<C-e>" : "\<C-y>"
    wincmd p
  endif
endfunction

" CTRL-N / CTRL-P to move between the commits
" CTRL-J / CTRL-K to move between the commits and synchronize the preview window
function! s:setup_extra_keys()
  nnoremap <silent> <buffer> J :call <sid>scroll_preview(1)<cr>
  nnoremap <silent> <buffer> K :call <sid>scroll_preview(0)<cr>
  nnoremap <silent> <buffer> <C-n> :call search('^  \X*\zs\x')<cr>
  nnoremap <silent> <buffer> <C-p> :call search('^  \X*\zs\x', 'b')<cr>
  nmap <silent> <buffer> <C-j> <C-n>o
  nmap <silent> <buffer> <C-k> <C-p>o
endfunction

augroup PlugDiffExtra
  autocmd!
  autocmd FileType vim-plug call s:setup_extra_keys()
augroup END

" Unmap leader hogging insert mode mappings
augroup DisableMappings
  autocmd!
  autocmd VimEnter * :inoremap <Leader>ih <Nop>
  autocmd VimEnter * :inoremap <Leader>is <Nop>
  autocmd VimEnter * :inoremap <Leader>ihn <Nop>
augroup END

" UltiSnips completion function that tries to expand a snippet. If there's no
" snippet for expanding, it checks for completion window and if it's
" shown, selects first element. If there's no completion window it tries to
" jump to next placeholder. If there's no placeholder it just returns TAB key
let g:UltiSnipsExpandTrigger       = "<tab>"
let g:UltiSnipsJumpForwardTrigger  = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

function! g:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible()
            return "\<C-n>"
        else
            call UltiSnips#JumpForwards()
            if g:ulti_jump_forwards_res == 0
               return "\<TAB>"
            endif
        endif
    endif
    return ""
endfunction

au InsertEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"

" apt-get install shellcheck
autocmd! BufWritePost * Neomake

let g:ycm_global_ycm_extra_conf = '/home/ashhar/.config/nvim/.ycm_extra_conf.py'
"let g:ycm_path_to_python_interpreter = '/usr/bin/python'
"let g:ycm_server_python_interpreter = '/usr/bin/python'

nunmap <C-P>
nmap <C-P> <Plug>(ctrlp)

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
    " Use Ag over Grep
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag -Q -l --nocolor --hidden -g "" %s'

    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
endif

let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_json_frontmatter = 1

function! Mirror(dict)
  for [key, value] in items(a:dict)
    let a:dict[value] = key
  endfor
  return a:dict
endfunction

function! S(number)
  return submatch(a:number)
endfunction

function! SwapWords(dict, ...)
  let words = keys(a:dict) + values(a:dict)
  let words = map(words, 'escape(v:val, "|")')
  if(a:0 == 1)
    let delimiter = a:1
  else
    let delimiter = '/'
  endif
  let pattern = '\v(' . join(words, '|') . ')'
  exe '%s' . delimiter . pattern . delimiter
      \ . '\=' . string(Mirror(a:dict)) . '[S(0)]'
      \ . delimiter . 'g'
endfunction


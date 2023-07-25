let mapleader = ","

"""""""""""""""""""" normal to each session
set autochdir
set ignorecase
set autoindent
set relativenumber
set number
"set hlsearch
set showmatch
set tabstop=3
set shiftwidth=3
set textwidth=0					" prevent Vim from automatically inserting line breaks
set wrapmargin=0
set spelllang=en_us
set wildmenu

nnoremap ; :
vnoremap ; :
inoremap <M-BS> <C-\><C-o>db
nnoremap <M-BS> db
nnoremap ds d)
nnoremap cs c)
nnoremap ce ea

xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv

noremap <C-h> <C-W>h
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-l> <C-W>l


:cmap qw wq

"""""""""""""""""""" PLugins
call plug#begin('~/.local/share/nvim/site/plugged')
		Plug 'tpope/vim-repeat'
		Plug 'dahu/vim-fanfingtastic'
		Plug 'dense-analysis/ale'
		Plug 'junegunn/goyo.vim'
		Plug 'junegunn/limelight.vim'
		Plug 'vim-pandoc/vim-pandoc'
		Plug 'vim-pandoc/vim-pandoc-syntax'
		Plug 'christoomey/vim-system-copy'
		Plug 'tpope/vim-fugitive'
call plug#end()

let g:pandoc#syntax#style#emphases = 1
let g:pandoc#syntax#conceal#blacklist = ['quotes', 'ellipses', 'newline']

nmap <Leader>f <Plug>fanfingtastic_;
nmap <Leader>F <Plug>fanfingtastic_,



""""""""" word count

function WordCount()
	return g:word_count
endfunction

function UpdateWordCount()
	let lnum = 1
	let n = 0
	while lnum <= line('$')
		let n = n + len(split(getline(lnum)))
		let lnum = lnum + 1
	endwhile
	let g:word_count = n
endfunction
" Update the count when cursor is idle in command or insert mode.
" Update when idle for 1000 msec (default is 4000 msec).

function! DispWordCount()
	let g:word_count="<unknown>"
	set updatetime=1000
	augroup WordCounter
		au! CursorHold,CursorHoldI * call UpdateWordCount()
	augroup END

	highlight User1 ctermbg=green guibg=green ctermfg=black guifg=black
	set statusline=%=			" separator from left to right justified
	set statusline+=\ %{WordCount()}\ words
endfunction


""""""""" writing environments

function! Normal_environment()
	Goyo!
	Limelight!
	set nolinebreak
	set nospell
	set relativenumber
	set number
endfunction

function! Prose_mode()
	set linebreak
	Goyo
	set norelativenumber
	set nonumber
endfunction

function! Writing_environment()
	call Normal_environment()
	call Prose_mode()
	Limelight
	set nofoldenable
	call DispWordCount()
endfunction

function! Editing_environment()
	call Normal_environment()
	call Prose_mode()
	set spell
	set number
	set foldenable
endfunction

function! Reading_environment()
	call Normal_environment()
	call Prose_mode()
	set number
	set nofoldenable
endfunction

noremap <Leader>w :call Writing_environment()<CR>
noremap <Leader>e :call Editing_environment()<CR>
noremap <Leader>r :call Reading_environment()<CR>
noremap <Leader>q :call Normal_environment()<CR>

let g:goyo_width = '70%'
let g:limelight_conceal_ctermfg = 240

"""""""""""""" Auto Commands
function! ExitVim()
	Git add .
	Git commit -m %
	Git push
endfunction

:autocmd VimLeavePre ~/Documents/GitShared/gitjournal/[^.]* call ExitVim()



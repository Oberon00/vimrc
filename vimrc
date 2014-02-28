set nocompatible

let mapleader = ' '  " Space

" ---------------------------------------------------------------------------
" Fileformat settings:

set encoding=utf-8  " Set utf-8 as default encoding (try recognizing others)
set fileformats=unix,dos  " Unix LF by default (but still can read CRLF)
set fileformat=unix  " For new files, use Unix LF

" Indentation is 4 spaces, but (existing) hard tabs still occupy 8 columns.
set shiftwidth=4
set softtabstop=4
set expandtab


" ---------------------------------------------------------------------------
" Editing features:

filetype on         " Enable filetype detection
filetype plugin on  " Enable plugins for filetypes
filetype indent on  " Enable loading indent scripts for recognized filetypes
set autoindent  " Keep indentation of last line by default

" Allow backspacing over autoindent, line breaks, and start of insert.
set backspace=indent,eol,start

augroup vrcFiletypes
    " Remove everything from this group (reload support):
    autocmd!
    autocmd FileType pascal setlocal shiftwidth=2 softtabstop=2
augroup END


" ---------------------------------------------------------------------------
" Visual settings:

if has('gui_running')
    set guioptions-=m  " Remove menu bar.
    set guioptions-=T  " Remove toolbar.
    if has('win32')
        set guifont=Consolas:h10
        set guifontwide=NSimSun:h10
    endif " if has('win32')
elseif !has('win32') && $TERM != 'linux'
    set t_Co=256  " Try 256 colors. Add offending $TERMs to condition above 
endif

set guicursor=n:blinkon0  " No blinking cursor in normal mode.

syntax on  " Enable syntax highlighting
set background=dark  " Use default dark color theme by default
if has('gui_running') || &t_Co > 255 
    silent! colorscheme molokai  " If available, use the molokai color scheme
endif

set scrolloff=1  " Keep at least 1 line below/above the cursor visible.
set sidescrolloff=5  " ... 5 columns left/right ...


" ---------------------------------------------------------------------------
" Other settings:

" chdir to file directory:
nnoremap <Leader>cd :lcd %:p:h<CR>

" Execute executable generated from file
if has('win32')
    nnoremap <F5> :!"%:r.exe"<CR>
else
    nnoremap <F5> :!'%:r'<CR>
endif

function! VrcFileInfo() " For statusline below.
    let enc = &fileencoding == '' ? &encoding : &fileencoding
    let enc = enc == 'utf-8' ? '' : enc  " utf-8 is assumed anyway.
    let ff = &fileformat == 'unix' ? '' : &fileformat  " Dito for ff == unix
    let ext = toupper(expand('%:e'))
    let ft = toupper(&filetype)

    " If filetype is obvious from extension, don't display it either 
    if ext != '' && (stridx(ext, ft) >= 0 || stridx(ft, ext) >= 0)
        let ft = ''
    endif

    return join(filter([enc, ff, ft], 'v:val != ""'), ',')
endfunc

set laststatus=2  " Always show statusbar 
set statusline= " Clear statusline, append below:
set statusline+=%4l,%-5(%02c%03V%)  " Line and column position
set statusline+=\ %=%<  " Start of right aligned part + truncate here
set statusline+=%{expand('%:~:.')}  "File path
set statusline+=\ %LL " Total line count (with a literal 'L' appended)
set statusline+=%(\ [%M%R%H%W]%)  " Other flags
set statusline+=%(\ %q%)  " Location/Quickfix window?
set statusline+=%(\ [%{VrcFileInfo()}]%)  " File info

set mouse=a   " Enable mouse in all modes.

set wildmenu  " Display possible commandline completions.
set showcmd  " Show normal mode commands in bottom line

set hlsearch   " Highlight search matches in whole window...
nohlsearch     " ...but start w/o annoying leftover highlights
set incsearch  " Start highlighting while typing search pattern
" End search highlighting by pressing <Esc>:
nnoremap <silent> <Esc> :nohlsearch<Return>


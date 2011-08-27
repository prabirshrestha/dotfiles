" Vim color file
" http://www.prabir.me
" Maintainer:	Prabir Shrestha <mail@prabir.me>
" Last Change:	2010 Feb 18

set background=dark
set guifont=Consolas:h10
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "prabirdark"
hi Normal		guifg=#DCDCCC		guibg=#3F3F3F
hi Comment	ctermfg=DarkCyan		guifg=#7F9F7F
hi Keyword	guifg=#8EC46F
hi Constant	term=underline	ctermfg=Magenta		guifg=#DCDCCC
hi link Special Keyword
hi Identifier term=underline		ctermfg=Cyan guifg=#DFDFBF
hi link Statement Keyword
hi PreProc	term=underline	ctermfg=LightBlue	guifg=#DFAF8F
hi Type	term=underline		ctermfg=LightGreen	guifg=#8EC46F gui=bold
hi Function	term=bold		ctermfg=White guifg=White
hi link Repeat Keyword
hi Operator				ctermfg=Red			guifg=Red
hi Ignore				ctermfg=black		guifg=bg
hi Error	term=reverse ctermbg=Red ctermfg=White guibg=Red guifg=White
hi Todo	term=standout ctermbg=Yellow ctermfg=Black guifg=Blue guibg=Yellow
hi Number	guifg=#8ACCCF

" Common groups that link to default highlighting.
" You can specify other highlighting easily.
hi String	guifg=#C89191
hi link Character	Constant
hi link Boolean	Keyword
hi link Float		Number
hi link Conditional	Repeat
hi link Label		Statement
hi LineNr		guifg=#857b6f		ctermfg=cyan
hi link Exception	Statement
hi link Include	PreProc
hi link Define	PreProc
hi link Macro		PreProc
hi link PreCondit	PreProc
hi link StorageClass	Type
hi link Structure	Type
hi link Typedef	Type
hi link Tag		Special
hi link SpecialChar	Special
hi link Delimiter	Special
hi link SpecialComment Special
hi link Debug		Special

hi Cursor	guifg=black guibg=gray ctermfg=black ctermbg=yellow
hi lCursor	guifg=black guibg=white ctermfg=black ctermbg=white

hi Visual		term=reverse		ctermfg=black	ctermbg=darkCyan	guifg=#DCDCCC		guibg=#63928A

if version >= 700
  hi CursorLine guibg=#2d2d2d
  hi CursorColumn guibg=#2d2d2d
  hi MatchParen guifg=#f6f3e8 guibg=#857b6f gui=bold
  hi Pmenu 		guifg=#f6f3e8 guibg=#444444
  hi PmenuSel 	guifg=#000000 guibg=#cae682
endif

" Special for XML
hi xmlTag          	guifg=#EFEF8F 
hi link xmlTagName	xmlTag
hi xmlEndTag        guifg=#EFEF8F  
hi link xmlAttrib	Normal
hi link xmlProcessingDelim xmlTag


" Special for HTML
hi link htmlTag         Keyword 
hi link htmlTagName     Conditional 
hi link htmlEndTag      Identifier 


" Special for Javascript
hi link javaScriptNumber      Number 


" Special for Python
"hi  link pythonEscape         Keyword      


" Special for CSharp
hi link csXmlTag             	Keyword      
hi link csType 					Keyword
hi link csUnspecifiedStatement	Keyword
hi link csUnsupportedStatement	Keyword
" Special for PHP


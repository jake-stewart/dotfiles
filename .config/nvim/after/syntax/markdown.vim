
setlocal conceallevel=2

syn match MarkdownLink /^\s*([a-zA-Z0-9.,_\/ -]*)\[[a-zA-Z0-9._\/ -]\+\]$/
syn match MarkdownLinkText /([a-zA-Z0-9.,_\/ -]*)\[[a-zA-Z0-9._\/ -]\+\]$/ contained containedin=MarkdownLink
syn match MarkdownLinkJunk /\([()]\|\[.*\]\)/ contained containedin=MarkdownLinkText conceal
hi MarkdownLinkText ctermfg=darkblue cterm=underline

syn region MarkdownCode start=/^```/ end=/```$/ contains=MarkdownCodeJunk keepend
syn match MarkdownCodeJunk /```.*$/ contained containedin=MarkdownCode
hi link MarkdownCodeJunk Comment

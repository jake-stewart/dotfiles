
setlocal conceallevel=2


syn match MarkdownLink /^\s*\[[^\[\]]*\]([a-zA-Z0-9._\/ -]\+)$/ containedin=markdownLinkText
syn match MarkdownLinkText /\[[^\[\]]*\]([a-zA-Z0-9._\/ -]\+)$/ contained containedin=MarkdownLink
syn match MarkdownLinkJunk /\[\|\](.*)/ contained containedin=MarkdownLinkText conceal
hi MarkdownLinkText ctermfg=darkblue cterm=bold

syn region MarkdownCode start=/^```/ end=/```$/ contains=MarkdownCodeJunk keepend
syn match MarkdownCodeJunk /```.*$/ contained containedin=MarkdownCode
hi link MarkdownCodeJunk Comment

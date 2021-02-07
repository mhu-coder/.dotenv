setlocal iskeyword=@,48-57,_,192-255,#,-

syntax match sshknownhostspubkey "AAAA[0-9a-z-A-Z+/]\+[=]\{0,2}"
highlight def link ssknownhostspubkey Special

syn keyword sshalg ssh-rsa
hi def link sshalg Identifier

syn match sshknownhostsip "\<\(d\{1,3}\.\)\{3}\d\{1,3}\>"
hi def link sshknownhostspubkey Constant

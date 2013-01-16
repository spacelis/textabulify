if exists("b:TexTabulify")
	finish
endif
let b:TexTabulify = 1

if !exists("g:TexTabulify_header")
	let g:TexTabulify_header = '\begin{tabular}{%s} \hline'
endif
if !exists("g:TexTabulify_footer")
	let g:TexTabulify_footer = '\end{tabular}'
endif

function s:TexTabulify() range
python << EOF
def formatline(line):
    """ Format line to table style
    """
    if '|' in line:
        return line.replace('|', ' & ')
    elif ',' in line:
        return line.replace(',', ' & ')
    elif ' ' in line:
        return line.replace(' ', ' & ')
    return line

rbuf = vim.current.buffer.range(int(vim.eval('a:firstline')), int(vim.eval('a:lastline')))
for i in range(len(rbuf)):
    rbuf[i] = formatline(rbuf[i]) + r' \\ \hline'
cols = rbuf[-1].count('&') + 1
rbuf.append(vim.eval('g:TexTabulify_header') % '|'.join([''] + ['c'] * cols + ['']), 0)
rbuf.append(vim.eval('g:TexTabulify_footer '))
EOF
endfunction


command -range -buffer TexTabulify <line1>,<line2>call s:TexTabulify()

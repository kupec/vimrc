function! qp_util#random(min, max) abort
	let l:a = system('echo -n $RANDOM')
	return l:a % (1 + a:max - a:min) + a:min
endfunction

function! qp_util#color_opacify(hex_color, opacity) 
    let opacity = str2float(a:opacity)
    let result = ""

    let i = 0
    while i <= 2
        let color = str2nr(a:hex_color[2*i : 2*i + 1], 16)

        let new_color = float2nr(color * opacity)
        let result .= printf("%02x", new_color)

        let i += 1
    endwhile

    return result
endfunction


command! -nargs=* ColorOpacify call append(line('.'), qp_util#color_opacify(<f-args>))

command! -range JsonToKeys <line1>,<line2>!python3 ~/.vim/python/json_to_keys.py


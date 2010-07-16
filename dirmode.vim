
function DirMode()
  let file = expand("%:p")
  let prev = ""
  while 1
    let prev = file
    let file = fnamemodify(file, ":h")
    if strlen(file) == 0 || file == prev
      break
    endif
    let modefile = file . "/.vim-mode"
    if filereadable(modefile)
      " echo "Loading " . modefile
      call LoadMode(modefile)
      break
    endif
  endwhile
endfunction

let s:valid = 
      \{ "tabstop"    : 1
      \, "shiftwidth" : 1
      \, "softtabstop": 1
      \, "expandtab"  : 1
      \, "noexpandtab": 1
      \, "fileformat" : 1
      \, "fileformats": 1
      \}

function LoadMode(file)
  let modes = readfile(a:file)
  for mode in modes
    " echo "Parsing " . mode
    let len = strlen(mode)
    if len >= 2
      let sep = stridx(mode, "=", 1)
      " echo "Separator at " . sep
      if sep == -1
        let opt = mode
      else
        let opt = strpart(mode, 0, sep)
      endif
      " echo "Option is " . opt
      if get(s:valid, opt)
        " echo "Valid!"
        if sep == -1
          " echo "No value!"
          execute "set " . opt
        else
          let val = strpart(mode, sep + 1, len - sep - 1)
          " echo "Value is " . val
          if match(val, "^\\w*$") == 0
            " echo "Value is valid!"
            execute "set " . opt . "=" . val
          endif
        endif
      endif
    endif
  endfor
endfunction

au BufRead,BufNewFile * call DirMode()


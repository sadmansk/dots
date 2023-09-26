function! BrazilWorkspaceRoot()
  let l:working_directory = getcwd()
  let l:workspace_root = split(l:working_directory, "/")[0:4]
  return "/" . join(l:workspace_root, "/")
endfunction

function! BrazilOpenJDKLocation()
  let l:workspace_directory=BrazilWorkspaceRoot()
  let l:jdk_path=""
  if (isdirectory(l:workspace_directory."/env/OpenJDK8-1.1"))
      let l:jdk_path=l:workspace_directory."/env/OpenJDK8-1.1"
  elseif (isdirectory(l:workspace_directory."/env/JDK8-1.0"))
      let l:jdk_path=l:workspace_directory."/env/JDK8-1.0"
  endif
  
  if (empty(l:jdk_path))
    return "/apollo/env/JavaSE11/jdk-11/"
  else
    return l:jdk_path . "/runtime/jdk1.8/"
  endif
endfunction

function! SetBrazilJDKHome()
  let $JDK_HOME=BrazilOpenJDKLocation()
endfunction
call SetBrazilJDKHome()



function! vim_github_cli#graphql#execute(query, headers, token)
    """ Execute a GraphQL query.
    " (abstracts HTTP query for various backends)
    "
    "Args:
    "   query    ex: '{"query": "query {repository(owner: \"octocat\", \"helloworld\"){ description }}}"'
    "   headers  ex:  {}
    "   token    ex: "123456789101112..."
    """
    if vim_github_cli#system#which('curl')
        return vim_github_cli#graphql#execute_curl(a:query, a:headers, a:token)
    endif

    throw vim_github_cli#error#no_http_providers("Please install one of: curl,")
endfunction


function vim_github_cli#graphql#execute_curl(query, headers, token)
    """ POST to a graphql endpoint, returning JSON 'serialized' into VIML
    "
    "Args:
    "   query    ex: '{"query": "query {repository(owner: \"octocat\", \"helloworld\"){ description }}}"'
    "   headers  ex:  {}
    "   token    ex: "123456789101112..."
    """
    let l:headers = { 
        \ "Content-Type": "application/json",
        \ "Authorization": "bearer " . a:token,
        \ }
    let l:headers = extend(a:headers, l:headers)

    let l:cmd = ['curl', '-X', 'POST']
    for [k, v] in items(l:headers)
        let l:val = k . ': ' . v
        let l:cmd += ["-H", l:val]
    endfor
    let l:cmd += ['-d', a:query]
    let l:cmd += ['-s']
    let l:cmd += ['https://api.github.com/graphql']
    let g:cmd = l:cmd
    let l:json_result = vim_github_cli#system#system(l:cmd)
    return json_decode(l:json_result)
endfunction



syn match structurizrTodo /\v<(FIXME|NOTE|TODO|XXX)/ contained containedin=scomment
hi def link structurizrTodo Todo

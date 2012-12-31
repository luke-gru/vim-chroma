What does it do?
================

Highlights colors when editing css.
Understands the following formats:

    #ffffff
    #fff
    rgb(255, 255, 255)
    rgba(255, 255, 255, 0.5)

Setup
=====

Enable mapping in vimrc or gvimrc

    :nnoremap <leader>h :call g:chromaHighlight()<CR>

# tw-ann-hook
A taskwarrior hook that enables automatic and multi-line annotations.

STATUS: Imaginary, this is a stub of an idea.

### What would tw-ann-hook do?

Currently, to add an annotation in taskwarrior, issue the command

   task 142 annot This is the text of the annotation
   
but if you just use 'task 142 annot', you get error message;

   Additional text must be provided.

Instead of that error message, this hook would start your editor
(as long as it's vim) and open a buffer as annotation text. 
On saving the file, the line-breaks and tab-chars are translated to
JSON esc-codes, and the text is saves as the annotation.

The other thing this hook would (should, could) do is to 
allow a configutable tag, like +ann, that opens the edit-annotation
vim-function for a task, whenever it is started or completed.

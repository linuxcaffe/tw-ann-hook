# tw-ann-hook
_A taskwarrior hook that enables automatic and multi-line annotations._

*STATUS: Imaginary, the "hook" part is not yet implemented, but twan.sh works well.*

To use twan.sh, make the script executable (chmod +x ../path/to/twan.sh) and then follow with task ID to annotate;

```
$ twan.sh 142
```
edit the annotation in vim, and on saving and closing, ine-breaks, tabs etc are preserved

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

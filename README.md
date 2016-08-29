# tw-ann-hook
_A taskwarrior hook that enables automatic and multi-line annotations._

*STATUS: the "hook" part is not yet implemented, but twan.sh script works well.*

It's possible to create milti-line annotations "out of the box", that is to say, without using any external scripts or your $EDITOR, by starting and ending the annotation with a quote, like this;

```
$ task 142 annotate 'the first line
the second line, and
the third line'
```

If you would rather create your annotation using your $EDITOR, you can use the twan.sh script. First, make the script executable (chmod +x ../path/to/twan.sh) and then follow with task ID to annotate;

```
$ twan.sh 142
```
write the annotation, and on saving and closing, line-breaks, tabs etc are preserved

### What would tw-ann-hook do?

Currently, to add an annotation in taskwarrior, issue the command
```
task 142 annot This is the text of the annotation
```
but if you just use 
```
task 142 annot
```
you get error message;
```
Additional text must be provided.
```
Instead of that error message, this hook would start your editor
(as long as it's vim) and open a buffer as annotation text. 
On saving the file, the line-breaks and tab-chars are translated to
JSON esc-codes, and the text is saves as the annotation.

The other thing this hook would (should, could) do is to 
allow a configutable tag, like +ann, that opens the edit-annotation
vim-function for a task, whenever it is started or completed.

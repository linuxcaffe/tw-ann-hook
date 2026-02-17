The "Taskwarrior annotation API"
refers to the methods for interacting with task annotations using Taskwarrior's various interfaces, including the command-line interface, export/import (JSON) formats, and language-specific bindings/libraries. 
Command-Line Interface (CLI)
Taskwarrior provides specific commands to manage annotations directly from the terminal. 

    Add an annotation to an existing task:
    bash

    task <ID> annotate "<text string>"

    This command appends a new annotation with a timestamp to the specified task.
    Remove an annotation from a task:
    bash

    task <ID> denotate "<text string or number>"

    You can specify the exact text of the annotation to remove, or use an ordinal number to indicate which one (e.g., the first, the second).
    Add a task with an immediate annotation (workaround):
    While you cannot add an annotation with the add command directly, a common practice is to use a simple script or an alias to add the task and then immediately annotate the latest task. 

Plumbing Interface (JSON and Hooks)
For scripting and integration, Taskwarrior uses a "plumbing" interface that involves exporting and importing tasks in JSON format, or using hook scripts. 

    Task Representation: In the internal data model and JSON export, annotations are stored as a set of key-value pairs, where the key is annotation_<timestamp> and the value is the annotation text.
    Accessing data: The Document Object Model (DOM) allows access to specific annotation fields using a dot-notation in scripts, such as annotations.<N>.description and annotations.<N>.entry where <N> is an ordinal.
    Hook Scripts: You can use hook scripts that trigger on events (e.g., when a task is added or modified) to programmatically read or add annotations by manipulating the JSON data passed via standard input/output. 

Language Bindings and Third-Party Tools
Several libraries and tools wrap Taskwarrior's functionality, providing a more structured API for various programming languages. 

    Python: Libraries like the official python-taskwarrior use the export and import interfaces to provide a clean internal API for interaction.
    Haskell: The taskwarrior package on Hackage provides specific data types and JSON instances for managing annotations within Haskell applications.
    Other Tools: Various community-developed tools, such as taskopen (for linking files/URLs to annotations) or web UIs, leverage these APIs for extended functionality. 

For detailed documentation on the commands and data formats, refer to the official Taskwarrior Documentation. 

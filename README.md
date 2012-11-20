ls lua
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
The goal of this project is to write a stable ls implementation in lua that
does everything the original ls does and more. The way this is accomplished is
that instead of ls.lua doing any work, it hands over the entries it lists in
a certain path over to whatever plugin was specified to be used. As of now,
there are probably some inconsistencies and issues, but it has worked fine
enough for me to write a rename plugin which I have used to remove Unknown from
many file names of music copied from CD's.

The idea here is that ls.lua lists the directories internally and hands off
a representation of what it has found to plugins that do the actual work, these
plugins can do anything that is possible to be done to the filesystem. For
instance, the rename plugin renames files according to a regular expression
search and a plain text replace argument. ls.lua only keeps up with how many
directory levels it has recursed and how many times a plugin returned that it
was applied to an entry. Plugins have options to do whatever lua can, if they
wish they may print out information, remain silent, or take an argument to tell
it what to do. If lua can do it, then your plugin can do it. Of course we'll
find limitations in the future but for now that is the basic assumption.

The goal of the project is to produce an ls that is stable and works via
plugins, and is powerful enough that perhaps a file manager could be written as
a plugin to this program itself. It already displays attributes of file
management though the issue now is that there exist no plugins for it to be
able to do many of the things one would do in a file manager. There are things
that this project does that regular ls most likely can not do. Anything that
this project can't do at the moment but ls can I would be happy to know of and
will get that supported right away.

This program has a required set of options:
directory, plugin, plugins\_path, and recurse
they are all set by --$arg=$val
they are all required.
Directory is the directory you wish ls to list recursively.
Plugin is the plugin you wish ls to apply to entries it finds.
Plugins\_path is the path to the plugins available.
Recurse is how many levels deep into the directory tree you wish ls to step.

An example usage of this program would be:
./ls.lua --directory="." --plugin="rename" --plugins\_path="." --recurse=-1 \
    --search="a" --replace="ab" --execute="false" --verbose="true"

You're probably thinking, "HEY, Where did all those extra arguments come from."
Well, the plugin you use takes arguments, and if not present, it may not check
or anything for that matter. That example showed how to use the rename plugin.
That will possibly be explained seperately.

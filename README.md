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

Notes:
Right now, limitations are that ls will likely crash if directory entries are
modified by plugins. Need to make ls reentrant, and callable from plugins, and
able to handle directory modifications. Thoughts on this are that plugins
likely need to return a value indicating whether ls needs to be reset and ls
would need to keep state on which entries have been applied and when
a directory is added, removed or so on so as to be able to resume correctly at
such points and continue ls'ing as appropriate.

Another limitation is right now plugins can only be written in lua. Think we
need a plugin that is capable of loading dynamic libraries and calling the
dynlib's apply function and so on. Another plugin may yet need to be written to
be able to call applications as well such that applications can be applied if
they support a certain command line compatible with said plugin. This would
make it way plugins can I guess be written in any language, and can be programs
as well. For performance reasons or just because someone decides they want it
that way.

LICENSE IS AS BELOW
# Open Works License

This is version 0.9.2 of the Open Works License

## Terms

Permission is hereby granted by the copyright holder(s), author(s), and
contributor(s) of this work, to any person who obtains a copy of this work in
any form, to reproduce, modify, distribute, publish, sell, use, or otherwise
deal in the licensed material without restriction, provided the following
conditions are met:

Redistributions, modified or unmodified, in whole or in part, must retain
applicable copyright notices, the above license notice, these conditions, and
the following disclaimer.

NO WARRANTY OF ANY KIND IS IMPLIED BY, OR SHOULD BE INFERRED FROM, THIS LICENSE
OR THE ACT OF DISTRIBUTION UNDER THE TERMS OF THIS LICENSE, INCLUDING BUT NOT
LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
AND NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT, OR OTHERWISE, ARISING FROM, OUT OF, OR IN CONNECTION WITH THE
WORK, OR THE USE OF OR OTHER DEALINGS IN THE WORK.

# AlfredGit
Helps you handle multiple git repos more quickly and easily.

## Longer Description
Guys. We live in 2016. When Marty visited the future, he now visited *last
year.* Cars are now out there driving. *Themselves*. We are *half a
century* removed from sending a man to another celestial body and without even
blowing him up in the process. Why on Earth (heh), then, do I need to cd into
every single repo I'm working with on a project and type individual git commands
in every one of them?

You know, some guy back in the 20s had a similar question. Why did he have to
do all this stupid 'math' crap by hand? And do you know what he did? He punched
math in the face and invented freaking computers (I don't know my computer
history very well). I...well, to be honest, I'm doing something a tad less
monumental, but I am that man. A modern what's-his-name-you-know-the-guy-who-
hated-math-and-invented-computers-if-that-story-is-even-real(-it's-not).

Enter AlfredGit, named after a certain famous billionaire's butler. AlfredGit does
those stupid menial typing tasks for you. Why? Because you're freaking Batman
and Batman doesn't have time to sit there cd-ing into 12 different repo
directories and issuing a `git pull` in every single one of them. He's too
busy out there punching...uh...bugs and...feature requests in the face (this
analogy is quickly falling apart). So grab AlfredGit and say goodbye to
spending 20% of your day typing git commands in 140 different repos like a
pleb. This, guys. This is the future.

# Installation

An install is as easy as typing `gem install alfred_git` on your command line
(you need to have ruby installed). At that point, all you need to do to run
the app is type `alfred_git`.

# Use

I've tried to make the command syntax as intuitive as possible. Essentially,
you'll send in a few parameters (the exact number of parameters required
changes based on what git command you need to run - you can't run a `git
checkout` without a branch name, for instance) separated by spaces; the 
important thing to remember is that repos you want to work with will *always* be
your last/last few parameters and will also be separated by spaces. Want to do
all of the repos, but don't want to type them all out? Of course you do! Why
else would you be using this app? Just run AlfredGit with the word 'all' as
your last parameter. How does AlfredGit know your repos? You set them up when
you first run the app! After installation, just run the app and it'll run you
through the set up and explain along the way!

AlfredGit comes packaged with the most common git commands built in. You can also
send custom commands, so you can send whatever command you'd like to however many
branches you'd like in one fell swoop! Simple! Think another command warrants
being on this list? Email me and I'll consider adding it!

And with that, we come to the built-in commands. Here are the AlfredGit commands
followed by a description of what they run. Most of these should be intuitive.
Any command with an underscore in it can also be typed without the underscore for
quicker access because if you're using this app you're clearly lazy and typing
underscores is hard. So for example, `add_repo` can be typed as `addrepo`.

* `pull` - Runs a `git pull`
* `push` - Runs a `git push`
* `checkout second_parameter` - Runs a `git checkout second_parameter`
* `commit 'second_parameter'` - Runs a `git commit -m 'second_parameter'`
* `status` - Runs a `git status`
* `branch` or `branches` - Lists the branch(es) your repo(s) currently have
                           checked out.
* `list_repo` or `list_repos` - Lists all of your repo names and their locations.
* `add_repo second_parameter` - Starts the process of adding a new repo by the
                                name given in the second parameter. The location
                                of the repo will be asked for and then added to
                                your list of repos.
* `repo_add_directory` or `rad` - Searches all subdirectories of the second parameter
                                  and automatically adds each to the list of repos. This
                                  command uses the relative path between the second parameter 
                                  and the repo as the repo name. The second parameter can be
                                  the absolute path to the directory or a dot representing the
                                  current directory.
* `delete_repo second_parameter` - Deletes the repo identified by second
                                   parameter. If "all" is supplied, this deletes all 
                                   repositories.
* `woa` or `wielder_of_anor` - Integrates AlfredGit with
                               [WielderOfAnor](https://github.com/iamsellek/wielder_of_anor).
                               This command takes up to two parameters. The
                               first will always be your commit message. The
                               second is optional, can only be the number 1 (it
                               will be ignored if it is anything else), and it
                               will skip checking for forbidden words.
                           
To send a custom command to any number of branches, just send it as your first
parameter. Here's the important part to remember, though: if your custom command
has a space in it/is longer than one word (say you need to send a `gulp build`
to several branches), make sure you wrap it in quotes when sending it to
AlfredGit. Also, for some reason, aliases don't work just yet with AlfredGit.
I'll be fixing this at some point.

# Quick Example
Here's a quick example of how it works! When you set AlfredGit up, you'll point
to the locations of all of your repos and give them 'friendly' names with which
you can quickly refer to them. For the sake of these examples, we'll assume
that you are completely unimaginative (and really good at remembering numbers)
and that you've set up 4 repos and named them 'repo_1', 'repo_2', 'repo_3',
and 'repo_4'.

Want to pull repos 1, 2, and 3? Easy!

`> alfred_git pull repo_1 repo_2 repo_3`

What about pulling every repo?

`> alfred_git pull all`

How about checking out a branch named 'branch_name' on multiple repos at once?

`> alfred_git checkout branch_name repo_1 repo_2`

Need to run a commit via [WielderOfAnor](https://github.com/iamsellek/wielder_of_anor)
on repos 1 and 2 because it's another awesome app that you can't live without?
Psh of course. Here's how. *The 1 is optional and only used if you want to skip
the checking for forbidden words.*

`> alfred_git woa "This is a terrible commit message." 1 repo_1 repo_2`

What about those sexy-sounding custom commands you heard about? No problem!
Just send your command as the first parameter. Just keep in mind what I
mentioned about commands with a space in them! Wrap those bad boys in quotes!
So, since this is the examples section, let's say you need to send a `gulp
build` to repos 2 and 4. Since the command is more than one word/has a space
in it, here's how you would do it:

`> alfred_git "gulp build" repo_2 repo_4`

See? Intuitive! Simple! Batman!

## License
The MIT License (MIT)

Copyright (c) 2016 Chris Sellek

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
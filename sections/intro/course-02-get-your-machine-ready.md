# Get Your Machine Ready

You need the Astrona command-line tool, `astrona`. It starts each playground and lab as an Ubuntu 24.04 virtual machine using QEMU, an open-source machine emulator. Node.js, Yarn and Docker are installed inside that virtual machine when it starts, so you do not install them on your own computer. Each playground and lab needs about 2 GiB of free memory and 15 GiB of free disk space.

Check the tool with `astrona check`. Start an environment with `astrona run`, open a shell in it with `astrona ssh` followed by the environment name, check a graded lab with `astrona submit`, and remove an environment with `astrona destroy` followed by the environment name. The page that opens a playground or lab shows the exact commands for it.

The virtual machine downloads packages when it starts, for example Node.js and Docker. It needs internet access from your machine. If a start fails, run `astrona destroy` for the environment, check that the machine has enough memory and disk space, and start again.

The course uses Mermaid diagrams, a text format that the reading interface turns into drawings. If your reader does not display a diagram, the surrounding prose still explains its mechanism. The labs in this course are marked as built but not yet run end to end. If a lab check behaves differently from its task text, report the lab name and the failing check.

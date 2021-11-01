#!/bin/bash
env | grep -q BLUE
env | grep -q RED
env | grep -q CYAN
env | grep -q NC
env | grep -q re


# printf "%s- ${BLUE}makerepo${NC} ${CYAN}<repoLocation>${NC} ${CYAN}<repoName>${NC} - Creates a repository with the user specified name. Or if the directory already exists then it links it to the repository." | fold -s
# printf "%s\n- ${BLUE}openrepo${NC} ${CYAN}<repoName>${NC} - Opens a repository, by specfying the repository's name." | fold -s
# printf "%s\n- ${BLUE}addfiles${NC} ${CYAN}<repoName>${NC} ${CYAN}<file(s)>${NC} - Adds file to the specified repository from the working directory." | fold -s
# printf "%s\n- ${BLUE}checkin${NC} ${CYAN}<repoName>${NC} ${CYAN}<file(s)>${NC} - Checks in the working directory's files to the repository and updates if files have been modified." | fold -s
# printf "%s\n- ${BLUE}checkout${NC} ${CYAN}<repoName>${NC} ${CYAN}<file(s)>${NC} - Replaces the current files within the working directory from the repo.\n\n" | fold -s

# printf "%s\n- ${BLUE}backup${NC} ${CYAN}<repoName>${NC} - Creates a back up of the specified repository's working directory." | fold -s
# printf "%s\n- ${BLUE}editfile${NC} ${CYAN}<file(s)>${NC} - Gives the ability to edit the file within the terminal." | fold -s
# printf "%s\n- ${BLUE}deleterepo${NC} ${CYAN}<repoName>${NC} - Deletes the repository link from the specified directory and from the repository index, also copying the most recent commit to the working directory." | fold -s
# printf "%s\n- ${BLUE}compile${NC} ${CYAN}<compiler>${NC} ${CYAN}<repoName>${NC} - Compiles the working directory, specified by the repository name and compiler. If the compiler is not installed on the system, the script will be interupted.\n\n" | fold -s

# printf "%s\n${RED}ERROR: Page number input does not exist enter anything between 1-2${NC}" | fold -s

echo -e "$(
cat << EOF

- ${BLUE}Create a repository${NC} - This option allows the user to create a repository, by taking in the filepath of a directory and getting a user-defined name for the repository. This works with either a pre-existing directory, or create a new directory that will be linked to a repository.

- ${BLUE}Open a repository${NC} - This option allows the user to open an existing repo and work within the directory that is linked to that repo, by just getting the name of repository.

- ${BLUE}List existing repositories${NC} - This option lists all of the existing repositories made by the user.

- ${BLUE}Delete a repository${NC} - This option allows the user to define the name of an existing repository and remove the link from the directory. It removes the .vc from that directory, and before doing so it gets the latest commit from .vc and replaces whatever is in the directory.

- ${BLUE}Exit current repository${NC} - This option allows the user to exit a repository, only if one has been opened already. Which then allows the user to enter another repository.

- ${BLUE}Create a new file${NC} - Creates a new file within the opened repository's working directory.

- ${BLUE}Check-in files${NC} - Creates a new commit of a directory the user is working in and lets the user to check in as many files as they feel like to that commit.

- ${BLUE}Check-out a file${NC} - Takes the files from the most recent commit and replaces the files within in the directory the user is working in.

- ${BLUE}Rollback to an earlier version of repo${NC} - Rolls-back to a previous commit of the opened repository and replaces files of from that commit.

- ${BLUE}Manage repo permissions${NC} - Allows the user to manage permission of a repo that is defined by the user.

- ${BLUE}Edit a file (automatic check-out/in)${NC} - This option allows the user to edit a file within a directory.

- ${BLUE}Compile files in repo${NC} - This allows the user to compile the files within the repository. \n- ${RED}NOTE:${NC} The current build only supports the ${CYAN}GCC${NC} and ${CYAN}JAVAC${NC} compilers.

- ${BLUE}Archive current repo${NC} - This allows the user to archive the repository that they are working in, either in ${CYAN}.tar${NC}, ${CYAN}.tar.bz2${NC}, ${CYAN}.zip${NC} .

- ${BLUE}List files in current repo${NC} - Lists all of the files that are in the currently opened repository.

- ${BLUE}Password protect repo from deletion${NC} - This allows the user to give a password to a repoisitory, that protects it from deletion.\n\n- E.g. If a repo is password protected, then when the user wants to delete it the user has provided a valid password for the repo to be deleted.

- ${BLUE}Show help${NC} - If you got here, then you know what it does.

- ${BLUE}Quit${NC} - Quits CMS.
EOF
)"
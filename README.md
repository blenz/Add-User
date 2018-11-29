I have provided my solution as a Bash script that will add new users to a Linux server and set up their SSH key authentication. Below are my thoughts on how I wanted to solve this challenge.

Originally, my first thought was to make a Bash script that would ask for a new user’s information (first name, last name, password) and then set up a user with the information provided, but from the prompt, it said that the company would be expanding significantly so I wanted the script to be able to add multiple users in a single run. I decided to have the script read from a generic file with comma separated first and last name ( john,smith ) on each line. The script parses the first and last name and creates a user name with the first initial and last name concatenated ( John Smith —> jsmith ) which is then created on the Linux server.

The script can be ran two different ways. The first way is a first and last name can be passed as arguments to create an individual user. The second way is to have one argument which is a file with comma separated first and last name on each line( jon,smith ).

When the script is executed, it will let the user running the script know who was added and what names were not added. I let the ‘useradd’ command determine whether a name was valid, if not, it’ll let the user know why and continue adding from the list. I ran into the problem if two names were identical then the ‘useradd’ command would fail, so when reading from a file, I added the ability to add another comma with a digit to uniquely identify a name ( john,smith,1 ). Similarly, when adding a single person using the first and last names as arguments, a number can be passed as a third argument (john smith 1).

Below are some assumptions I made:
- This would be used on Ubuntu servers.
- Assigning groups was not important, I would add the ability if needed.
- Set up the user accounts without a password, user’s themselves can change as needed. If required, I would add the ability in the script.


### Sample Uses

`./newuser.sh john smith`

`./newuser.sh john smith 1`

`./newuser.sh testfile`

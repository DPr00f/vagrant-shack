# Dependencies

- vagrant (v1.7.2 or up)
- Python (2 or 3)

# Vagrant Shack
Vagrant Shack allows ubuntu/mac users to create a global shack box and control it without being in the box folder.

## Shack commands

- `--version`		Displays the Shack version
- `help` 			Displays the list of commands
- `up`				Starts the VM
- `destroy`			Removes the VM
- `halt`			Shuts the VM down
- `suspend`			Suspends the VM
- `resume`			Resumes the suspended VM
- `status`			Prints the satus of the VM
- `update`			Updates de base vagrant box
- `ssh`				Log's through SSH to the VM
- `edit`			Opens the Shack.yaml to configure the box and sites to run
- `install`			Install Shack globally (Requires root authorization)


## You can use your own online boxes

If you already have a box on atlas.hashicorp.com just add the link to `atlas.list` and run `./shack install`

e.g. https://atlas.hashicorp.com/Jocolopes


## Building your own vagrant box

Create your packer json file in the templates folder and run `./shack install`

Take `ubuntu.json` as an example.

You can later upload the box saved to `build/<name of the box>.box` to atlas.hashicorp.com. 


## You don't like the way nginx serves the website

That's fine... I don't take it personally and you can change it anyway...

This script was built with Phalcon PHP environment in mind, if you need to change anything change the files in `install/scripts/` and run `./shack install`


# Many Many Thanks

- Thanks to Taylor Otwell and his amazing Homestead script (I had to borrow some files from his script)
- Thanks to Olle Gustafsson and the script for start/suspend boxes on Ubuntu
- Thanks to you for reading this till the end. Hope you enjoy it

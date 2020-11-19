This repo is designed to move data to your own personal Dev Org sandbox as well as create some baseline data in the org for testing purposes

# Necessary Programs to Install
1. NPM (https://nodejs.org/en/) 
   - This allows us to install and manage packages. You can think of packages much like VS Code Extensions or applications you might download to your computer.
   
2. SFDX Data Move Utility (https://github.com/forcedotcom/SFDX-Data-Move-Utility)
   - This is the specific package/application that will allow us to quickly and easily move records over from Production to our Dev Org
 
# Instructions to Install SFDX Data Move Utility (the below takes place in the terminal)
**Step 1.** Clone the file locally. You can clone it into any folder, it does not matter, this is just our installation file: 
- git clone https://github.com/forcedotcom/SFDX-Data-Move-Utility

**Step 2.** Move into the folder (in the terminal) we just created in step 1 with the below command:
- cd SFDX-Data-Move-Utility

**Step 3.** If we correctly moved into the SFDX-Data-Move-Utility folder (and installed NPM), all we need to do is run the below command to install the package: 
- npm install

**Step 4.** Link the Plugin to the Salesforce CLI with the below command: 
- sfdx plugins:link

After installing both programs, or if you already have and skipped those steps, navigate to a folder like Documents (in the Terminal). To do so the command "cd ~" will get you back to your user folder, type "ls" to show all the folders in your user folder, then move into wherever you want to put this repo (like documents)

After you navigate the folder you want this repo to be contained in, run the below
- git clone https://github.com/Bgallahue/OrgStructure.git

then open the OrgStructure folder in VS Code or whatever IDE you are using, like you typically would

The next steps will be contained in the "OrgGenerator.apex" file, which is contained in the scripts folder of OrgStructure/this repo. So open that.

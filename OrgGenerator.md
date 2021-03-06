# Guide - Generate Org Data

-   This file will guide you on moving necessary records over (like billing plans etc.), then we are going to modify any hardcoded Ids to now reference our new records (Step 5).
-   Then lastly we are going to insert some baseline data we can use for testing or for community work

**Step 1.**
if you are not starting with a fresh clone of the repo pull down any changes (this repo is frequently updated, please do this every time) with this command in the TERMINAL:

git pull

**Step 2.**
Authorize your newly refreshed Dev Org if you have not already done so (check status of orgs with "sfdx force:org:list")

-   make sure Production is also valid and authorized. Sometimes it reports the Org as connected but produces an error when running the commands in step 4, 6 and 7. If so i've found quitting VScode and opening it again solves the bug

**Step 3.**
In the Terminal navigate (ie. cd scripts) to the "scripts" folder (this is assuming you are starting out in the current folder "Orgstructure")

**Step 4.**
Run the Command in the terminal:

-   sfdx sfdmu:run --sourceusername PRODUCTIONUSERNAME --targetusername DEVORGUSERNAME
    EXAMPLE COMMAND: sfdx sfdmu:run --sourceusername bgallahue@mycervello.com.evr --targetusername bgallahue@mycervello.com.evr.BGDev

This will move the necessary data over to the Dev Org using the SFDX Data Move Utility, the exports.json file in the scripts folder is what the SFDX Data Move Utility is referencing

**Step 5.**
Deploy the EvolveDataGenerator class to your Dev Org

**Step 6.**
Run the below method from EvolveDataGenerator in ANONYMOUS APEX

-   You can highlight the below and do it right from VS Code, heres how (https://salesforce.stackexchange.com/questions/231715/how-to-run-apex-anonymous-code-from-visual-studio-code)

EvolveDataGenerator.necessaryDataSetup();

**Step 7.** Running the method from EvolveDataGenerator in ANONYMOUS APEX will give a baseline of sample data
Please review the method in the EvolveDataGenerator class to see exactly what was created:

System.enqueueJob(new EvolveDataGenerator.createBasicSampleData());

**Step 8.**
In your Dev Org go to "Setup > Deliverability"
You can auto open your org to that page with the following terminal command

TERMINAL COMMAND: sfdx force:org:open --path "/lightning/setup/OrgEmailSettings/home"

Change Access Level from "No Access" or "System Email Only" to "All Email"
Without this setting updated, emails fired from Apex will generate an error

**Step 9.**
In your Dev Org go to "Setup > Session Settings"

TERMINAL COMMAND: sfdx force:org:open --path "/lightning/setup/SecuritySession/home"

UNSELECT "Enable secure and persistent browser caching to improve performance"
Without this setting any components pushed to the org will not

**Step 10.**
The SF Communities need to be published before they can be accessed by users, go to "Setup > All Pages"

TERMINAL COMMAND: sfdx force:org:open --path "/lightning/setup/SetupNetworks/home"

Then click on Builder for whatever community you need to login to and publish it

**Notes**
All Homeowner and Partners Community Logins have a password of Community_Password_123 if you need to log directly in to the Community.

**FINAL**

You are now done, feel free to delete this repo/folder or keep it and just make sure to pull down the latest data using git pull (Step 1)

There is also some shortcut sObject creators (like is UnitTestFactory) in EvolveDataGenerator so feel free to use those and commit any that you might want to add to the Github repo

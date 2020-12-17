# Guide - Generate Org Data

-   This file will guide you on moving necessary records over (like billing plans etc.), then we are going to modify any hardcoded Ids to now reference our new records (Step 5).
-   Then lastly we are going to insert some baseline data we can use for testing or for community work

**Step 1.**
Authorize your newly refreshed Dev Org if you have not already done so

**Step 2.**
In the Terminal navigate (ie. cd scripts) to the "scripts" folder (this is assuming you are starting out in the current folder "Orgstructure")

**Step 3.**

Run the Command in the terminal:

-   sfdx sfdmu:run --sourceusername PRODUCTIONUSERNAME --targetusername DEVORGUSERNAME
    EXAMPLE COMMAND: sfdx sfdmu:run --sourceusername bgallahue@mycervello.com.evr --targetusername bgallahue@mycervello.com.evr.BGDev

This will move the necessary data over to the Dev Hub using the SFDX Data Move Utility, the exports.json file in the scripts folder is what the SFDX Data Move Utility is referencing

**Step 4.**
Deploy the EvolveDataGenerator class to your Dev Org

**Step 5.**
Run the below method from EvolveDataGenerator in Anonymous Apex

-   You can highlight the below and do it right from VS Code https://salesforce.stackexchange.com/questions/231715/how-to-run-apex-anonymous-code-from-visual-studio-code

EvolveDataGenerator.necessaryDataSetup();

**Step 6.** Running the method from EvolveDataGenerator in Anonymous Apex will give a baseline of sample data
Please review the method in the EvolveDataGenerator class to see exactly what was created but in summary:

-   a Homeowner Account -> Contact -> Community Portal User -> Listing -> Booking
-   A Partner Account -> Contact -> Community Portal User
-   A Traveler Account (which is associated with the booking)

EvolveDataGenerator.createBasicSampleData();

**Step 7.**
In your Dev Org go to "Setup > Deliverability"
You can auto open your org with the following command in the terminal:
sfdx force:org:open
Change Access Level from "No Access" to "All Email"
Without this setting updated, emails fired from Apex will generate an error

**Step 8.**
In your Dev Org go to "Setup > Session Settings"
Unselect "Enable secure and persistent browser caching to improve performance"
Without this setting any components pushed to the org might not update in real time

**Step 9.**
The SF Communities need to be published before they can be accessed by users
"Setup > All Communities", then click on Builder for whatever community you need to login to

You are now done, feel free to delete this repo/folder or keep it and just make sure

There is also some shortcut sObject creators (like is UnitTestFactory) in EvolveDataGenerator so feel free to use those and commit any that you might want to add to the Github repo

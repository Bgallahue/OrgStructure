In the below steps we are first going to move necessary records over (like billing plans etc.), then we are going to modify any hardcoded Ids to 
now reference our new records (Step 5). Then lastly we are going to insert some baseline data we can use for testing or for community work 

// STEP 1. Autorize your Dev Org if you have not already done so

// Step 2. In the Terminal navigate (ie. cd scripts) to the "scripts" folder (this is assuming you are starting out in the current folder "Orgstructure")

// Step 3. Run the Command: sfdx sfdmu:run --sourceusername PRODUCTIONUSERNAME --targetusername DEVORGUSERNAME
// EXAMPLE COMMAND: sfdx sfdmu:run --sourceusername evolveadmin@mycervello.com --targetusername evolveadmin@mycervello.com.BGDev
// This will move the necessary data over to the Dev Hub using the SFDX Data Move Utility, the exports.json file in the scripts folder is what the SFDX Data Move Utility is referencing
// Halfway through running, it will prompt you to respond y/n to a question as we are not bringing over a few unnecessary parent records, please respond with "y".
// It only gives about 5 seconds before cancelling the process, kind of annoying but just respond "y"

// Step 4. Deploy the EvolveDataGenerator class to your Dev Org

// Step 5. Run the below in Anonymous Apex (You can highlight the below and do it right from VS Code https://salesforce.stackexchange.com/questions/231715/how-to-run-apex-anonymous-code-from-visual-studio-code))
EvolveDataGenerator.necessaryDataSetup();

// Step 6. Running the below in Anonymous Apex will give a baseline of sample data
// Please review the method to see what was created but in summary, a Homeowner Account -> Contact -> Community Portal User -> Listing -> Booking
// A Partner Account -> Contact -> Community Portal User
// A Traveler Account (which is associated with the booking)
EvolveDataGenerator.createBasicSampleData();

// Step 7. In your Dev Org go to "Setup > Email Administration > Deliverability"
// Change Access Level from "No Access" to "All Email"
// Without this setting modified emails fired from Apex will generate an error

You are now done, feel free to delete this repo/folder. You should be cloning a new one each time you create a Dev Org (or if you want to just keep the same 
repo and are comfortable diffing and merging changes then feel free to do so). The reason being is we might need to update the methods of EvolveDataGenerator or 
another part of this process so that we keep it in line with Production and your Dev Org doesnt generate errors while you work in it.

There is also some shortcut sObject creators (like is UnitTestFactory) in EvolveDataGenerator so feel free to use those and commit any that you might want to add to the Github repo



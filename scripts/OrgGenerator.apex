// STEP 1. In the Terminal navigate (ie. cd scripts) to the "scripts" folder (this is assuming you are starting out in the current folder "Orgstructure")

// Step 2. Run the Command sfdx sfdmu:run --sourceusername PRODUCTIONUSERNAME --targetusername DEVHUBUSERNAME
    // This will move the necessary data over to the Dev Hub, the exports.json file in the scripts folder is what we are using

// Step 3. Push the EvolveDataGenerator class to your Dev Org

// Step 4. Run the below in Anonymous Apex
EvolveDataGenerator.necessaryDataSetup();

// Step 5. Running the below in Anonymous Apex will give a baseline of sample data
EvolveDataGenerator.createBasicSampleData()


// Miscellaneous In Org Settings to Complete

// Go to "Setup > Email Administration > Deliverability"
// Change Access Level from "No Access" to "All Email"
// Without this emails fired from Apex will generate an error
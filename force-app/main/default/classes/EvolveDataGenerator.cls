public with sharing class EvolveDataGenerator {
    public static Map<String, String> billingPlanMap = new Map<String, String>{
        'Billing_Plan_1_0__c' => 'Immediate 1.0 - Moderate',
        'Billing_Plan_2_0__c' => 'Immediate 2.0 - Moderate',
        'Billing_Plan_3_0__c' => 'Check-In',
        'Billing_Plan_1_0_Flexbile__c' => 'Immediate 1.0 - Flexible',
        'Billing_Plan_1_0_Strict__c' => 'Immediate 1.0 - Strict',
        'Billing_Plan_AZ__c' => 'Check-In AZ',
        'Current_Remitted_Default__c' => 'Check-In 2.0 Remitted New',
        'Current_Default__c' => 'Check-In 2.0 New'
    };
    public static Id Account_HomeOwner_RTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
        .get('Home_Owner')
        .getRecordTypeId();
    public static Id Account_Partner_RTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
        .get('Partner')
        .getRecordTypeId();
    public static Id Account_Traveler_RTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
        .get('Traveler')
        .getRecordTypeId();
    public static Id Listing_Listing_RTId = Schema.SObjectType.Listing__c.getRecordTypeInfosByDeveloperName()
        .get('Listing')
        .getRecordTypeId();
    public static Id PostOBHomeownerMPL_PROFId = [
        SELECT ID, Name
        FROM Profile
        WHERE Name = 'Evolve Post-Onboarding Home Owner MPL'
        LIMIT 1
    ]
    .Id;
    public static Id PartnerMPL_PROFId = [SELECT ID, Name FROM Profile WHERE Name = 'Evolve Partner MPL' LIMIT 1].Id;

    public static void necessaryDataSetup() {
        Map<String, Billing_Plan__c> bPlanMap = new Map<String, Billing_Plan__c>();
        for (Billing_Plan__c bp : [SELECT Id, Name FROM Billing_Plan__c]) {
            bPlanMap.put(bp.name, bp);
        }

        Billing_Plan_Settings__c bps = Billing_Plan_Settings__c.getOrgDefaults();

        for (String key : billingPlanMap.keyset()) {
            bps.put(key, bPlanMap.get(EvolveDataGenerator.billingPlanMap.get(key)).Id);
        }

        update bps;

        RingLeadTrigger__Batch_Settings__c b = new RingLeadTrigger__Batch_Settings__c();
        insert b;
    }

    public static Account sampleAccount(Id acctRecordTypeId, String acctName, String acctEmail) {
        return new Account(RecordTypeID = acctRecordTypeId, Name = acctName, Account_Email__c = acctEmail);
    }

    public static Account samplePersonAccount(Id acctRecordTypeId, String acctFirstName, String acctLastName, String acctEmail) {
        return new Account(
            RecordTypeID = acctRecordTypeId,
            FirstName = acctFirstName,
            LastName = acctLastName,
            Account_Email__c = acctEmail
        );
    }

    public static Account sampleContact(Id acctId, String contactFirstName, String contactLastName, String contactEmail) {
        return new Contact(AccountID = acctId, FirstName = contactFirstName, LastName = contactLastName, Email = contactEmail);
    }

    // SHORTCUT DATA CREATORS
    public static void createBasicSampleData() {
        List<Account> acctsToInsert = new List<Account>();
        List<Contact> contactsToInsert = new List<Contact>();
        List<User> usersToInsert = new List<User>();
        List<Listing__c> listingsToInsert = new List<Listing__c>();
        List<Booking__c> bookingsToInsert = new List<Booking__c>();

        acctsToInsert.add(
            EvolveDataGenerator.sampleAccount(Account_HomeOwner_RTId, 'Jill Homeowner', 'JillHomeowner@gmail.com.test')
        );

        acctsToInsert.add(EvolveDataGenerator.sampleAccount(Account_Partner_RTId, 'Jill Partner', 'JillPartner@gmail.com.test'));
        acctsToInsert[1].Business_Type__c = 'Full On-site Services';

        acctsToInsert.add(
            EvolveDataGenerator.samplePersonAccount(Account_Traveler_RTId, 'Joe', 'Traveler', 'JoeTraveler@gmail.com.test')
        );
        insert acctsToInsert;

        contactsToInsert.add(
            EvolveDataGenerator.sampleContact(acctsToInsert[1].Id, 'Jill', 'Partner', 'JillPartner@gmail.com.test')
        );

        contactsToInsert.add(
            EvolveDataGenerator.sampleContact(acctsToInsert[2].Id, 'Joe', 'Traveler', 'JoeTraveler@gmail.com.test')
        );

        insert contactsToInsert;

        usersToInsert.add(
            new User(
                FirstName = 'Jill',
                LastName = 'Homeowner',
                Email = 'JillHomeowner@gmail.com.test',
                UserName = 'JillHomeowner@gmail.com.test',
                Alias = 'tuser',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/Denver',
                ProfileID = PostOBHomeownerMPL_PROFId,
                ContactID = contactsToInsert[0].Id,
                CommunityNickname = 'JHomeOwner'
            )
        );

        usersToInsert.add(
            new User(
                FirstName = 'Jill',
                LastName = 'Partner',
                Email = 'JillPartner@gmail.com.test',
                UserName = 'JillPartner@gmail.com.test',
                Alias = 'tuser',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/Denver',
                ProfileID = PartnerMPL_PROFId,
                ContactID = contactsToInsert[1].Id,
                CommunityNickname = 'JPartner'
            )
        );

        insert usersToInsert;

        listingsToInsert.add(new Listing__c(RecordTypeID = Listing_Listing_RTId, Account__c = acctsToInsert[0].Id));

        insert listingsToInsert;

        bookingsToInsert.add(
            new Booking__c(
                Listing__c = listingsToInsert[0].Id,
                Type__c = 'Evolve',
                Status__c = 'Booked',
                Check_In__c = Date.today().addDays(31),
                Check_Out__c = Date.today().addDays(35),
                Traveler__c = acctsToInsert[2].Id
            )
        );

        insert bookingsToInsert;
    }
}

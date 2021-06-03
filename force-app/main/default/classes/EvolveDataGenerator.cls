public with sharing class EvolveDataGenerator {
    public static Map<String, String> billingPlanMap = new Map<String, String>{
        'Billing_Plan_1_0__c' => 'Immediate 1.0 - Moderate',
        'Billing_Plan_2_0__c' => 'Immediate 2.0 - Moderate',
        'Billing_Plan_3_0__c' => 'Check-In',
        'Billing_Plan_1_0_Flexbile__c' => 'Immediate 1.0 - Flexible',
        'Billing_Plan_1_0_Strict__c' => 'Immediate 1.0 - Strict',
        'Billing_Plan_AZ__c' => 'Check-In AZ',
        'Current_Remitted_Default__c' => 'Check-In 2.20 Remitted',
        'Nevada_Billing_Plan__c' => 'Check-In 2.20 (Nevada)',
        'Current_Default__c' => 'Check-In 2.20'
    };

    public static Map<String, List<String>> permSetMap = new Map<String, List<String>>{
        'allPermSets' => new List<String>{
            'Community_Home_Owner_Test',
            'Package_RingLead',
            'Geopointe_Base_Permissions',
            'Blackthorn_Payments_Community_User',
            'Custom_Metadata_Type_Access',
            'Community_Partner'
        },
        'homeownerPermSet' => new List<String>{
            'Community_Home_Owner_Test',
            'Package_RingLead',
            'Geopointe_Base_Permissions',
            'Blackthorn_Payments_Community_User'
        },
        'partnerPermSet' => new List<String>{
            'Package_RingLead',
            'Geopointe_Base_Permissions',
            'Blackthorn_Payments_Community_User',
            'Custom_Metadata_Type_Access',
            'Community_Partner'
        }
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

    public static List<bt_stripe__Payment_Gateway__c> defaultGateway = [
        SELECT Id, bt_stripe__Test_Mode__c, bt_stripe__Stripe_User_Email__c
        FROM bt_stripe__Payment_Gateway__c
        WHERE bt_stripe__Default__c = TRUE
    ];

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

    public static Contact sampleContact(Id acctId, String contactFirstName, String contactLastName, String contactEmail) {
        return new Contact(AccountID = acctId, FirstName = contactFirstName, LastName = contactLastName, Email = contactEmail);
    }

    public static User sampleUser(String email, String firstName, String lastName, Id profileId) {
        User result = new User();
        result.Email = email;
        result.FirstName = firstName;
        result.LastName = lastName;
        result.UserName = email;
        result.Alias = 'tuser';
        result.EmailEncodingKey = 'UTF-8';
        result.LanguageLocaleKey = 'en_US';
        result.LocaleSidKey = 'en_US';
        result.TimeZoneSidKey = 'America/Denver';
        result.ProfileID = profileId;

        return result;
    }

    public static User samplePortalUser(
        String email,
        String firstName,
        String lastName,
        Id profileId,
        ID portalUserContactID,
        String nickname
    ) {
        User result = EvolveDataGenerator.sampleUser(email, firstName, lastName, profileId);
        result.ContactID = portalUserContactID;
        result.CommunityNickname = nickname;

        return result;
    }

    public static Listing__c sampleListing(ID recordTypeID, ID accountID) {
        Listing__c result = new Listing__c();
        result.RecordTypeID = recordTypeID;
        result.Account__c = accountID;

        return result;
    }

    public static Booking__c sampleBooking(
        ID listingId,
        String bookingType,
        String bookingStatus,
        Integer checkInDays,
        Integer checkOutDays,
        Id travelerId
    ) {
        Booking__c result = new Booking__c();
        result.Listing__c = listingId;
        result.Type__c = bookingType;
        result.Status__c = bookingStatus;
        result.Check_In__c = Date.today().addDays(checkInDays);
        result.Check_Out__c = Date.today().addDays(checkOutDays);
        result.Traveler__c = travelerId;

        return result;
    }

    public static ListingContactRole__c sampleListingContactRole(Id listingId, Id contactId, String role) {
        ListingContactRole__c result = new ListingContactRole__c();

        result.Listing__c = listingId;
        result.Contact__c = contactId;
        result.Role__c = role;
        return result;
    }

    public class createBasicSampleData implements Queueable {
        public void execute(QueueableContext context) {
            EvolveDataGenerator.jillDataVertical();
            EvolveDataGenerator.bobDataVertical();
            EvolveDataGenerator.larryDataVertical();
        }
    }

    public static void jillDataVertical() {
        List<Account> acctsToInsert = new List<Account>();
        List<Contact> contactsToInsert = new List<Contact>();
        List<User> usersToInsert = new List<User>();
        List<Listing__c> listingsToInsert = new List<Listing__c>();
        List<Booking__c> bookingsToInsert = new List<Booking__c>();
        List<ListingContactRole__c> listingContactRolesToInsert = new List<ListingContactRole__c>();

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
            EvolveDataGenerator.sampleContact(acctsToInsert[0].Id, 'Jill', 'Homeowner', 'JillHomeowner@gmail.com.test')
        );

        contactsToInsert.add(
            EvolveDataGenerator.sampleContact(acctsToInsert[1].Id, 'Jill', 'Partner', 'JillPartner@gmail.com.test')
        );

        insert contactsToInsert;

        usersToInsert.add(
            EvolveDataGenerator.samplePortalUser(
                'JillHomeowner@gmail.com.test',
                'Jill',
                'Homeowner',
                EvolveDataGenerator.PostOBHomeownerMPL_PROFId,
                contactsToInsert[0].Id,
                'JHomeOwner'
            )
        );

        usersToInsert.add(
            EvolveDataGenerator.samplePortalUser(
                'JillPartner@gmail.com.test',
                'Jill',
                'Partner',
                EvolveDataGenerator.PartnerMPL_PROFId,
                contactsToInsert[1].Id,
                'JPartner'
            )
        );
        insert usersToInsert;

        linkPermissionSets(new List<Id>{ usersToInsert[0].Id }, new List<Id>{ usersToInsert[1].Id });

        listingsToInsert.add(EvolveDataGenerator.sampleListing(Listing_Listing_RTId, acctsToInsert[0].Id));
        insert listingsToInsert;

        listingContactRolesToInsert.add(
            EvolveDataGenerator.sampleListingContactRole(listingsToInsert[0].Id, contactsToInsert[0].Id, 'Property Owner')
        );
        listingContactRolesToInsert.add(
            EvolveDataGenerator.sampleListingContactRole(listingsToInsert[0].Id, contactsToInsert[1].Id, 'Partner')
        );

        insert listingContactRolesToInsert;

        bookingsToInsert.add(
            EvolveDataGenerator.sampleBooking(listingsToInsert[0].Id, 'Evolve', 'Booked', 25, 30, acctsToInsert[2].Id)
        );
        bookingsToInsert.add(
            EvolveDataGenerator.sampleBooking(listingsToInsert[0].Id, 'Evolve', 'Booked', -30, -25, acctsToInsert[2].Id)
        );

        bookingsToInsert.add(
            EvolveDataGenerator.sampleBooking(listingsToInsert[0].Id, 'Owner', 'Booked', 15, 20, acctsToInsert[0].Id)
        );
        bookingsToInsert.add(
            EvolveDataGenerator.sampleBooking(listingsToInsert[0].Id, 'Owner', 'Booked', -20, -15, acctsToInsert[0].Id)
        );

        insert bookingsToInsert;
    }

    public static void bobDataVertical() {
        List<Account> acctsToInsert = new List<Account>();
        List<Contact> contactsToInsert = new List<Contact>();
        List<User> usersToInsert = new List<User>();
        List<Listing__c> listingsToInsert = new List<Listing__c>();
        List<Booking__c> bookingsToInsert = new List<Booking__c>();
        List<ListingContactRole__c> listingContactRolesToInsert = new List<ListingContactRole__c>();

        acctsToInsert.add(
            EvolveDataGenerator.sampleAccount(Account_HomeOwner_RTId, 'Bob Homeowner', 'BobHomeowner@gmail.com.test')
        );

        acctsToInsert.add(EvolveDataGenerator.sampleAccount(Account_Partner_RTId, 'Bob Partner', 'BobPartner@gmail.com.test'));
        acctsToInsert[1].Business_Type__c = 'Full On-site Services';

        acctsToInsert.add(
            EvolveDataGenerator.samplePersonAccount(Account_Traveler_RTId, 'Jack', 'Traveler', 'JackTraveler@gmail.com.test')
        );
        insert acctsToInsert;

        contactsToInsert.add(
            EvolveDataGenerator.sampleContact(acctsToInsert[0].Id, 'Bob', 'Homeowner', 'BobHomeowner@gmail.com.test')
        );

        contactsToInsert.add(
            EvolveDataGenerator.sampleContact(acctsToInsert[1].Id, 'Bob', 'Partner', 'BobPartner@gmail.com.test')
        );

        insert contactsToInsert;

        usersToInsert.add(
            EvolveDataGenerator.samplePortalUser(
                'BobHomeowner@gmail.com.test',
                'Bob',
                'Homeowner',
                EvolveDataGenerator.PostOBHomeownerMPL_PROFId,
                contactsToInsert[0].Id,
                'BHomeOwner'
            )
        );

        usersToInsert.add(
            EvolveDataGenerator.samplePortalUser(
                'BobPartner@gmail.com.test',
                'Bob',
                'Partner',
                EvolveDataGenerator.PartnerMPL_PROFId,
                contactsToInsert[1].Id,
                'BPartner'
            )
        );

        insert usersToInsert;

        linkPermissionSets(new List<Id>{ usersToInsert[0].Id }, new List<Id>{ usersToInsert[1].Id });

        listingsToInsert.add(EvolveDataGenerator.sampleListing(Listing_Listing_RTId, acctsToInsert[0].Id));
        insert listingsToInsert;

        listingContactRolesToInsert.add(
            EvolveDataGenerator.sampleListingContactRole(listingsToInsert[0].Id, contactsToInsert[0].Id, 'Property Owner')
        );
        listingContactRolesToInsert.add(
            EvolveDataGenerator.sampleListingContactRole(listingsToInsert[0].Id, contactsToInsert[1].Id, 'Partner')
        );

        insert listingContactRolesToInsert;

        bookingsToInsert.add(
            EvolveDataGenerator.sampleBooking(listingsToInsert[0].Id, 'Evolve', 'Booked', 25, 30, acctsToInsert[2].Id)
        );
        bookingsToInsert.add(
            EvolveDataGenerator.sampleBooking(listingsToInsert[0].Id, 'Evolve', 'Booked', -30, -25, acctsToInsert[2].Id)
        );

        bookingsToInsert.add(
            EvolveDataGenerator.sampleBooking(listingsToInsert[0].Id, 'Owner', 'Booked', 15, 20, acctsToInsert[0].Id)
        );
        bookingsToInsert.add(
            EvolveDataGenerator.sampleBooking(listingsToInsert[0].Id, 'Owner', 'Booked', -20, -15, acctsToInsert[0].Id)
        );

        insert bookingsToInsert;
    }

    public static void larryDataVertical() {
        List<Account> acctsToInsert = new List<Account>();
        List<Contact> contactsToInsert = new List<Contact>();
        List<User> usersToInsert = new List<User>();
        List<Listing__c> listingsToInsert = new List<Listing__c>();
        List<Booking__c> bookingsToInsert = new List<Booking__c>();
        List<ListingContactRole__c> listingContactRolesToInsert = new List<ListingContactRole__c>();

        acctsToInsert.add(
            EvolveDataGenerator.sampleAccount(Account_HomeOwner_RTId, 'Larry Homeowner', 'LarryHomeowner@gmail.com.test')
        );

        acctsToInsert.add(
            EvolveDataGenerator.sampleAccount(Account_Partner_RTId, 'Larry Partner', 'LarryPartner@gmail.com.test')
        );
        acctsToInsert[1].Business_Type__c = 'Full On-site Services';

        acctsToInsert.add(
            EvolveDataGenerator.samplePersonAccount(Account_Traveler_RTId, 'Jared', 'Traveler', 'JaredTraveler@gmail.com.test')
        );
        insert acctsToInsert;

        contactsToInsert.add(
            EvolveDataGenerator.sampleContact(acctsToInsert[0].Id, 'Larry', 'Homeowner', 'LarryHomeowner@gmail.com.test')
        );

        contactsToInsert.add(
            EvolveDataGenerator.sampleContact(acctsToInsert[1].Id, 'Larry', 'Partner', 'LarryPartner@gmail.com.test')
        );

        insert contactsToInsert;

        usersToInsert.add(
            EvolveDataGenerator.samplePortalUser(
                'LarryHomeowner@gmail.com.test',
                'Larry',
                'Homeowner',
                EvolveDataGenerator.PostOBHomeownerMPL_PROFId,
                contactsToInsert[0].Id,
                'LHomeOwner'
            )
        );

        usersToInsert.add(
            EvolveDataGenerator.samplePortalUser(
                'LarryPartner@gmail.com.test',
                'Larry',
                'Partner',
                EvolveDataGenerator.PartnerMPL_PROFId,
                contactsToInsert[1].Id,
                'LPartner'
            )
        );

        insert usersToInsert;

        linkPermissionSets(new List<Id>{ usersToInsert[0].Id }, new List<Id>{ usersToInsert[1].Id });

        listingsToInsert.add(EvolveDataGenerator.sampleListing(Listing_Listing_RTId, acctsToInsert[0].Id));
        insert listingsToInsert;

        listingContactRolesToInsert.add(
            EvolveDataGenerator.sampleListingContactRole(listingsToInsert[0].Id, contactsToInsert[0].Id, 'Property Owner')
        );
        listingContactRolesToInsert.add(
            EvolveDataGenerator.sampleListingContactRole(listingsToInsert[0].Id, contactsToInsert[1].Id, 'Partner')
        );

        insert listingContactRolesToInsert;

        bookingsToInsert.add(
            EvolveDataGenerator.sampleBooking(listingsToInsert[0].Id, 'Evolve', 'Booked', 25, 30, acctsToInsert[2].Id)
        );
        bookingsToInsert.add(
            EvolveDataGenerator.sampleBooking(listingsToInsert[0].Id, 'Evolve', 'Booked', -30, -25, acctsToInsert[2].Id)
        );

        bookingsToInsert.add(
            EvolveDataGenerator.sampleBooking(listingsToInsert[0].Id, 'Owner', 'Booked', 15, 20, acctsToInsert[0].Id)
        );
        bookingsToInsert.add(
            EvolveDataGenerator.sampleBooking(listingsToInsert[0].Id, 'Owner', 'Booked', -20, -15, acctsToInsert[0].Id)
        );

        insert bookingsToInsert;
    }

    @future
    public static void linkPermissionSets(List<Id> homeownerUsers, List<Id> partnerUsers) {
        List<PermissionSetAssignment> permSetAssignsToInsert = new List<PermissionSetAssignment>();
        List<PermissionSet> permSetList = [SELECT Id, Name FROM PermissionSet WHERE Name IN :permSetMap.get('allPermSets')];
        for (PermissionSet permSet : permSetList) {
            List<String> homeownerPerm = permSetMap.get('homeownerPermSet');
            List<String> partnerPerm = permSetMap.get('partnerPermSet');

            if (homeownerPerm.contains(permSet.Name)) {
                for (Id ho : homeownerUsers) {
                    permSetAssignsToInsert.add(new PermissionSetAssignment(AssigneeId = ho, PermissionSetId = permSet.Id));
                }
            }
            if (partnerPerm.contains(permSet.Name)) {
                for (Id p : partnerUsers) {
                    permSetAssignsToInsert.add(new PermissionSetAssignment(AssigneeId = p, PermissionSetId = permSet.Id));
                }
            }
        }

        insert permSetAssignsToInsert;
    }
}

@isTest
private class ProjectRESTServiceTest {
    private static final String PROJECT_REF = '12345';
    private static final String PROJECT_NAME = 'Project Name';

    private static final String NONEXISTING_PROJECT_REF = '00000';
    private static final String CLOSED_WON = 'Closed/Won';

    private static final String PROJECT_STATUS_RUN = 'Running';

    @testSetup static void setup() {
        List<Opportunity> opps = OpportunityFactory.createOpportunities(2, 'Prospecting');
        insert opps;

        Project__c project = new Project__c();
        project.ProjectRef__c = PROJECT_REF;
        project.Opportunity__c = opps[0].Id;
        insert project;
    }

   static void compareTestResult(Opportunity testOpp, String projectRef, Integer projectsSize) {
        Opportunity opp = [SELECT Id, Name, DeliveryInstallationStatus__c FROM Opportunity Where Id = :testOpp.Id];

        List<Project__c> projects = [SELECT Name, Status__c, ProjectRef__c 
                                      FROM Project__c
                                      WHERE Opportunity__c =: opp.Id
                                      ];
        System.assertEquals(projectsSize, projects.size());

        Project__c project;
        for( Project__c p :projects){
            if(p.ProjectRef__c == projectRef) {
              project = p;
              break;
            }
        }
        
        if(projectsSize > 0){
          System.assertEquals('In progress', opp.DeliveryInstallationStatus__c);
          System.assertEquals(PROJECT_NAME, project.Name);
          System.assertEquals(PROJECT_STATUS_RUN, project.Status__c);
        }else{
          System.assertNotEquals('In progress', opp.DeliveryInstallationStatus__c);
        }
    }
    @isTest static void testPostCreate() {
        Opportunity opp = [SELECT Id, Name FROM Opportunity Order by Name Limit 1];

        Test.startTest();
        String result = ProjectRESTService.postProjectData(
                NONEXISTING_PROJECT_REF, PROJECT_NAME, opp.Id, Date.today(), Date.today().addYears(1), 100, PROJECT_STATUS_RUN);
        Test.stopTest();
        
        System.assertEquals('OK', result);
        compareTestResult(opp, NONEXISTING_PROJECT_REF, 2);
    }

    @isTest static void testPostUpdate() {
        Opportunity opp = [SELECT Id, Name FROM Opportunity Order by Name Limit 1];

        Test.startTest();
        String result = ProjectRESTService.postProjectData(
                PROJECT_REF, PROJECT_NAME, opp.Id, Date.today(), Date.today().addYears(1), 100, PROJECT_STATUS_RUN);
        Test.stopTest();

        System.assertEquals('OK', result);
        compareTestResult(opp, PROJECT_REF, 1);
    }

    @isTest static void testPostInvalidOpportunityId() {
        List<Opportunity> opps = [SELECT Id, Name FROM Opportunity Order by Name];

        Id InvalidOpportunityId = opps[0].Id;
        delete opps[0];

        Test.startTest();
        String result = ProjectRESTService.postProjectData(
                PROJECT_REF, PROJECT_NAME, InvalidOpportunityId, Date.today(), Date.today().addYears(1), 100, PROJECT_STATUS_RUN);
        Test.stopTest();

        System.assertNotEquals('OK', result);
        compareTestResult(opps[1], null, 0);
    }
}
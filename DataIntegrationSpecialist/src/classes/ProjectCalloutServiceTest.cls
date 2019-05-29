@isTest
private class ProjectCalloutServiceTest {

  private static List<Opportunity> getOpportunities(Set<Id> ids) {
    return [
            Select 
                StageName 
            From
                Opportunity
            Where
                Id IN : ids
        ];
        
    }

  @TestSetup
  private static void setup(){
    //custom setting
    ServiceTokens__c st = new ServiceTokens__c(
      name = ProjectCalloutService.PROJECT_SERVICE_TOKEN_NAME,
      Token__c = 'test_service_token'
    );
    insert st;
  }

  @isTest
  private static void testEmpty() {
    Opportunity opp = OpportunityFactory.createOpportunitiy(ProjectCalloutService.STAGE_PROSPECTING);
    insert opp;

    Test.startTest();
    ProjectCalloutService.postOpportunityToPMS(new List<Id>{opp.Id});
    Test.stopTest();

    List<Opportunity> Opportunities = getOpportunities(new Set<Id>{opp.Id});
    System.assertEquals(ProjectCalloutService.STAGE_PROSPECTING, Opportunities.get(0).StageName);
  }

  @isTest
  private static void testFailure() {
    Opportunity opp = OpportunityFactory.createOpportunitiy(ProjectCalloutService.STAGE_CLOSED_WON);
    insert opp;

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
    ProjectCalloutService.postOpportunityToPMS(new List<Id>{opp.Id});
    Test.stopTest();

    List<Opportunity> Opportunities = getOpportunities(new Set<Id>{opp.Id});
    System.assertEquals(ProjectCalloutService.STAGE_RESUBMIT_PROJECT, Opportunities.get(0).StageName);
  }

   @isTest
  private static void testSuccess() {
    Opportunity opp = OpportunityFactory.createOpportunitiy(ProjectCalloutService.STAGE_CLOSED_WON);
    insert opp;

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
    ProjectCalloutService.postOpportunityToPMS(new List<Id>{opp.Id});
    Test.stopTest();

    List<Opportunity> Opportunities = getOpportunities(new Set<Id>{opp.Id});
    System.assertEquals(ProjectCalloutService.STAGE_Submitted_PROJECT, Opportunities.get(0).StageName);
  }
}
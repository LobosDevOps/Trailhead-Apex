public class ProjectCalloutService {
    //custom setting data
    public static final String PROJECT_SERVICE_TOKEN_NAME = 'ProjectServiceToken';

    public static final String STAGE_PROSPECTING = 'Prospecting';
    public static final String STAGE_CLOSED_WON = 'Closed Won';
    public static final String STAGE_RESUBMIT_PROJECT = 'Resubmit Projec';
    public static final String STAGE_Submitted_PROJECT = 'Submitted Project';

    //Complete the implementation for business and callout logic
    @InvocableMethod(label='Callout POST opps to PMS')
	public static void postOpportunityToPMS(List<Id> oppIds){   
        if(!oppIds.isEmpty()) 
            System.enqueueJob(new QueueablePMSCall(oppIds.get(0)));
    }

    //System.Queueable future メソッドと同様に非同期処理のジョブを送信できます
    //Database.AllowsCallouts Apex の一括処理の使用
    public class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {
        
        private Id oppId;
        
        public QueueablePMSCall(Id oppId){
            this.oppId = oppId;
        }
        
        public void execute(System.QueueableContext ctx){
            System.debug('execute oppId: ' + oppId);
            // query opp
            List<Opportunity> opportunities = [Select Id, Name, Account.Name, CloseDate, Amount 
                                              from Opportunity where Id=:oppId 
                                              and StageName = :STAGE_CLOSED_WON ];
            System.debug('opportunities: ' + opportunities);
            if (opportunities.isEmpty()){
                // handle error
                return;
            }
            
            // create heep request with all headerts
            HttpRequest request = createRequest(opportunities.get(0));
            System.debug('request: ' + request);
            
            // send
            HttpResponse response = new Http().send(request);
            System.debug('response: ' + response);
            
            // update
            Opportunity opp = new Opportunity(Id = oppId);
            if (response.getStatusCode() != 201) {
                opp.StageName = STAGE_RESUBMIT_PROJECT;
            } else {
				opp.StageName = STAGE_Submitted_PROJECT;                             
            }
            update opp;
        }
        
        private HttpRequest createRequest(Opportunity opp) {
            String token = ServiceTokens__c.getInstance(PROJECT_SERVICE_TOKEN_NAME).Token__c;
            
            HttpRequest request = new HttpRequest();
            
            request.setEndpoint('callout:ProjectService');
            request.setMethod('POST');
            request.setHeader('token', token);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setBody(serializeOpp(opp));
            
            return request;
        }
        
        private String serializeOpp(Opportunity opp) {
            return '{' +
                	'"opportunityId": "' + opp.Id + '", ' +
					'"opportunityName": "' + opp.Name + '", ' +
					'"accountName": "' + opp.Account.Name + '", ' +
					'"closeDate": "' + opp.CloseDate + '", ' +
					'"amount": "' + opp.Amount + '", ' +
                	'}';
        }
        
    }
}
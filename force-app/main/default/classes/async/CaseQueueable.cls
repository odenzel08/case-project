public with sharing class CaseQueueable implements Queueable{
    
    private List<Case> caseToProcess;

    public CaseQueueable(List<Case> cases){
        this.caseToProcess = cases;
    }

    public void execute(QueueableContext context){

        Group queueAgent = [
            SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Agentes'
        ];
        
        List<Case> casesToUpdate = new List<Case>();

        for (Case cs : caseToProcess){
            cs.OwnerId = queueAgent.Id;
        }
        update casesToUpdate;
    }
}
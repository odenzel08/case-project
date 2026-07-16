public with sharing class CaseQueueable {
    
    private List<Case> caseToProcess;

    public CaseQueueable(List<Case> cases){
        this.caseToProcess = cases;
    }

    public void execute(QueueableContext context){

        ServiceChannel caseChannel = [
            SELECT Id FROM ServiceChannel WHERE DeveloperName = 'Caso_Canal'
        ];

        Group queueAgent = [
            SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Agentes'
        ];

        List<PendindServiceRouting> psrToInsert = new List<PendindServiceRouting>();

        for (Case cs : cases){
            PendindServiceRouting psr = new PendindServiceRouting();
            psr.WorkItemId = cs.Id;
            psr.ServiceChannelId = caseChannel.Id;
            psr.GroupId = queueAgent.Id;
            psr.RoutingType = 'QueueBased';         
            psr.RoutingModel = 'Most Available';
            psr.IsReadyForRouting = true;
            psrToInsert.add(psr);
        }
        insert psr;
    }
}
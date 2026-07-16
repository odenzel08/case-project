public class CaseBatchApex implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Coletar registros para processamento
        return Database.getQueryLocator(
                [SELECT Id, OwnerId, IsEscalated, Status 
                FROM Case 
                WHERE Priority = 'High' AND 
                CreatedDate = LAST_N_DAYS:2 AND Status != 'Closed']
            );
    }
    
    
    public void execute(Database.BatchableContext bc, List<Case> records) {
       // Processar cada lote de registros
       
       List<Case> caseToUpdate = new List<Case>();
       Group queueEscaleted = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Casos_Escalados'];

       for (Case cs : records){
            if(cs.Status != 'Escalated'){
                cs.IsEscalated = true;
                cs.OwnerId = queueEscaleted.Id;
                cs.Status = 'Escalated';
                caseToUpdate.add(cs);
            }       
       }
       if(!caseToUpdate.isEmpty()){
            update caseToUpdate;
       }    

    }
    
    public void finish(Database.BatchableContext bc) {
        // Operações pós-processamento
        System.debug('Lote processado!');
    
    }

}

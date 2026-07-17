public with sharing class CaseTriggerHandler {
    public static void run (List<Case> newCases, TriggerOperation op){
        if (op == TriggerOperation.AFTER_INSERT){
            validateCase(newCases);
        }
    }

    public static void validateCase(List<Case> cases){

    List<Case> withoutOwner = new List<Case>();

        for (Case cs : cases){
            if(cs.Priority == 'High' && cs.OwnerId == null){
                withoutOwner.add(cs);
            }

            System.enqueuejob(new CaseQueueable(withoutOwner));
        }
    }
}
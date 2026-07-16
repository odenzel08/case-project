trigger CaseTrigger on Case (after insert) {
    CaseTriggerHandler.run(Trigger.new, Trigger.operationType);
}
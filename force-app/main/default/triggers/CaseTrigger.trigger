trigger CaseTrigger on Case (afte insert) {
    CaseTriggerHandler.run(Trigger.new, Trigger.operationType);
}
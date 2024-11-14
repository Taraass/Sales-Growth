public with sharing class LeadController {
    @AuraEnabled(cacheable=true)
    public static List<Lead> getLeads() {
        return [SELECT Id, Name, Industry FROM Lead LIMIT 50];
    }
}
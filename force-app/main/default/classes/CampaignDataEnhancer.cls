public class CampaignDataEnhancer {
    public static void enhanceAllCampaigns() {

        List<Campaign> campaignsToUpdate = [
            SELECT Id, Name, Status, StartDate, BudgetedCost, EndDate, ExpectedRevenue, ActualCost, 
                   ExpectedResponse, Campaign_Score__c, Campaign_Top_Positives__c, NumberOfLeads, 
                   Campaign_Top_Negatives__c, NumberOfConvertedLeads, AmountWonOpportunities, 
                   NumberOfOpportunities, NumberOfWonOpportunities, AmountAllOpportunities
            FROM Campaign
        ];
        
        for (Campaign campaign : campaignsToUpdate) {
            
            campaign.Campaign_Score__c = calculateScore(campaign);
            
            campaign.Campaign_Top_Positives__c = getTopPositives(campaign);
            campaign.Campaign_Top_Negatives__c = getTopNegatives(campaign);
        }

        update campaignsToUpdate;
    }
    
    private static Decimal calculateScore(Campaign campaign) {
        Decimal score = 0;

        if (campaign.ExpectedRevenue != null) score += campaign.ExpectedRevenue / 1000;
        if (campaign.BudgetedCost != null && campaign.BudgetedCost < 2000) score += 5; 
        if (campaign.ExpectedResponse != null) score += campaign.ExpectedResponse / 5;
        if (campaign.NumberOfLeads != null) score += campaign.NumberOfLeads * 1.5;
        if (campaign.NumberOfConvertedLeads != null) score += campaign.NumberOfConvertedLeads * 2;
        if (campaign.ExpectedResponse != null) score += campaign.ExpectedResponse;
        if (campaign.AmountWonOpportunities != null) score += campaign.AmountWonOpportunities / 1000;
        if (campaign.NumberOfWonOpportunities != null) score += campaign.NumberOfWonOpportunities * 2;
        
        if (campaign.Status == 'Planned') {
            score += 3; 
        } else if (campaign.Status == 'Aborted') {
            score -= 5; 
        } else if (campaign.Status == 'In Progress') {
            score += 10; 
        } else if (campaign.Status == 'Completed') {
            score += 15; 
        }

        if (campaign.ActualCost != null && campaign.BudgetedCost != null && campaign.ActualCost > campaign.BudgetedCost) 
            score -= (campaign.ActualCost - campaign.BudgetedCost) / 500; 
        if (campaign.ExpectedRevenue != null && campaign.ExpectedRevenue < 3000) score -= 5;
        if (campaign.NumberOfLeads != null && campaign.NumberOfLeads < 10) score -= 2; 
        if (campaign.ExpectedResponse != null && campaign.ExpectedResponse < 20) score -= 3; 
        
        score += Math.round(Math.random() * 10);
        
        if (score > 100) {
            score = 100;
        }
        if (score < 0) {
            score = 0;
        }
        
        return score;
    }
    
    private static String getTopPositives(Campaign campaign) {
        List<String> positives = new List<String>();

        if (campaign.Status == 'In Progress') positives.add('Campaign In Progress');
        if (campaign.Status == 'Completed') positives.add('Campaign Completed');
        if (campaign.ExpectedRevenue != null && campaign.ExpectedRevenue > 5000) positives.add('High Expected Revenue');
        if (campaign.BudgetedCost != null && campaign.BudgetedCost < 2000) positives.add('Low Budget');
        if (campaign.NumberOfLeads != null && campaign.NumberOfLeads > 50) positives.add('High Lead Volume');
        if (campaign.NumberOfConvertedLeads != null && campaign.NumberOfConvertedLeads > 20) positives.add('High Conversion Rate');
        if (campaign.ExpectedResponse != null && campaign.ExpectedResponse > 100) positives.add('High Engagement');
        if (campaign.AmountWonOpportunities != null && campaign.AmountWonOpportunities > 10000) positives.add('High Value Won Opportunities');
        if (campaign.NumberOfWonOpportunities != null && campaign.NumberOfWonOpportunities > 5) positives.add('High Number of Won Opportunities');
        
        return String.join(positives, '; ');
    }
    
    private static String getTopNegatives(Campaign campaign) {
        List<String> negatives = new List<String>();

        if (campaign.Status == 'Aborted') negatives.add('Campaign Aborted');
        if (campaign.ActualCost != null && campaign.BudgetedCost != null && campaign.ActualCost > campaign.BudgetedCost)
            negatives.add('Over Budget');
        if (campaign.ExpectedRevenue != null && campaign.ExpectedRevenue < 3000) negatives.add('Low Expected Revenue');
        if (campaign.NumberOfLeads != null && campaign.NumberOfLeads < 10) negatives.add('Low Lead Volume');
        if (campaign.ExpectedResponse != null && campaign.ExpectedResponse < 20) negatives.add('Low Expected Response');
        if (campaign.NumberOfConvertedLeads != null && campaign.NumberOfConvertedLeads < 5) negatives.add('Low Conversion Rate');
        if (campaign.AmountAllOpportunities != null && campaign.AmountAllOpportunities < 5000) negatives.add('Low Value Opportunities');
        
        return String.join(negatives, '; ');
    }
}
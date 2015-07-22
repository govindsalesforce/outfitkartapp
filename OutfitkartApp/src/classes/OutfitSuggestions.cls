public class OutfitSuggestions {
    public List<Product2> products{get;set;}
    public String name{get;set;}
    public String email{get;set;}
    public OutfitSuggestions(){
        Map<String,String> parameters=ApexPages.currentPage().getParameters();
        this.name=parameters.get('name');
        this.email=parameters.get('email');
        products= [SELECT Name,ProductCode,Description FROM Product2 WHERE Outfit__c=:ApexPages.currentPage().getParameters().get('oid')];
    }
}
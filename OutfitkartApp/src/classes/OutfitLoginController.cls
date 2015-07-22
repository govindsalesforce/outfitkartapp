public class OutfitLoginController {
    public String email{get;set;}
    public String password{get;set;}
    public PageReference signIn(){
        try{
            System.debug('OutfitSignUpController.signIn this.email '+this.email);
            if(String.isEmpty(this.email)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Email Is Required'));
                return null;
            }
           
            if(String.isEmpty(this.password)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Password Is Required'));
                return null;
            }
            List<Account> accounts=[SELECT Id,Name,Password__c FROM Account WHERE Email__c=:this.email];
            if(accounts.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Account Is Not Exist With Entered Credentials'));
                return null;
            }
            if(accounts[0].Password__c!=this.password){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Account Is Not Exist With Entered Credentials'));
                return null;
            }
            return new PageReference('/apex/outfitHome2?email='+this.email+'&name='+accounts[0].Name);
        }
        catch(Exception ex){
            System.debug('Exception In OutfitSignUpController.In '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            return null;
        }
    }
}
public class OutfitProfileController {
  public String firstName{get;set;}
    public String lastName{get;set;}
    public String email{get;set;}
    public String password{get;set;}
    public String confirmPassword{get;set;}
    public String billingStreet{get;set;}
    public String shippingStreet{get;set;}
    public String billingCity{get;set;}
    public String shippingCity{get;set;}
    public String shippingState{get;set;}
    public String billingState{get;set;}
    public String billingCountry{get;set;}
    public String shippingCountry{get;set;}
    public String billingPostalCode{get;set;}
    public String shippingPostalCode{get;set;}
    
    public OutfitProfileController(){
         String email=ApexPages.currentPage().getParameters().get('email');
         
    }
   
    public void signUp(){
        try{
            System.debug('OutfitSignUpController.signUp  this.firstName  '+this.firstName+' this.lastName '+this.lastName+' this.email '+this.email);
            if(String.isEmpty(this.firstName)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'First Name Is Required'));
                return;
            }
            if(String.isEmpty(this.lastName)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Last Name Is Required'));
                return;
            }
            if(String.isEmpty(this.email)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Email Is Required'));
                return;
            }
            if(String.isEmpty(this.password)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Password Is Required'));
                return;
            }
            if(String.isEmpty(this.confirmPassword)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Confirm Password Is Required'));
                return;
            }
            if(!this.password.equals(this.confirmPassword)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Password Did Not Match'));
                return;
            }
            if(![SELECT Email__c FROM Account WHERE Email__c=:this.email].isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Account Is Already Exist With This Email'));
                return;
            }
            //BillingCity, BillingCountry, BillingState, BillingStreet, BillingPostalCode,
            //ShippingCity, ShippingCountry, ShippingState, ShippingStreet, ShippingPostalCode
            insert new Account(Name=this.firstName+' '+this.lastName,Email__c=this.email,Password__c=this.password,BillingCity=this.billingCity, BillingCountry=this.billingCountry, BillingState=this.billingCountry, BillingStreet=this.billingStreet, BillingPostalCode=this.billingPostalCode,ShippingCity=this.shippingCity, ShippingCountry=this.shippingCountry, ShippingState=this.shippingState, ShippingStreet=this.shippingStreet, ShippingPostalCode=this.shippingPostalCode);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Account Has Been Created Successfully'));
        }
        catch(Exception ex){
            System.debug('Exception In OutfitProfileController.signUp '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
        }
    }
}
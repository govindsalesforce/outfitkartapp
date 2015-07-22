public class OutfitController{
    public List<SelectOption> workStyles{get;set;}
    public String selectedWorkStyle{get;set;}
    public List<SelectOption> eveningStyles{get;set;}
    public String selectedEveningStyle{get;set;}
    public List<SelectOption> shirtFits{get;set;}
    public String selectedShirtFit{get;set;}
    public List<SelectOption> trouserFits{get;set;}
    public String selectedTrouserFit{get;set;}
    public List<SelectOption> brands{get;set;}
    public String selectedBrand{get;set;}
    public List<SelectOption> sizes{get;set;}
    public String selectedSize{get;set;}
    public String firstName{get;set;}
    public String lastName{get;set;}
    public String email{get;set;}
    public OutfitController(){
        try{
            System.debug('Begin OutfitController   ');
            if(this.workStyles==null){
                this.workStyles=new List<SelectOption>();
                this.fillStyles(this.workStyles,Outfit__c.Work_Style__c.getDescribe().getPicklistValues());
            }
            System.debug(' OutfitController  this.workStyles  '+this.workStyles);
        }catch(Exception ex){
            System.debug('Exception In OutfitController  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
        }
    }
    private void fillStyles(List<SelectOption> selectList,List<Schema.PicklistEntry> pickListEntries){
       selectList.add(new SelectOption('','--None--'));
       for( Schema.PicklistEntry pickListEntry : pickListEntries){
                selectList.add(new SelectOption(pickListEntry.getLabel(), pickListEntry.getValue()));
       }  
    }
    public PageReference gotoWorkStyle(){
        System.debug('Begin OutfitController.gotoWorkStyle ');
        try{
           if(this.workStyles==null){
                this.workStyles=new List<SelectOption>();
                this.fillStyles(this.workStyles,Outfit__c.Work_Style__c.getDescribe().getPicklistValues());
            }
            System.debug('OutfitController.gotoWorkStyle  this.workStyles  '+this.workStyles);
            return new PageReference('/apex/outfitFormWorkStyleSelection');
        }
        catch(Exception ex){
            System.debug('Exception In OutfitController.gotoWorkStyle  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            return null;
        }
    }
    public PageReference gotoEveningStyle(){
        try{
            System.debug('Begin OutfitController.gotoEveningStyle assigned value for this.selectedWorkStyle  '+this.selectedWorkStyle);
            if(this.eveningStyles==null){
                this.eveningStyles=new List<SelectOption>();
                this.fillStyles(this.eveningStyles,Outfit__c.Evening_Style__c.getDescribe().getPicklistValues());
            }
            System.debug('OutfitController.gotoEveningStyle this.eveningStyles  '+this.eveningStyles);
            return new PageReference('/apex/outfitFormEveningStyleSelection');
        }
        catch(Exception ex){
            System.debug('Exception In OutfitController.gotoEveningStyle  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            return null;
        }
    }
    public PageReference gotoShirtFit(){
        try{
            System.debug('Begin OutfitController.gotoShirtFit  assigned value for this.selectedEveningStyle  '+this.selectedEveningStyle);
            if(this.shirtFits==null){
                this.shirtFits=new List<SelectOption>();
                this.fillStyles(this.shirtFits,Outfit__c.Shirt_Fit__c.getDescribe().getPicklistValues());
            }
            System.debug('OutfitController.gotoShirtFit this.shirtFits '+this.shirtFits);
            return new PageReference('/apex/outfitFormShirtFitSelection');
        }catch(Exception ex){
            System.debug('Exception In OutfitController.gotoShirtFit '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            return null;
        }
        
    }
    public PageReference gotoTrouserFit(){
        try{
            System.debug('Begin OutfitController.gotoTrouserFit assigned value for this.selectedShirtFit  '+this.selectedShirtFit);
            if(this.trouserFits==null){
                this.trouserFits=new List<SelectOption>();
                this.fillStyles(this.trouserFits,Outfit__c.Trousers_Fit__c.getDescribe().getPicklistValues());
            }
            System.debug('OutfitController.gotoTrouserFit this.trouserFits  '+this.trouserFits);
            return Page.outfitFormTrouserFitSelection;
        }catch(Exception ex){
            System.debug('Exception In OutfitController.gotoTrouserFit  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            return null;
        }
    }
    public PageReference gotoBrand(){
        try{
            System.debug('Begin OutfitController.gotoBrand assigned value for this.selectedTrouserFit   '+this.selectedTrouserFit);
            if(this.brands==null){
                this.brands=new List<SelectOption>();
                this.fillStyles(this.brands,Outfit__c.Brand__c.getDescribe().getPicklistValues());
            }
            System.debug('OutfitController.gotoBrand  '+this.brands);
            return Page.outfitFormBrandSelection;
        }catch(Exception ex){
            System.debug('Exception In OutfitController.gotoBrand '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            return null;
        }
    }
    public PageReference gotoSize(){
        try{
            System.debug('Begin OutfitController.gotoSize assigned value for this.selectedBrand   '+this.selectedBrand);
            if(this.sizes==null){
                this.sizes=new List<SelectOption>();
                this.fillStyles(this.sizes,Outfit__c.Size__c.getDescribe().getPicklistValues());
            }
            System.debug('OutfitController.gotoSize this.sizes  '+this.sizes);
            return Page.outfitFormSizeSelection;
        }catch(Exception ex){
            System.debug('Exception In OutfitController.gotoSize  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            return null;
        }
    }
    public PageReference gotoPersonalDetails(){
        try{
           System.debug('Begin OutfitController.gotoPersonalDetails this.selectedSize  '+this.selectedSize);
           return Page.outfitFormPersonalDetails;
        }catch(Exception ex){
            System.debug('Exception In OutfitController.gotoPersonalDetails  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            return null;
        } 
    }
    public PageReference gotoOutfitForm(){
        return Page.outfitForm;
    }
     public void submitDetails(){
       try{
            List<Account> accounts=[SELECT Email__c FROM Account WHERE Email__c=:this.email];
            if(accounts.isEmpty()){
                accounts.add(new Account(Name=this.firstName+' '+this.lastName,Email__c=this.email));
                insert accounts;
            }
            List<Outfit__c> outfits=[SELECT Id,Account__c,Name FROM Outfit__c WHERE Work_Style__c=:this.selectedWorkStyle AND Evening_Style__c=:this.selectedEveningStyle AND Shirt_Fit__c=:this.selectedShirtFit AND Trousers_Fit__c=:this.selectedTrouserFit AND Size__c=:this.selectedSize AND Brand__c=:this.selectedBrand AND Account__c=null];
            if(outfits.isEmpty())
                outfits.add(new Outfit__c(Name='Outfit '+DateTime.now(),Work_Style__c=this.selectedWorkStyle,Evening_Style__c=this.selectedEveningStyle,Shirt_Fit__c=this.selectedShirtFit,Trousers_Fit__c=this.selectedTrouserFit,Size__c=this.selectedSize,Brand__c=this.selectedBrand,Account__c=accounts[0].Id));
            else
                outfits[0].Account__c=accounts[0].Id;
            upsert outfits[0];
            System.debug('OutfitController.submitDetails  outfits[0]  '+outfits[0]);
            Opportunity opportunity=new Opportunity(Name='Opportunity '+outfits[0].Name,StageName='Prospecting',CloseDate=Date.today().addDays(10),AccountId=accounts[0].Id);
            insert opportunity;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Details Submitted Successfully.You Will Be Notified Soon With The Matched Items'));
        }catch(Exception ex){
            System.debug('Exception In OutfitController.submitDetails  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
         }
    }
}
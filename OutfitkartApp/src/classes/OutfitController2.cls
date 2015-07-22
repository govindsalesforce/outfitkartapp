public class OutfitController2{
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
    public String selectedOutfitName{get;set;}
    public String name{get;set;}
    public String email{get;set;}
    public List<Outfit__c> outfits{get;set;}
    public List<ProductWrapper> outfitProducts{get;set;}
    public Map<Outfit__c,List<ProductWrapper>> outfitProductsMap{get;set;}
    private Map<Id,List<ProductWrapper>> helperOutfitProductMap{get;set;}
    public List<ProductWrapper> kart{get;set;}
    private Map<Id,Product2> productAttachments{get;set;}
    public List<Attachment> previews{get;set;}
    public String password{get;set;}
    public String currentPassword{get;set;}
    public String newPassword{get;set;}
    public String confirmPassword{get;set;}
    public String phone{get;set;}
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
    public boolean isAllProductSelected{get;set;}
    public boolean isAllOutfitProductSelected{get;set;}
    private Account profile;
    public Map<String,List<ProductWrapper>> oldOrders{get;set;}
    public Map<String,List<ProductWrapper>> newOrders{get;set;}
    
    public OutfitController2(){
        try{
            System.debug('Begin OutfitController2   ');
            Map<String,String> parameters=ApexPages.currentPage().getParameters();
            this.email=parameters.get('email');
            this.name=parameters.get('name');
            System.debug('OutfitController2 this.email '+this.email +' this.name  '+this.name);
            List<Account> profiles=[SELECT Id, Name,Password__c,Phone,BillingCity, BillingCountry, BillingState, BillingStreet,BillingPostalCode,Email__c,ShippingCity, ShippingCountry, ShippingState, ShippingStreet, ShippingPostalCode FROM Account WHERE Email__c=:this.email AND Name=:this.name];
            if(profiles.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Profile Not Found'));
                return;
            }
            this.profile=profiles[0];
            this.password=this.profile.Password__c;
            this.phone=this.profile.Phone;
            this.billingCity=this.profile.BillingCity;
            this.billingCountry=this.profile.BillingCountry;
            this.billingState=this.profile.BillingState;
            this.billingStreet=this.profile.BillingStreet;
            this.billingPostalCode=this.profile.BillingPostalCode;
            this.shippingCity=this.profile.ShippingCity;
            this.shippingCountry=this.profile.ShippingCountry;
            this.shippingState=this.profile.ShippingState;
            this.shippingStreet=this.profile.ShippingStreet;
            this.shippingPostalCode=this.profile.ShippingPostalCode;
            if(this.workStyles==null){
                this.workStyles=new List<SelectOption>();
                this.fillStyles(this.workStyles,Outfit__c.Work_Style__c.getDescribe().getPicklistValues());
            }
            System.debug(' OutfitController2 this.workStyles   '+this.workStyles);
            
            if(this.eveningStyles==null){
                this.eveningStyles=new List<SelectOption>();
                this.fillStyles(this.eveningStyles,Outfit__c.Evening_Style__c.getDescribe().getPicklistValues());
            }
            System.debug('OutfitController2 this.eveningStyles  '+this.eveningStyles);
            
            if(this.shirtFits==null){
                this.shirtFits=new List<SelectOption>();
                this.fillStyles(this.shirtFits,Outfit__c.Shirt_Fit__c.getDescribe().getPicklistValues());
            }
            System.debug('OutfitController2 this.shirtFits '+this.shirtFits);
            
            if(this.trouserFits==null){
                this.trouserFits=new List<SelectOption>();
                this.fillStyles(this.trouserFits,Outfit__c.Trousers_Fit__c.getDescribe().getPicklistValues());
            }
            System.debug('OutfitController2 this.trouserFits  '+this.trouserFits);
            
            if(this.brands==null){
                this.brands=new List<SelectOption>();
                this.fillStyles(this.brands,Outfit__c.Brand__c.getDescribe().getPicklistValues());
            }
            System.debug('OutfitController this.brands  '+this.brands);
            
            if(this.sizes==null){
                this.sizes=new List<SelectOption>();
                this.fillStyles(this.sizes,Outfit__c.Size__c.getDescribe().getPicklistValues());
            }
            System.debug('OutfitController  this.sizes  '+this.sizes);
            //user outfits
            this.outfits=[SELECT Id,Name,Work_Style__c,Evening_Style__c,Shirt_Fit__c,Trousers_Fit__c,Brand__c,Size__c,Account__c,CreatedDate FROM Outfit__c WHERE Account__r.Email__c=:this.email  ORDER BY Id DESC];
            
            //user outfitMap
            outfitProductsMap=new Map<Outfit__c,List<ProductWrapper>>();
            helperOutfitProductMap=new Map<Id,List<ProductWrapper>>();  
            Map<Id,Outfit__c> outfitMap=new Map<Id,Outfit__c>([SELECT Id,Name,Work_Style__c,Evening_Style__c,Shirt_Fit__c,Trousers_Fit__c,Brand__c,Size__c,Account__c,CreatedDate FROM Outfit__c WHERE Account__r.Email__c=:this.email  ORDER BY Id DESC]);
            ProductWrapper wrapper;
            List<ProductWrapper> productWrappers;
            for(Product2 product : [SELECT Id,Outfit__c,Name,ProductCode,Description,Preview__c,Stock__c,(SELECT UnitPrice FROM PricebookEntries WHERE IsActive=:true) FROM Product2 WHERE Outfit__c IN :outfitMap.keySet() AND Kart__c=:null AND Order_Book__c=:null]){
                wrapper=new ProductWrapper();
                productWrappers=helperOutfitProductMap.get(product.Outfit__c);
                if(productWrappers==null){
                    productWrappers=new List<ProductWrapper>();
                    helperOutfitProductMap.put(product.Outfit__c,productWrappers);
                }
                wrapper.pwPro=product;
                wrapper.isSelected=false;
                productWrappers.add(wrapper);
            }
            for(Id outfitId : outfitMap.keySet()){
                productWrappers=helperOutfitProductMap.get(outfitId);
                outfitProductsMap.put(outfitMap.get(outfitId),(productWrappers==null || productWrappers.isEmpty())?new List<ProductWrapper>():productWrappers);
            }
            
            System.debug('OutfitController2 outfitProductsMap    '+outfitProductsMap);
            
            //user kart
            this.kart=new List<ProductWrapper>();
            
            for(Product2 product : [SELECT Id,Outfit__c,Name,ProductCode,Description,Preview__c,Stock__c,Delevered_On__c,(SELECT UnitPrice FROM PriceBookEntries)                     
                          FROM Product2 WHERE Kart__c IN (SELECT Id From Kart__c WHERE Account__r.Email__c=:this.email)]){
                      wrapper=new ProductWrapper();
                      wrapper.pwPro=product;
                      wrapper.isSelected=false;
                      wrapper.qty=1;
                      this.kart.add(wrapper);
            }
            
            //user orders
            this.oldOrders=new Map<String,List<ProductWrapper>>();
            this.newOrders=new Map<String,List<ProductWrapper>>();
            
            OpportunityLineItem opportunityLineItem;
            Map<Id,Order_Book__c> orderBookMap=new Map<Id,Order_Book__c>([SELECT Id,Name,Is_Delivered__c FROM Order_Book__c WHERE Account__r.Email__c=:this.email ORDER BY Id DESC]);
            Map<Id,Product2> productMap=new Map<Id,Product2>([SELECT Id,Outfit__c,Order_Book__c,Order_Book__r.Name,Order_Book__r.Is_Delivered__c,Name,ProductCode,Description,Preview__c,Stock__c,Delevered_On__c FROM Product2 WHERE Order_Book__c IN :orderBookMap.keySet()]);
            Map<Id,PriceBookEntry> priceBookEntryMap=new Map<Id,PriceBookEntry>([SELECT Id,Name,Product2Id,Pricebook2Id,UnitPrice FROM PricebookEntry WHERE Product2Id IN :productMap.keySet() AND IsActive=:true]);
            Map<Id,OpportunityLineItem> opportunityLineItemMap=new Map<Id,OpportunityLineItem>();
            for(OpportunityLineItem oli :[SELECT Quantity,UnitPrice,ListPrice,PricebookEntryId FROM OpportunityLineItem WHERE PricebookEntryId IN :priceBookEntryMap.keySet()]){
                opportunityLineItemMap.put(priceBookEntryMap.get(oli.PricebookEntryId).Product2Id,oli);
            }
            for(Product2 product : productMap.values()){
                                            wrapper=new ProductWrapper();                          
                                            wrapper.pwPro=product;
                                            opportunityLineItem=opportunityLineItemMap.get(product.Id);
                                            if(opportunityLineItem!=null){
                                                wrapper.qty=opportunityLineItem.Quantity;
                                                wrapper.listPrice=(opportunityLineItem.ListPrice==null)?'--':String.valueOf(opportunityLineItem.ListPrice);
                                            }
                                            productWrappers=(product.Order_Book__r.Is_Delivered__c)?this.oldOrders.get(orderBookMap.get(product.Order_Book__c).Name):this.newOrders.get(orderBookMap.get(product.Order_Book__c).Name);
                                            if(productWrappers==null){
                                                  productWrappers=new List<ProductWrapper>(); 
                                                  if(product.Order_Book__r.Is_Delivered__c)
                                                     this.oldOrders.put(product.Order_Book__r.Name,productWrappers);
                                                  else
                                                     this.newOrders.put(product.Order_Book__r.Name,productWrappers);
                                             }
                                             productWrappers.add(wrapper);
            }
          this.productAttachments=new Map<Id,Product2>([SELECT Id,(SELECT Id,Name,ContentType FROM Attachments WHERE ContentType Like 'image%') FROM Product2 WHERE Kart__c!=null OR Outfit__c!=null OR Order_Book__c!=null]);
          System.debug('OutfitController this.outfits  '+this.outfits);
          System.debug('OutfitController this.kart '+this.kart);
          System.debug('OutfitController this.oldOrders '+this.oldOrders+'   this.newOrders   '+this.newOrders);
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
    public PageReference submitDetails(){
        try{
            System.debug('OutfitController2.submitDetails  this.name '+this.name+'  this.email '+this.email);
            System.debug('OutfitController2.submitDetails selection this.selectedWorkStyle '+this.selectedWorkStyle+' this.selectedEveningStyle '+this.selectedEveningStyle+' this.selectedTrouserFit '+this.selectedTrouserFit+' this.selectedSize '+this.selectedSize+' this.selectedBrand '+this.selectedBrand);
            this.selectedBrand=this.selectedBrand.remove('[').remove(']').replace(',',';');
            System.debug(' OutfitController2.submitDetails  this.selectedBrand '+this.selectedBrand);
            List<Outfit__c> outfits=[SELECT Id,Account__c,Name FROM Outfit__c WHERE Work_Style__c=:this.selectedWorkStyle AND Evening_Style__c=:this.selectedEveningStyle AND Shirt_Fit__c=:this.selectedShirtFit AND Trousers_Fit__c=:this.selectedTrouserFit AND Size__c=:this.selectedSize AND Brand__c includes (:this.selectedBrand) AND Account__c=null ORDER BY CreatedDate DESC];
            if(outfits.isEmpty())
                outfits.add(new Outfit__c(Name='Outfit '+DateTime.now(),Work_Style__c=this.selectedWorkStyle,Evening_Style__c=this.selectedEveningStyle,Shirt_Fit__c=this.selectedShirtFit,Trousers_Fit__c=this.selectedTrouserFit,Size__c=this.selectedSize,Brand__c=this.selectedBrand,Account__c=this.profile.Id,Status__c='Assigned'));
            else{
                outfits[0].Account__c=this.profile.Id;
                outfits[0].Status__c='Assigned';
            }
            upsert outfits[0];
            System.debug('OutfitController.submitDetails  outfits[0]  '+outfits[0]);
            Opportunity opportunity=new Opportunity(Name='Opportunity '+outfits[0].Name,StageName='Prospecting',CloseDate=Date.today().addDays(10),AccountId=this.profile.Id,Outfit__c=outfits[0].Id);
            insert opportunity;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Details Submitted Successfully.You Will Be Notified Soon With The Matched Items'));
            return new PageReference('/apex/outfitHome2?email='+this.email+'&name='+this.name);
            
        }catch(Exception ex){
            System.debug('Exception In OutfitController.submitDetails  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            return null;
        }
    }
    public void displayOutfitProducts(){
        try{
            this.outfitProducts=new List<ProductWrapper>();
            ProductWrapper productWrapper;
            for(Product2 product : [SELECT Id,Outfit__c,Name,ProductCode,Description,Preview__c,Stock__c,(SELECT UnitPrice FROM PricebookEntries WHERE IsActive=:true) FROM Product2 WHERE Outfit__c=:ApexPages.currentPage().getParameters().get('oid') AND Kart__c=:null AND Order_Book__c=:null]){
               productWrapper=new ProductWrapper();
               productWrapper.pwPro=product;
               this.outfitProducts.add(productWrapper);
            }
        }
        catch(Exception ex){
            System.debug('Exception In OutfitController.displayOutfitProducts  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            
        }
    }
   
    public void displayOutfitProductsWithAttachements(){
        try{
            this.outfitProducts=new List<ProductWrapper>();
            ProductWrapper productWrapper;
            for(Product2 product : [SELECT Id,Outfit__c,Name,ProductCode,Description,Preview__c,Stock__c,(SELECT UnitPrice FROM PricebookEntries WHERE IsActive=:true) FROM Product2 WHERE Outfit__c=:ApexPages.currentPage().getParameters().get('oid') AND Kart__c=:null AND Order_Book__c=:null]){
               productWrapper=new ProductWrapper();
               productWrapper.pwPro=product;
               this.outfitProducts.add(productWrapper);
            }
        }
        catch(Exception ex){
            System.debug('Exception In OutfitController.displayOutfitProducts  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            
        }
    }
    
    public PageReference addToCart(){
        try{
            List<Kart__c> karts=[SELECT Id From Kart__c WHERE Account__r.Email__c=:this.email];
            List<Product2> products=new List<Product2>();
            System.debug('OutfitController.addToCart  karts  '+karts);
            if(karts.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Kart Not Found'));
                return null;   
            }
            for(ProductWrapper productWrapper : this.outfitProducts){
                if(productWrapper.isSelected){
                    if(productWrapper.pwPro==null){
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Product Not Found'));
                         return null;   
                    }
                    if(productWrapper.pwPro.Stock__c<=0){
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Product Out Of Stock'));
                          return null;     
                     }
                     productWrapper.pwPro.Kart__c=karts[0].Id;
                     products.add(productWrapper.pwPro);
                }
             }
           
            System.debug('OutfitController.addToCart  products  '+products);
            if(!products.isEmpty())
                   update products;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Product Is Added To The Kart Successfully.......'));
            return new PageReference('/apex/outfitHome2?email='+this.email+'&name='+this.name);
            
        }catch(Exception ex){
            System.debug('Exception In OutfitController.addToCart  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            return null;
        }
    }
        public PageReference addToCart2(){
        try{
            List<Kart__c> karts=[SELECT Id From Kart__c WHERE Account__r.Email__c=:this.email];
            List<Product2> products=new List<Product2>();
            System.debug('OutfitController.addToCart2  karts  '+karts);
            if(karts.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Kart Not Found'));
                return null;   
            }
            for(ProductWrapper productWrapper : this.helperOutfitProductMap.get(ApexPages.currentPage().getParameters().get('oid'))){
                if(productWrapper.isSelected){
                    if(productWrapper.pwPro==null){
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Product Not Found'));
                         return null;   
                    }
                    if(productWrapper.pwPro.Stock__c<=0){
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Product Out Of Stock'));
                          return null;     
                     }
                     productWrapper.pwPro.Kart__c=karts[0].Id;
                     products.add(productWrapper.pwPro);
                }
             }
           
            System.debug('OutfitController.addToCart  products  '+products);
            if(!products.isEmpty())
                   update products;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Product Is Added To The Kart Successfully.......'));
            return new PageReference('/apex/outfitHome2?email='+this.email+'&name='+this.name);
            
        }catch(Exception ex){
            System.debug('Exception In OutfitController.addToCart  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            return null;
        }
        
    }
    public void getPreviews(){
        try{
            String pid=ApexPages.currentPage().getParameters().get('pid');
            System.debug('OutfitController.getPreviews pid '+pid);
            
            Product2 product=this.productAttachments.get(pid);
            if(product==null){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Product Not Found'));
               return; 
            }
            this.previews=product.attachments;
            System.debug('OutfitController.getPreviews this.previews '+this.previews);
        }catch(Exception ex){
            System.debug('Exception In OutfitController.getPreviews  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            return ;
        }
    }
    public List<Attachment> previews2{get;set;}
    public void getPreviews2(){
        try{
            String pid=ApexPages.currentPage().getParameters().get('pid');
            System.debug('OutfitController.getPreviews2 pid '+pid);
            
            Product2 product=this.productAttachments.get(pid);
            if(product==null){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Product Not Found'));
               return; 
            }
            this.previews2=product.attachments;
            System.debug('OutfitController.getPreviews this.previews2 '+this.previews);
        }catch(Exception ex){
            System.debug('Exception In OutfitController.getPreviews  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            return ;
        }
    }
    
    public Integer getOldOrdersSize(){
        if(this.oldOrders!=null)
            return this.oldOrders.size();
         return 0;
    }
    
    public Integer getNewOrdersSize(){
        if(this.newOrders!=null)
           return this.newOrders.size();
         return 0;
    }
    
    public PageReference updateProfile(){
        try{
            if(this.profile==null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Profile Not Found'));
                return null;
            }
            this.profile.Name=this.name;
            this.profile.Email__c=this.email;
            this.profile.Phone=this.phone;
            this.profile.BillingCity=this.billingCity;
            this.profile.BillingCountry=this.billingCountry;
            this.profile.BillingState=this.billingState;
            this.profile.BillingStreet=this.billingStreet;
            this.profile.BillingPostalCode=this.billingPostalCode;
            this.profile.ShippingCity=this.shippingCity;
            this.profile.ShippingCountry=this.shippingCountry;
            this.profile.ShippingState=this.shippingState;
            this.profile.ShippingStreet=this.shippingStreet;
            this.profile.ShippingPostalCode=this.shippingPostalCode;
            
            update this.profile;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Profile Updated Successfully...'));
            return new PageReference('/apex/outfitHome2?email='+this.email+'&name='+this.name); 
        }
        catch(Exception ex){
            System.debug('Exception In OutfitController.updateProfile  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            return null;
        }
    }
    
    public PageReference updatePassword(){
        try{
            
            if(this.profile==null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Profile Not Found'));
                return null;
            }
            if(!this.password.equals(this.currentPassword)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Password'));
                return null;
            }
            if(this.password.equals(this.newPassword)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'New Password And Current Passwords Are Same'));
                return null;
            }
            if(!this.newPassword.equals(this.confirmPassword)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Passwords did not match'));
                return null;
            }
            this.profile.Password__c=this.newPassword;
            update this.profile;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Password Updated Successfully...'));
            //return new PageReference('/apex/outfitHome2?email='+this.email+'&name='+this.name);
            return null; 
        }
        catch(Exception ex){
            System.debug('Exception In OutfitController.updateProfile  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            return null;
        }
    }
    public void toggleProductSelection(){
        if(this.isAllProductSelected){
            for(ProductWrapper wrapper : this.kart){
                wrapper.isSelected=true;
            }
        }
        else{
            for(ProductWrapper wrapper : this.kart){
                wrapper.isSelected=false;
            }
        }
    }
    
    public void toggleOutfitProductSelection(){
        if(this.isAllOutfitProductSelected){
            for(ProductWrapper wrapper : this.outfitProducts){
                wrapper.isSelected=true;
            }
        }
        else{
            for(ProductWrapper wrapper : this.outfitProducts){
                wrapper.isSelected=false;
            }
        }
    }
    
    public void toggleOutfitProductSelection2(){
       if(this.isAllOutfitProductSelected){
            for(ProductWrapper wrapper : this.helperOutfitProductMap.get(ApexPages.currentPage().getParameters().get('oid'))){
                wrapper.isSelected=true;
            }
        }
        else{
            for(ProductWrapper wrapper : this.helperOutfitProductMap.get(ApexPages.currentPage().getParameters().get('oid'))){
                wrapper.isSelected=false;
            }
        }
    }
    
    public PageReference sendOrder(){
        try{
            List<PricebookEntry> pricebookEntries;
            PriceBookEntry priceBookEntry;
            List<Product2> products=new List<Product2>();
            OpportunityLineItem lineItem;
            Opportunity opportunity;
            List<OpportunityLineItem> opportunityLineItems=new List<OpportunityLineItem>();
            Map<Id,Product2> productMap=new Map<Id,Product2>();
            Set<Id> outfitSet=new Set<Id>();
            for(ProductWrapper wrapper : this.kart){
                if(wrapper.isSelected){
                    productMap.put(wrapper.pwPro.Id,wrapper.pwPro);
                    outfitSet.add(wrapper.pwPro.Outfit__c);
                }
            }
            Map<Id,Opportunity> opportunitiesMap=new Map<Id,Opportunity>();
            for(Opportunity opp : [SELECT Id,Name,Pricebook2Id,Outfit__c FROM Opportunity WHERE AccountId = :this.profile.Id AND Outfit__c IN :outfitSet ]){
                opportunitiesMap.put(opp.Outfit__c,opp);
            }
            Map<Id,PricebookEntry> priceBookEntryMap=new Map<Id,PricebookEntry>();
            for(PriceBookEntry pbe :[SELECT Id,Name,Product2Id,Pricebook2Id,UnitPrice FROM PricebookEntry WHERE Product2Id IN :productMap.keySet() AND IsActive=:true]){
                priceBookEntryMap.put(pbe.Product2Id,pbe);
            }
            System.debug('OutfitController.sendOrder productMap '+opportunitiesMap);
            System.debug('OutfitController.sendOrder priceBookEntryMap '+priceBookEntryMap);
            System.debug('OutfitController.sendOrder opportunitiesMap '+opportunitiesMap);
            System.debug('OutfitController.sendOrder priceBookEntryMap '+priceBookEntryMap);
            
            for(ProductWrapper wrapper : this.kart){
                if(wrapper.isSelected){
                    System.debug('OutfitController.sendOrder wrapper.pwPro '+wrapper.pwPro);
                    if(wrapper.pwPro==null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Product Not Found'));
                        return null;  
                    }
                    if(wrapper.pwPro.Stock__c==null||wrapper.pwPro.Stock__c<=0){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Product Out Of Stock'));
                        return null;   
                    }
                    opportunity=opportunitiesMap.get(wrapper.pwPro.Outfit__c);
                    System.debug('OutfitController.sendOrder  wrapper.pwPro.Outfit__c '+wrapper.pwPro.Outfit__c);
                    System.debug('OutfitController.sendOrder  opportunity '+opportunity+'   pricebook   '+opportunity.Pricebook2Id);
                    if(opportunity==null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Opportunity Not Found '));
                        return null; 
                    }
                    priceBookEntry=priceBookEntryMap.get(wrapper.pwPro.Id);
                    if(priceBookEntry==null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Price Book Not Found '));
                        return null; 
                    }
                    if(wrapper.qty>wrapper.pwPro.Stock__c){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Quantity Cannot Be More Than Available Stock'));
                        return null; 
                    }
                    wrapper.pwPro.Stock__c-=wrapper.qty;
                    products.add(wrapper.pwPro);
                    lineItem=new OpportunityLineItem();
                    lineItem.PricebookEntryId=priceBookEntry.Id;
                    lineItem.OpportunityId=opportunity.Id;
                    lineItem.UnitPrice=priceBookEntry.UnitPrice;
                    lineItem.Quantity=(wrapper.qty==null)?1:wrapper.qty;
                    opportunityLineItems.add(lineItem);
                }
            }
            System.debug('OutfitController.sendOrder  opportunityLineItems '+opportunityLineItems);
            if(!opportunityLineItems.isEmpty()){
                insert opportunityLineItems;
            }
            
            Order_Book__c orderBook=new Order_Book__c();
            orderBook.Name='Order Booked On '+DateTime.now();
            orderBook.Account__c=this.profile.Id;
            insert orderBook;
            for(Product2 prd : products){
                prd.Kart__c=null;
                prd.Order_Book__c=orderBook.Id;
            }
            if(!products.isEmpty()){
                update products;
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Order Has Been Sent Successfully...'));
            return new PageReference('/apex/outfitHome2?email='+this.email+'&name='+this.name);
            
        }catch(Exception ex){
            System.debug('Exception In  OutfitController2.sendOrder  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            return null;
        } 
    }
    public PageReference removeFromCart(){
       try{
           List<Product2> products=new List<Product2>();
           for(ProductWrapper wrapper : this.kart){
                if(wrapper.isSelected){
                    System.debug('OutfitController.sendOrder  wrapper.pwPro '+wrapper.pwPro);
                    if(wrapper.pwPro==null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Product Not Found'));
                        return null;  
                    }
                    wrapper.pwPro.Kart__c=null;
                    products.add(wrapper.pwPro);
                }
            }
            System.debug('Exception In  OutfitController2.Cancel Order  products  '+products);
            if(!products.isEmpty()){
                update products;
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Products Removed Form Kart...'));
            return new PageReference('/apex/outfitHome2?email='+this.email+'&name='+this.name);
            
        }catch(Exception ex){
            System.debug('Exception In  OutfitController2.Cancel Order  '+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Error Occured'));
            return null;
        } 
    }
    
    public Integer getOutfitProductMapSize(){
        return this.outfitProductsMap.size();
    }
}
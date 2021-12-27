trigger CalculateNetAmount on Order (before update) {
    for(order ord : trigger.new){
        if(ord.NetAmount__c == null && ord.ShipmentCost__c== null){
            ord.NetAmount__c = 0;
        	ord.ShipmentCost__c =0;
        }    
        // Update the "Net Amount" field using the formula NetAmount = TotalAmount - ShipmentCost
            ord.NetAmount__c = ord.TotalAmount - ord.ShipmentCost__c;  
    }

}
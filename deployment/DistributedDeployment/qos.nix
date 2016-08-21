{services, infrastructure, initialDistribution, previousDistribution, filters, lib}:

let
  distribution1 = filters.mapAttrOnList {
    inherit services infrastructure;
    distribution = initialDistribution;
    serviceProperty = "type";
    targetPropertyList = "supportedTypes";
  };
  
  distribution2 = filters.divideRoundRobin {
    distribution = distribution1;
  };
in
distribution2

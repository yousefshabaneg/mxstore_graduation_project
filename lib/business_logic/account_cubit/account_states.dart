abstract class AccountStates {}

class AccountInitialState extends AccountStates {}

class AccountLoadRegionCitiesState extends AccountStates {}

// Get Address States
class ShopLoadingGetAddressState extends AccountStates {}

class ShopSuccessGetAddressState extends AccountStates {}

class ShopErrorGetAddressState extends AccountStates {
  final String error;

  ShopErrorGetAddressState(this.error);
}

// Update Address States
class ShopLoadingUpdateAddressState extends AccountStates {}

class ShopSuccessUpdateAddressState extends AccountStates {}

class ShopErrorUpdateAddressState extends AccountStates {
  final String error;

  ShopErrorUpdateAddressState(this.error);
}

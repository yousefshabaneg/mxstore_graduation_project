import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/dio_helper.dart';
import '../../data/models/address_model.dart';
import '../../shared/constants.dart';
import '../../shared/resources/assets_manager.dart';
import '../../shared/resources/constants_manager.dart';
import 'account_states.dart';

class AccountCubit extends Cubit<AccountStates> {
  AccountCubit() : super(AccountInitialState());

  static AccountCubit get(context) => BlocProvider.of(context);

  Future<void> clearAddressData() async {
    selectedRegion = null;
    selectedCity = null;
    regionCities.clear();
    addressModel = null;
    regions.clear();
    cities.clear();
    citiesModels = [];
    regionsModels = [];
  }

  bool isAddressLoaded() {
    return addressModel != null &&
        citiesModels.isNotEmpty &&
        regionsModels.isNotEmpty;
  }

  String successMessage = "Success";
  String errorMessage = "Error";

  List<RegionModel> regionsModels = [];
  List<CityModel> citiesModels = [];
  String? selectedRegion;
  String? selectedCity;

  List<dynamic> regions = [];
  List<dynamic> cities = [];
  List<dynamic> regionCities = [];

  Future loadRegions(context) async {
    await DefaultAssetBundle.of(context)
        .loadString(ModelsAssets.regions)
        .then((data) {
      List response = json.decode(data);
      regionsModels =
          List.from(response).map((e) => RegionModel.fromJson(e)).toList();
      List<dynamic> loadedRegions = [];
      regionsModels.forEach((element) =>
          loadedRegions.add({"id": element.id, "name": element.regionNameEn}));
      regions = loadedRegions;
    }).catchError((error) {
      print("Load Regions Error :$error");
    });
  }

  Future loadCities(context) async {
    await DefaultAssetBundle.of(context)
        .loadString(ModelsAssets.cities)
        .then((data) {
      List response = json.decode(data);
      citiesModels =
          List.from(response).map((e) => CityModel.fromJson(e)).toList();
      List<dynamic> loadedCities = [];
      citiesModels.forEach((element) => loadedCities.add({
            "ID": element.id,
            "Name": element.cityNameEn,
            "ParentId": element.regionId
          }));
      cities = loadedCities;
    }).catchError((error) {
      print("Load Cities Error :$error");
    });
  }

  getRegionCities() {
    regionCities.clear();
    regionCities = cities
        .where((city) => city["ParentId"].toString() == selectedRegion)
        .toList();
    emit(AccountLoadRegionCitiesState());
  }

  String getRegionNameById() {
    return selectedRegion != null
        ? regionsModels
            .firstWhere((element) => element.id == selectedRegion)
            .regionNameEn!
        : "";
  }

  String getCityNameById() {
    return selectedCity != null
        ? citiesModels
            .firstWhere((element) => element.id == selectedCity)
            .cityNameEn!
        : "";
  }

  void getSelectedRegionId() {
    selectedRegion = regionsModels
        .firstWhere((element) => element.regionNameEn == addressModel!.region)
        .id!;
  }

  void getSelectedCityId() {
    selectedCity = citiesModels.isNotEmpty
        ? citiesModels
            .firstWhere((element) => element.cityNameEn == addressModel!.city)
            .id
        : null;
  }

  bool isHaveRegionAndCity() =>
      addressModel?.city != null &&
      addressModel?.region != null &&
      addressModel?.zipCode != null;

  String deliveryRegionAndCity() {
    return isHaveRegionAndCity()
        ? "${addressModel!.region} , ${addressModel!.city} - ${addressModel!.zipCode}"
        : "Cairo, Ain Shams - 35213";
  }

  AddressModel? addressModel;
  void getUserAddress(context) async {
    await clearAddressData();
    loadRegions(context).then((value) {
      loadCities(context).then((value) {
        emit(ShopLoadingGetAddressState());
        DioHelper.getData(url: ConstantsManager.Address, token: token)
            .then((json) {
          addressModel = AddressModel.fromJson(json);
          if (addressModel?.city != null && addressModel?.region != null) {
            getSelectedRegionId();
            getSelectedCityId();
            getRegionCities();
          }
          print("regions: ${regions.length}");
          print("cities: ${cities.length}");
          emit(ShopSuccessGetAddressState());
        }).catchError((error) {
          print('GET Address ERROR');
          emit(ShopErrorGetAddressState(error));
          print(error.toString());
        });
      });
    });
  }

  void updateUserAddress({
    required String name,
    required String phone,
    required String details,
    required String zipCode,
  }) {
    var regionName = getRegionNameById();
    var cityName = getCityNameById();
    details = details.isEmpty ? "." : details;
    emit(ShopLoadingUpdateAddressState());
    DioHelper.putData(
      url: ConstantsManager.Address,
      token: token,
      data: {
        "name": name,
        "region": regionName,
        "city": cityName,
        "details": details,
        "zipCode": zipCode,
        "street": phone
      },
    ).then((json) {
      addressModel = AddressModel.fromJson(json);
      successMessage = "Address Updated Successfully";
      emit(ShopSuccessUpdateAddressState());
    }).catchError((error) {
      errorMessage = "Updating address failed $error";
      print(errorMessage);
      emit(ShopErrorUpdateAddressState(errorMessage));
    });
  }
}

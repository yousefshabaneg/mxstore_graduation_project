import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/business_logic/account_cubit/account_states.dart';
import 'package:graduation_project/data/dio_helper.dart';
import 'package:graduation_project/data/models/address_model.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/resources/assets_manager.dart';
import 'package:graduation_project/shared/resources/constants_manager.dart';

class AccountCubit extends Cubit<AccountStates> {
  AccountCubit() : super(AccountInitialState());

  static AccountCubit get(context) => BlocProvider.of(context);

  void clearAddressData() {
    selectedRegion = null;
    selectedCity = null;
    regionCities.clear();
    addressModel = null;
    regions.clear();
    cities.clear();
    citiesModels = [];
    regionsModels = [];
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
      regionsModels.forEach((element) =>
          regions.add({"id": element.id, "name": element.regionNameEn}));
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
      citiesModels.forEach((element) => cities.add({
            "ID": element.id,
            "Name": element.cityNameEn,
            "ParentId": element.regionId
          }));
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

  String deliveryRegionAndCity() {
    bool isHaveRegionAndCity = addressModel?.city != null &&
        addressModel?.region != null &&
        addressModel?.zipCode != null;
    return isHaveRegionAndCity
        ? "${addressModel!.region} , ${addressModel!.city} - ${addressModel!.zipCode}"
        : "Cairo, Ain Shams - 35213";
  }

  AddressModel? addressModel;
  void getUserAddress(context) async {
    clearAddressData();
    loadRegions(context).then((value) {
      loadCities(context).then((value) {
        emit(ShopLoadingGetAddressState());
        DioHelper.getData(url: ConstantsManager.Address, token: token)
            .then((json) {
          addressModel = AddressModel.fromJson(json);
          print(addressModel);
          if (addressModel!.city != null && addressModel!.region != null) {
            getSelectedRegionId();
            getSelectedCityId();
            getRegionCities();
          }
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

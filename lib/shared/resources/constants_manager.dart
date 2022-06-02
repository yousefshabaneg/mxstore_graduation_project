import 'package:flutter/material.dart';
import 'package:graduation_project/shared/resources/routes_manager.dart';

const String IMAGE_PATH = "assets/images";

class ConstantsManager {
  static String startRoute = Routes.onBoardingRoute;
  static const String BaseUrl = "https://10.0.2.2:5001/api/";
  static const String BaseImagesUrl = "https://10.0.2.2:5001/images/";
  //Account
  static const String Account = "Account/";
  static const String Address = Account + "address";
  static const String Login = Account + "login";
  static const String Register = Account + "register";
  static const String IsEmailExist = Account + "emailexists";
  static const String ChangePassword = Account + "changePassword";
  static const String Edit = Account + "Edit";

  //Products
  static const String Products = "Products/";
  static const String Categories = Products + "categories";
  static const String Brands = Products + "brands";
  static const String Banners = Products + "banners";
  static const String Offers = Products + "offers";

  //Favorites
  static const String Favorites = "favorites";

  //Comments
  static const String Comments = "Comments/";
  static const String GetComment = Comments + "product/";
  static const String PostComment = Comments + "Comments/comment";

  //Basket
  static const String Basket = "Basket/";
  static String basketId = "";
}

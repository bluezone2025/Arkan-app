// ignore_for_file: constant_identifier_names

abstract class EndPoints {
  static const BASE_URL =
      // "https://payment-rayan.openshoop.com/api/V1/";
      "https://arkan-q8.com/api/V1/";
  static const HOME_ITEMS = BASE_URL + "get-home-products";
  static const NEW_ARRIVE = "new_arrive";
  static const Reception = "reception";
  static const ALL_OFFERS = "offers";
  static const IMAGEURL =
      // "https://payment-rayan.openshoop.com/";
      "https://arkan-q8.com/";
  static const IMAGEURL2 =
      // "https://payment-rayan.openshoop.com/storage/";
      "https://arkan-q8.com/storage/";
  static const PRODUCT_COLOR = BASE_URL + "get-product-colors/";
  static const LOGIN = BASE_URL + 'login';
  static const QUANTITY = BASE_URL + 'check_quantity';
  static const REGISTER = BASE_URL + "register";
  static const FORGET_PASS = BASE_URL + "forgot-password";
  static const LOG_OUT = BASE_URL + "logout";
  static const EDIT_PROFILE = BASE_URL + "edit-profile";
  static const CHANGE_PASSWORD = BASE_URL + "change-password";
  static const CHECK_PHONE = BASE_URL + "check-phone";
  static const USER_PROFILE = BASE_URL + "profile";
  static const SEARCH = BASE_URL + "search";
  static const SEARCH_HISTORY = BASE_URL + "get-my-search";
  static const COUNTRY = BASE_URL + "get-countries";
  static const CITY = BASE_URL + "get-cities";
  static const INFO = BASE_URL + "infos/all";
  static const INFO_SINGLE = BASE_URL + "infos";
  static const ADD_CART = BASE_URL + "check_product_for_add_cart";
  static const CHECK_COBON = BASE_URL + "check-coupon";
  static const DELIVERY = BASE_URL + "get-delivery";
  static const WISHLIST = BASE_URL + "get-wish-list";
  static const ADD_WISHLIST = BASE_URL + "add-remove-wish-list";
  static const SAVE_ORDER = BASE_URL + "save-order";
  static const All_ORDERS = BASE_URL + "get-orders";
  static const SINGLE_ORDERS = BASE_URL + "get-order";
  static const CASH_ORDER = BASE_URL + "save-cash";
  static const CALL_BACK = BASE_URL + "payment_callback/";
  static const CONTACT_US = BASE_URL + "contact";
  static const SETTING = BASE_URL + "settings";
  static const ACTIVATION_CODE = BASE_URL + "activation-code";
  static const CHECK_PHONE_EMAIL = BASE_URL + "check_email_phone";
  static const DELETE_ACCOUNT = BASE_URL + "active-remove-account";
  static const CUSTOME_DELETE_ACCOUNT = BASE_URL + "remove-account";
}

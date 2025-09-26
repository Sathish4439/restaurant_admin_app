class EndPoints {
  static const String baseUrl = "http://192.168.0.8:8000/api/admin";
  static const String auth = "$baseUrl/auth";
  static const String login = "$auth/login";
  static const String register = "$auth/register";
  static const String user = "$baseUrl/user";

  //--------------------admin----------
  //menu
  static const String menu = "$baseUrl/menu";
  static const String getMenu = "$menu/getMenu";
  static const String addMenu = "$menu/addMenu";
  static const String updateMenu = "$menu/updateMenu";
  static const String deleteMenu = "$menu/deleteMenu";

  //uploads
  static const String upload = "$baseUrl/upload";
  static const String single = "$upload/single";
  static const String multiple = "$baseUrl/multiple";

  //table
  static const String table = "$baseUrl/tables";
  static const String createTable = "$table/createTable";
  static const String updateTable = "$table/updateTable";
  static const String deleteTable = "$table/deleteTable";
  static const String getTable = "$table/listTables";
  static const String downloadQR = "$table/qrcode";

//user
  static const String createUser = "$user/createUser";
  static const String updateUser = "$user/updateUser";
  static const String deleteUser = "$user/deleteUser";
  static const String getUser = "$user/getAllUser";

//orders
  static const String order = "$baseUrl/orders";
  static const String getOrder = "$order/getOrder";
  static const String getOrderStats = "$order/getOrderStats";
  static const String updateOrder = "$order/updateOrder";

//fcm
  static const String firebase = "$baseUrl/firebase";
  static const String registerToken = "$firebase/registerFCM";

//cart
  static const String cart = "$baseUrl/cart";
  static const String getCart = "$cart/getCart";
  static const String createCart = "$cart/createCart";
  static const String updateCart = "$cart/updateCart";
  static const String deleteCart = "$cart/deleteCart";

//customer
  static const String customer = "$baseUrl/customer";
  static const String createCustomer = "$customer/createCustomer";
}

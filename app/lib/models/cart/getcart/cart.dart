import 'dart:convert';
import 'dart:developer';
import 'package:app/models/api/base_response.dart';
import 'package:app/models/cart/addtocart/cart.dart';
import 'package:app/models/product/product.dart';
import 'package:app/share/constants/storage.dart';
import 'package:app/utils/api_service.dart';
import 'package:http/src/response.dart';

// =================== User related models ===================

GetCartResponse cartFromJson(String str) =>
    GetCartResponse.fromJson(json.decode(str));

String userToJson(GetCartResponse data) => json.encode(data.toJson());

class CartDetails {
  String id;
  int quantity;
  String productId;
  DateTime createdAt;
  DateTime updatedAt;
  String cartId;

  CartDetails(this.id, this.quantity, this.productId, this.createdAt,
      this.updatedAt, this.cartId);

  factory CartDetails.fromJson(Map<String, dynamic> json) => CartDetails(
      json["id"],
      json["quantity"],
      json["product_id"],
      DateTime.parse(json["created_at"]),
      DateTime.parse(json["updated_at"]),
      json["cart_id"]);
}

class GetCartResponse {
  GetCartResponse(
    this.id,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.details,
  );

  String id;
  String? userId;
  DateTime createdAt;
  DateTime updatedAt;
  List<CartDetails> details;

  factory GetCartResponse.fromJson(Map<dynamic, dynamic> json) =>
      GetCartResponse(
        json["id"],
        json["user_id"],
        DateTime.parse(json["updated_at"]),
        DateTime.parse(json["created_at"]),
        List<CartDetails>.from(
            json["cart_details"].map((x) => CartDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product_id": id,
        "quantity": userId,
      };
}

class ItemsBody {
  String productId;
  int? quantity;

  ItemsBody({required this.productId, this.quantity});

  Map<String, dynamic> toJson() =>
      {"product_id": productId, "quantity": quantity};
}

class RemoveCartRequest {
  List<ItemsBody> items;

  RemoveCartRequest({required this.items});

  Map<String, dynamic> toJson() => {
        "items": items,
      };
}

// =================== Class response for api called ===================

class CartItems {
  Future<double> sum() async {
    double sum = 0;
    var cartId = await GlobalStorage.read(key: "cart_id");
    var getCartResponse = await ApiService().get("/api/carts/active?cart_id=$cartId");
    if (getCartResponse.statusCode == 200) {
      var cartResponse =
          GetCartResponse.fromJson(responseFromJson(getCartResponse.body).data);
      for (int i = 0; i < cartResponse.details.length; i++) {
        var prodId = cartResponse.details[i].productId;
        var getProductResponse =
            await ApiService().get("/api/products/$prodId");
        final Map parsed = json.decode(getProductResponse.body);

        if (getProductResponse.statusCode == 200) {
          var productResponse = GetSingleProductResponse.fromJson(parsed);
          sum = (cartResponse.details[i].quantity *
                  double.tryParse(productResponse.price)!) +
              sum;
        } else {
          // If the server did not return a 200 OK getCartResponse,
          // then throw an exception.
          throw Exception('Failed to load product');
        }
      }
      return sum;
    } else {
      // If the server did not return a 200 OK getCartResponse,
      // then throw an exception.
      throw Exception('Failed to load cart');
    }
  }
  Future<int> getStock(String id) async {
    var response = await ApiService().get("/api/products/$id");
    final Map parsed = json.decode(response.body);
    if (response.statusCode == 200) {
      var productResponse = GetSingleProductResponse.fromJson(parsed);
      GlobalStorage.write(key: "stock", value: productResponse.stock.toString());
      GlobalStorage.read(key: "stock").then((value) => print(value));
      return productResponse.stock;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load product');
    }
  }
  Future<GetCartResponse> getCart() async {
    var cartId = await GlobalStorage.read(key: "cart_id");
    var response = await ApiService().get("/api/carts/active?cart_id=$cartId");

    print(responseFromJson(response.body).data);
    if (response.statusCode == 200) {
      //var cartDetails = GetCartItems();
      var cartResponse =
          GetCartResponse.fromJson(responseFromJson(response.body).data);
      return cartResponse;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load cart');
    }
  }

  Future<dynamic> deleteCart(String productId, int? quantity) async {
    try {
      var cartId = await GlobalStorage.read(key: "cart_id");
      await ApiService().post(
          "/api/carts/items/remove?cart_id=$cartId",
          json.encode({
            "items": [
              {"product_id": productId, "quantity": quantity}
            ]
          }));
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<dynamic> addCart(String productId, int? quantity) async {
    try {
      var cartId = await GlobalStorage.read(key: "cart_id");
      Response response;
      if(cartId != null)
        {
          response = await ApiService().post(
              "/api/carts/items/add?cart_id=$cartId",
              json.encode({
                "items": [
                  {"product_id": productId, "quantity": quantity}
                ]
              }));
        }
      else{
        response = await ApiService().post(
            "/api/carts/items/add",
            json.encode({
              "items": [
                {"product_id": productId, "quantity": quantity}
              ]
            }));
      }

      if (response.statusCode == 200) {
        print(responseFromJson(response.body).data);
        var cartResponse =
        CartResponse.fromJson(responseFromJson(response.body).data);
        GlobalStorage.write(key: "cart_id", value: cartResponse.id);
        GlobalStorage.read(key: "cart_id").then((value) => print(value));
        return cartResponse;
      }
      else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load cart');
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}

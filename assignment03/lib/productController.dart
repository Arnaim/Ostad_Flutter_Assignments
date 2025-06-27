import 'dart:convert';
import 'models/product_models.dart';
import 'package:http/http.dart' as http;
import 'urls/urls.dart';

class Productcontroller {
  List<Data> products = [];
  Future<void> FetchProducts() async {
    final response = await http.get(Uri.parse(Urls.readProduct));
    print(response.statusCode);

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      productModel model = productModel.fromJson(data);
      products = model.data ?? [];
    }
  }

   Future<bool> CreateAndUpdateProduct(String productName, String img, int qty, int unitPrice, int totalPrice, String ? productId, bool isUpdate) async {
    final response = await http.post(Uri.parse(isUpdate ? Urls.updateProduct(productId!) : Urls.createProduct),
        headers: {'Content-Type' : 'application/json'},
        body: jsonEncode(
        {
            "ProductName": productName,
            "ProductCode": DateTime.now().microsecondsSinceEpoch,
            "Img": img,
            "Qty": qty,
            "UnitPrice": unitPrice,
            "TotalPrice": totalPrice,
        }
      )

    );

    print(response.statusCode);

    if(response.statusCode == 201 || response.statusCode == 200){ 
      return true;
    }else{
      return false;
    }
  }
  
    Future<bool> DeleteProducts(String productId) async {
    final response = await http.get(Uri.parse(Urls.deleteProduct(productId)));
    print(response.statusCode);

    if(response.statusCode == 200){
      FetchProducts();
      return true;
    }else{
      return false;
    }
  }



}


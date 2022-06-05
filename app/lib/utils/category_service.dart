import 'package:app/models/api/base_response.dart';
import 'package:app/models/category.dart';
import 'package:app/utils/api_service.dart';

class CategoryService {
  final Category _nullSafety = Category("0", "", [], "", "", "0", []);

  get nullSafety {
    return _nullSafety;
  }

  Future<List<Category>> fetchAllCategories() async {
    try {
      var response = await ApiService().get("/api/categories/get/products");
      if (response.statusCode == 200) {
        var decoded = responseFromJson(response.body).data;
        if (decoded['row'] is List) {
          if ((decoded['row'] as List).isNotEmpty) {
            return (decoded['row'] as List)
                .map((category) => Category.fromJson(category))
                .toList();
          }
        }
      }
      return [];
    } catch (e) {
      print("RUN");
      print(e);
      return [];
    }
  }
}

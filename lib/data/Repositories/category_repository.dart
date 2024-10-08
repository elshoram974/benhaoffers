import '../../utils/api.dart';
import '../model/category_model.dart';
import '../model/data_output.dart';

class CategoryRepository {
  Future<DataOutput<CategoryModel>> fetchCategories({
    required int page,
    int? categoryId,
    int? limit,
  }) async {
    try {
      Map<String, dynamic> parameters = {
        Api.page: page,
        if (limit != null) Api.limit: limit,
        if (categoryId != null) Api.categoryId: categoryId,
      };

      Map<String, dynamic> response =
          await Api.get(url: Api.getCategoriesApi, queryParameters: parameters);

      List<CategoryModel> modelList = (response['data']['data'] as List).map(
        (e) {
          return CategoryModel.fromJson(e);
        },
      ).toList();
      return DataOutput(
          total: response['data']['total'] ?? 0, modelList: modelList);
      // return (total: response['total'] ?? 0, modelList: modelList);
    } catch (e) {
      rethrow;
    }
  }
}

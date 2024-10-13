
import 'package:front_flutter_api_rest/src/services/api.dart';

class Providers {
  

  static Map<String, String> provider() {
    return {
   
      'categoryListProvider': ConfigApi.buildUrl('/categoria'),
      'loginProvider': ConfigApi.buildUrl('/auth/login'),
      'registerProvider': ConfigApi.buildUrl('/auth/create'),
      'userListProvider': ConfigApi.buildUrl('/auth/list'),
    };
  }
}
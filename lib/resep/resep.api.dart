import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projectakhir_kelompok_resep/resep/model_resep.dart';

class ResepApi {
  static Future<List<Resep>> getRecipe() async {
    var uri = Uri.https('tasty.p.rapidapi.com', '/recipes/list',
        {"from": "0", "size": "20", "tags": "under_30_minutes"});

    final response = await http.get(uri, headers: {
      "x-rapidapi-key": "568b277e77msh6f5961e7a9c6e05p1a8345jsn2958787b379e",
      "x-rapidapi-host": "tasty.p.rapidapi.com",
      "useQueryString": "true"
      });

    Map data = jsonDecode(response.body);
    List _temp = [];

    for (var i in data['results']) {
      _temp.add(i);
    }

    return Resep.recipesFromSnapshot(_temp);
  }
}

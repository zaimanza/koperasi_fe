import 'dart:convert';

import 'package:http/http.dart' as http;

class FetchAPI {
  var beApi = "https://koperasi.onrender.com";
  Future getOneParcel(parcelId) async {
    var client = http.Client();

    var uri = Uri.parse("$beApi/parcel/get_by_id?parcelId=$parcelId");

    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;

      return jsonDecode(json);
    }

    return;
  }

  Future updateOneParcel(data) async {
    var client = http.Client();
    print("HI_AIMAN_1");
    print(data);
    var uri = Uri.parse("$beApi/parcel/out");

    var response = await client.put(
      uri,
      body: data,
    );
print(response.body);
    if (response.statusCode == 200) {
      var json = response.body;

      return jsonDecode(json);
    }

    return;
  }

  Future postOneParcel(data) async {
    var client = http.Client();

    var uri = Uri.parse("$beApi/parcel/in");

    var response = await client.post(
      uri,
      body: data,
    );

    if (response.statusCode == 200) return true;

    var responded = response.body ?? "There is an error in the server";
    return responded;
  }
}

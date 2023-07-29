import 'dart:convert';

import 'package:http/http.dart' as http;

class FetchAPI {
  var beApi = "https://koperasi.onrender.com";
  Future getOneParcel(trackingNumber) async {
    var client = http.Client();

    var uri = Uri.parse("$beApi/parcel/$trackingNumber");

    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;

      return jsonDecode(json);
    }

    return;
  }

  Future updateOneParcel(data) async {
    var client = http.Client();

    var uri = Uri.parse("$beApi/parcel/${data["tracking_number"]}");

    var response = await client.put(
      uri,
      body: data,
    );

    if (response.statusCode == 200) {
      var json = response.body;

      return jsonDecode(json);
    }

    return;
  }

  Future postOneParcel(data) async {
    var client = http.Client();

    var uri = Uri.parse("$beApi/parcel");

    print("HI_MANZA");
    var response = await client.post(
      uri,
      body: data,
    );

    print("HI_MANZA_1");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) return true;

    var responded = response.body ?? "There is an error in the server";
    return responded;
  }

  Future getNoOfTokenLeft() async {
    var client = http.Client();

    var uri = Uri.parse("$beApi/parcel/noOfTokenLeft");

    var response = await client.post(uri);

    if (response.statusCode == 200) return response.body.toString();

    return "0";
  }
}

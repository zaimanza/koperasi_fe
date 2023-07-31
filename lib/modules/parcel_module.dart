import '../middleware/fetch_api.dart';

addParcel(courier, parcelId, phoneNumber, remarks) async {
  Map<String, dynamic> data = {};
  if (courier.toString().isNotEmpty) data['courier'] = courier;
  if (parcelId.toString().isNotEmpty) {
    data['parcelId'] = parcelId;
  }
  if (phoneNumber.toString().isNotEmpty) data['phone_number'] = phoneNumber;
  if (remarks.toString().isNotEmpty) data['remarks'] = remarks;
  data['created_at'] = DateTime.now().toIso8601String();
  var findOneResult = await FetchAPI().getOneParcel(parcelId);
  if (findOneResult != null) {
    return false;
  }

  var response = await FetchAPI().postOneParcel(data);

  if (response == true) return true;
  return response;
}

findOneParcel(parcelId) async {
  var response = await FetchAPI().getOneParcel(parcelId);

  return response ?? {};
}

updateOneParcel(variable) async {
  var result = await FetchAPI().getOneParcel(variable["parcelId"]);

  if ((variable["picked_out_at"] ?? "") != "") {
    result!['picked_out_at'] = variable["picked_out_at"];
  }
  if ((variable["recipient_name"] ?? "") != "") {
    result!['recipient_name'] = variable["recipient_name"];
  }
  if ((variable["recipient_phone_number"] ?? "") != "") {
    result!['recipient_phone_number'] = variable["recipient_phone_number"];
  }
  if ((variable["phone_number"] ?? "") != "") {
    result!['phone_number'] = variable["phone_number"];
  }
  if ((variable["remarks"] ?? "") != "") {
    result!['remarks'] = variable["remarks"];
  }

  var response = await FetchAPI().updateOneParcel(variable);
  return result;
}

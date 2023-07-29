import 'package:phone_number/phone_number.dart';

regexPhoneNumber(phoneNumber, countryCode) async {
  try {
    PhoneNumberUtil plugin = PhoneNumberUtil();
    bool isValid = await plugin.validate(phoneNumber, countryCode);
    print("Phone number: " + isValid.toString());
    return isValid;
  } on Exception catch (_) {
    print('never reached');
    return false;
  }
}

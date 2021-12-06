import 'dart:convert';
//import 'dart:math';
import 'package:http/http.dart' as http;
//import 'utilities.dart';
import 'package:flutter/services.dart';

import 'package:flutter_klip_wallet/src/globals.dart' as globals;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:android_intent/android_intent.dart';

// 계정 조회
Future<num> getBalance() async {
  /*
  Uri request = Uri.parse('https://' +
      env['KAS_API_KEY'].toString() +
      '@node-api.klaytnapi.com/v1/klaytn');
  String body = jsonEncode(<String, dynamic>{
    "jsonrpc": "2.0",
    "method": "klay_getAccount",
    "params": [env['KAS_WALLET_ADDRESS'], "latest"],
    "id": 1
  });
  Map<String, String> headers = <String, String>{
    'x-chain-id': '1001',
    'Content-Type': 'application/json',
  };

  final http.Response response = await http.post(
    request,
    headers: headers,
    body: body,
  );

  printWrapped(response.body);

  final responseMap = Map<String, dynamic>.from(json.decode(response.body));
  final accountInfoMap = Map<String, dynamic>.from(responseMap['result']);
  final accountMap = Map<String, dynamic>.from(accountInfoMap['account']);

  print("\n");
  print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
  print("\n");
  print("Account Balance: ");
  print(BigInt.parse(accountMap['balance'].substring(2), radix: 16) /
      BigInt.parse(pow(10, 18).toString()));
  print("\n");
  print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
  print("\n");

  return BigInt.parse(accountMap['balance'].substring(2), radix: 16) /
      BigInt.parse(pow(10, 18).toString());
  */
  return 0;
}

// 빗썸 api
Future<int> getQuote() async {
  Uri request = Uri.parse('https://api.bithumb.com/public/ticker/KLAY');

  final http.Response response = await http.get(
    request,
  );

  final responseMap = Map<String, dynamic>.from(json.decode(response.body));
  final dataMap = Map<String, dynamic>.from(responseMap['data']);

  print('\n');
  print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
  print('\n');
  print('KLAY quote (KRW): ');
  print(int.parse(dataMap['closing_price']));
  print('\n');
  print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
  print('\n');

  return int.parse(dataMap['closing_price']);
}

Future<List<Map<String, dynamic>>> getCardList() async {
  Uri request = Uri.parse('https://a2a-api.klipwallet.com/v2/a2a/cards?sca=' +
      env['KLIP_SCA'].toString() +
      '&eoa=' +
      globals.walletAddress +
      '&cursor=');
  Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json',
  };

  final http.Response response = await http.get(
    request,
    headers: headers,
  );

  try {
    final responseMap = Map<String, dynamic>.from(json.decode(response.body));
    List<dynamic> rawCardList = responseMap['cards'];
    List<String> cardUriList = rawCardList
        .map((e) => Map<String, dynamic>.from(e)['card_uri'].toString())
        .toList();
    List<Map<String, dynamic>> result = [];
    for (var i = 0; i < cardUriList.length; i++) {
      final http.Response _response = await http.get(
        Uri.parse(cardUriList[i]),
      );
      result.add(Map<String, dynamic>.from(
          jsonDecode(utf8.decode(_response.bodyBytes))));
    }
    print(result);
    return result;
  } catch (e) {
    return [];
  }
  ;
}

Future<String> getRequestKey() async {
  Uri request = Uri.parse('https://a2a-api.klipwallet.com/v2/a2a/prepare');

  String body = jsonEncode(<String, dynamic>{
    "bapp": {"name": "My wallet (test)"},
    "callback": {
      "success": "mybapp://klipwallet/success",
      "fail": "mybapp://klipwallet/fail"
    },
    "type": "auth"
  });
  Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json',
  };
  final http.Response response = await http.post(
    request,
    body: body,
    headers: headers,
  );

  final responseMap = Map<String, dynamic>.from(json.decode(response.body));

  print('\n');
  print('*****************************************');
  print('\n');
  print('request_key: ' + responseMap['request_key']);
  print('\n');
  print('*****************************************');
  print('\n');

  return responseMap['request_key'].toString();
}

void createIntent() async {
  final String requestKey = await getRequestKey();
  final AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: Uri.encodeFull(
          'kakaotalk://klipwallet/open?url=https://klipwallet.com/?target=/a2a?request_key=' +
              requestKey +
              '#Intent;scheme=kakaotalk;package=com.kakao.talk;end'),
      package: 'com.kakao.talk');
  await intent.launch();
}

Future<String> getKlipAddress(String requestKey) async {
  Uri request = Uri.parse(
      'https://a2a-api.klipwallet.com/v2/a2a/result?request_key=' + requestKey);
  Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json',
  };
  final http.Response response = await http.get(
    request,
    headers: headers,
  );

  final responseMap = Map<String, dynamic>.from(json.decode(response.body));

  //print(responseMap['status'].toString());
  if (responseMap['status'].toString() == 'completed') {
    final resultMap = Map<String, dynamic>.from(responseMap['result']);

    print('\n');
    print('*****************************************');
    print('\n');
    print('user Klip address: ' + resultMap['klaytn_address']);
    print('\n');
    print('*****************************************');
    print('\n');

    return resultMap['klaytn_address'].toString();
  }
  print('\n');
  print('*****************************************');
  print('\n');
  print('user Klip address null !!!');
  print('\n');
  print('*****************************************');
  print('\n');
  return '';
}

Future getUserPermission() async {
  const platform = MethodChannel('com.example.flutter_klip_wallet/klip');

  String _requestKey = await getRequestKey();
  try {
    await platform.invokeMethod(
      'getUserPermission',
      <String, dynamic>{'requestKey': _requestKey},
    ).then((result) async {
      print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n' +
          'user klip permission: ' +
          result +
          '\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
      globals.requestKey = _requestKey;
    });
  } on PlatformException catch (e) {
    print(e.message);
  }
}

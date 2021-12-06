import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// 숫자를 금액 String으로 변환
String currencyFormat(num price, int decimalDigits) {
  final formatCurrency = NumberFormat.simpleCurrency(
      locale: 'ko_KR', name: '', decimalDigits: decimalDigits);

  return formatCurrency.format(price);
}

const _locale = 'en';

String formatNumber(String s) =>
    NumberFormat.decimalPattern(_locale).format(int.parse(s));
String get currency =>
    NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

// 오류메시지 대화창
void errorDialog(BuildContext context, String title, String message) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 36,
                ),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
}

// 긴 문자열 출력 (디버그용)
void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

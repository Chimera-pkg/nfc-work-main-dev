// import 'package:flutter/material.dart';
// import 'package:nearpay_flutter_sdk/nearpay.dart';

// class NearpayPurchase {
//   static Future<Map<String, dynamic>> makePurchase(
//       Nearpay nearpay, int amount, String customerReferenceNumber) async {
//     try {
//       final transactionData = await nearpay.purchase(
//         amount: 0001,
//         transactionId: uuid.v4(),
//         customerReferenceNumber: '123',
//         enableReceiptUi: true,
//         enableReversalUi: true,
//         enableUiDismiss: true,
//         finishTimeout: 60,
//       );

//       final jsonData = Map<String, dynamic>.from(transactionData as Map);
//       return jsonData;
//     } catch (e) {
//       debugPrint("Error during purchase: $e");
//       return {'status': 500, 'message': 'Internal Server Error'};
//     }
//   }
// }

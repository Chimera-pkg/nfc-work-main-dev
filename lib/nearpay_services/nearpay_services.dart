// NearpayService.dart

import 'package:demo_nfc/nearpay_services/nearpay_authentication.dart';
import 'package:demo_nfc/views/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearpay_flutter_sdk/errors/purchase_error/purchase_error.dart';
import 'package:nearpay_flutter_sdk/nearpay.dart';

class NearpayService {
  static final NearpayService _instance = NearpayService._internal();
  factory NearpayService() => _instance;

  NearpayService._internal();

  static final Nearpay nearpay = Nearpay(
    authType: AuthenticationType.email,
    authValue: "pos@ava.com.sa",
    env: Environments.sandbox,
    locale: Locale.localeDefault,
    //region: Regions.SAUDI,
  );

  Future<void> initializeNearpay() async {
    await nearpay.initialize().catchError((e) {
      debugPrint("Nearpay initialization error: $e");
    });
    debugPrint("After Nearpay initialization");
  }

  Future<void> loginUser(String input) async {
    Map<String, dynamic> authData;

    if (input.startsWith("jwt")) {
      authData = AuthenticationData.loginWithJWT(input);
    } else if (input.startsWith("+")) {
      authData = AuthenticationData.loginWithMobile(input);
    } else {
      authData = AuthenticationData.loginWithEmail(input);
    }

    await nearpay.setup().catchError((e) {
      debugPrint(e.toString());
    });
  }

  Future<void> makePurchase(int amount, String customerReferenceNumber) async {
    try {
      await nearpay.purchase(
        amount: 1,
        transactionId: uuid.v4(), // Generating a random UUID
        customerReferenceNumber: '123',
        enableReceiptUi: true,
        enableReversalUi: true,
        enableUiDismiss: true,
        finishTimeout: 0,
      ).then((response) {
        // Debugging statement for successful purchase
        debugPrint('Purchase successful! Response: ${response.toJson()}');
           Get.to(() => const WebViewScreen());
    
      }).catchError((error) {
        // Debugging statement for different errors
        if (error is PurchaseAuthenticationFailed) {
          debugPrint('Purchase authentication failed');
        } else if (error is PurchaseGeneralFailure) {
          debugPrint('General purchase failure');
        } else if (error is PurchaseInvalidStatus) {
          debugPrint('Invalid purchase status');
        } else if (error is PurchaseDeclined) {
          debugPrint('Purchase declined');
        } else if (error is PurchaseRejected) {
          debugPrint('Purchase rejected');
        }
      });
    } catch (e) {
      // Debugging statement for unexpected errors
      debugPrint('Unexpected error occurred: $e');
    }
  }
}

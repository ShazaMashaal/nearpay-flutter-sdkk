// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:nearpay_example/util.dart';
import 'package:nearpay_flutter_sdk/errors/purchase_error/purchase_error.dart';
import 'package:nearpay_flutter_sdk/models/session/session.dart';
import 'package:nearpay_flutter_sdk/models/transaction_receipt/transaction_receipt.dart';
import 'package:nearpay_flutter_sdk/nearpay.dart';
import 'package:nearpay_flutter_sdk/types.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

Future<void> main() async {
  // await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final nearpay = Nearpay(
    authType: AuthenticationType.email,
    authValue: "f.alhajeri@nearpay.io",
    env: Environments.sandbox,
    locale: Locale.localeDefault,
  );

  Uint8List? bytes;

  // NearpayState state = NearpayState.notReady;

  @override
  initState() {
    super.initState();
    nearpay.initialize(onInitializeSuccess: () {
      print("nearpay initialized successfully");
    }, onInitializeFail: () {
      print("nearpay initialize failed");
    });
  }

  Future<dynamic> purchaseWithRefund() async {
    print("=-=-=-=-= Start Purchase with Refund Action =-=-=-=-=");

    final transactionData = await nearpay
        .purchase(
      amount: 1000,
      // onPurchaseApproved: (reciepts) {
      //   print(
      //       "=-=-=-=-=-=-=-=-=-=- on purchase approved =-=-=-=-=-=-=-=-=-=-=");
      //   final String? transactionUuid =
      //       reciepts.receipts?[0].transaction_uuid;
      //   nearpay.refund(
      //     amount: 1000, // [Required], means 10.00
      //     originalTransactionUUID:
      //         transactionUuid!, // [Required] the orginal trnasaction uuid that you want to refund
      //     transactionId: uuid.v4(), //[Optional] speacify the transaction uuid
      //     customerReferenceNumber: '', //[Optional]
      //     enableReceiptUi: true, // [Optional] show the reciept in ui
      //     enableReversalUi:
      //         true, //[Optional] enable reversal of transaction from ui
      //     editableRefundUI:
      //         true, // [Optional] edit the reversal amount from uid
      //     enableUiDismiss: true, //[Optional] the ui is dimissible
      //     finishTimeout: 60, //[Optional] finish timeout in seconds
      //     adminPin:
      //         '0000', // [Optional] when you add the admin pin here , the UI for admin pin won't be shown.
      //     onRefundApproved: (reciepts) {
      //       print(
      //           "=-=-=-=-=-=-=-=-=-=- on refund approved =-=-=-=-=-=-=-=-=-=-=");
      //     },
      //     onRefundFailed: (err) {
      //       print(
      //           "=-=-=-=-=-=-=-=-=-=- on refund failed =-=-=-=-=-=-=-=-=-=-=");
      //     },
      //   );
      // },
      // onPurchaseFailed: (err) {
      //   print(
      //       "=-=-=-=-=-=-=-=-=-=- on purchase failed =-=-=-=-=-=-=-=-=-=-=");
      // }
    )
        .catchError((err) {
      print("=-=-=-=-=-=-=-=-=-=- on purchase failed =-=-=-=-=-=-=-=-=-=-=");
      throw err;
    });

    final String? transactionUuid =
        transactionData.receipts?[0].transaction_uuid;

    await nearpay.refund(
      amount: 1000, originalTransactionUUID: transactionUuid!,
      transactionId: uuid.v4(), //[Optional] speacify the transaction uuid
      customerReferenceNumber: '', //[Optional]
      enableReceiptUi: true, // [Optional] show the reciept in ui
      enableReversalUi:
          true, //[Optional] enable reversal of transaction from ui
      editableRefundUI: true, // [Optional] edit the reversal amount from uid
      enableUiDismiss: true, //[Optional] the ui is dimissible
      finishTimeout: 60, //[Optional] finish timeout in seconds
      adminPin:
          '0000', // [Optional] when you add the admin pin here , the UI for admin pin won't be shown.
    );
  }

  Future<dynamic> purchaseWithReverse() async {
    print("=-=-=-=-= Start Purchase with Reverse Action =-=-=-=-=");

    final transactionData = await nearpay
        .purchase(
      amount: 1000,
      // onPurchaseApproved: (data) {
      //   print(
      //       "=-=-=-=-=-=-=-=-=-=- on purchase approved =-=-=-=-=-=-=-=-=-=-=");
      //   final String? uuid = data.receipts?[0].transaction_uuid;
      //   nearpay.reverse(
      //     originalTransactionUUID: uuid!,
      //     enableReceiptUi: true,
      //     enableUiDismiss: true,
      //     finishTimeout: 60,
      //     onReversalFinished: (reciepts) {
      //       print(
      //           "=-=-=-=-=-=-=-=-=-=- on reverse approved =-=-=-=-=-=-=-=-=-=-=");
      //     },
      //     onReversalFailed: (err) {
      //       print(
      //           "=-=-=-=-=-=-=-=-=-=- on reverse failed =-=-=-=-=-=-=-=-=-=-=");
      //     },
      //   );
      // },
    )
        .catchError((err) {
      print("=-=-=-=-=-=-=-=-=-=- on purchase failed =-=-=-=-=-=-=-=-=-=-=");
      throw err;
    });

    print("=-=-=-=-=-=-=-=-=-=- on purchase approved =-=-=-=-=-=-=-=-=-=-=");
    final String? uuid = transactionData.receipts?[0].transaction_uuid;
    await nearpay.reverse(
        originalTransactionUUID: uuid!,
        enableReceiptUi: true,
        enableUiDismiss: true,
        finishTimeout: 60);
  }

  Future<dynamic> purchaseAction() async {
    print("=-=-=-=-= Start Purchase Action =-=-=-=-=");
    final transactionData = await nearpay
        .purchase(
      amount: 0001, // [Required] ammount you want to set .
      transactionId: uuid
          .v4(), // [Optional] specefy the transaction uuid for later referance
      customerReferenceNumber:
          '123', // [Optional] any number you want to add as a refrence Any string as a reference number
      enableReceiptUi: true, // [Optional] show the reciept in ui
      enableReversalUi:
          true, // [Optional] it will allow you to enable or disable the reverse button
      enableUiDismiss: true, // [Optional] the ui is dimissible
      finishTimeout: 60, // [Optional] finish timeout in seconds
      // onPurchaseApproved: (receipts) {

      // },
      // onPurchaseFailed: ,
    )
        .catchError((err) {
      print("=-=-=-=-= Purchase Failed =-=-=-=-=");

      if (err is PurchaseDeclined) {
        print("declined");
      }
      if (err is PurchaseGeneralFailure) {
        print("general");
      }
      if (err is PurchaseInvalidStatus) {
        print('invalid');
      }

      throw err;
    });

    print("=-=-=-=-=-=-=-=-=-=- on purchase approved =-=-=-=-=-=-=-=-=-=-=");
    transactionData.receipts?.forEach((receipt) {
      printJson(receipt.toJson());
    });
  }

  Future<dynamic> reconcileAction() async {
    print("=-=-=-=-= Start Reconcile Action =-=-=-=-=");

    return nearpay.reconcile(
      enableReceiptUi: true,
      enableUiDismiss: true,
      adminPin: '0000',
      finishTimeout: 60,
      reconciliationId: uuid.v4(),
      onReconcileFinished: (receipt) {
        print("=-=-=-=-= Reconcile Success =-=-=-=-=");
        printJson(receipt.toJson());
      },
      onReconcileFailed: (err) {
        print("=-=-=-=-= Reconcile Failed =-=-=-=-=");
      },
    );
  }

  Future<dynamic> logoutAction() async {
    print("=-=-=-=-= Start Logout Action =-=-=-=-=");

    return nearpay.logout();
  }

  Future<dynamic> setupAction() async {
    print("=-=-=-=-= Start Setup Action =-=-=-=-=");

    return nearpay.setup();
  }

  Future<dynamic> sessionAction() async {
    print("=-=-=-=-= Start Session Action =-=-=-=-=");
    final dio = Dio();

    const terminalId = '12a8abeb-cdf6-4432-a287-2d3a54bc7b88';

    const apiKey =
        'A221mIWc0ldmrmqkAM3kSITN3i58smLvhpBAP0pOyXxc9mDxphrkqmBKt4HL';

    const url =
        'https://sandbox-api.nearpay.io/v1/clients-sdk/terminals/$terminalId/sessions';

    final sessionResponse = await dio.post(url,
        data: {
          'type': 'purchase',
          'amount': 400,
        },
        options: Options(headers: {'api-key': apiKey}));
    // .then((value) => jsonDecode(value.data));

    return nearpay.session(
      sessionID: sessionResponse.data['id'], // Required
      enableReceiptUi: true, // [Optional] show the reciept in ui
      enableReversalUi:
          true, //[Optional] enable reversal of transaction from ui
      enableUiDismiss: true, //[Optional] the ui is dimissible
      finishTimeout: 60, //[Optional] finish timeout in seconds
      onSessionClosed: (session) {
        print("session closed");
        printJson(session.toJson());
      },
      onSessionOpen: (receipt) {
        print("session opened");
        printJson(receipt.toJson());
      },
      onSessionFailed: (err) {
        print("session error");
        print(err);
      },
    );
  }

  // =-=-=- Queries -=-=-=
  Future<dynamic> getTransaction() async {
    nearpay.getTransaction(
      transactionUUID: "a2fd6519-2b37-4336-be6d-5520bb3b6427",
      onResult: (receipts) {
        printJson(receipts.receipts![0].toJson());
      },
    );
  }

  Future<dynamic> getTransactions() async {
    nearpay.getTransactions(
      page: 1,
      limit: 30,
      onResult: (banner) {
        printJson(banner.toJson());
      },
    );
  }

  Future<dynamic> getReconciliation() async {
    nearpay.getReconciliation(
      reconciliationUUID: "6d4a48b8-d194-4aad-92c9-a77606758799",
      onResult: (receipts) {
        printJson(receipts.toJson());
      },
    );
  }

  Future<dynamic> getReconciliations() async {
    nearpay.getReconciliations(
      page: 1,
      limit: 30,
      onResult: (banner) {
        printJson(banner.toJson());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Nearpay Example'),
        ),
        body: ListView(
          children: [
            TextButton(
              onPressed: () async {
                purchaseAction();
              },
              child: const Text("Purchase"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () async {
                purchaseWithRefund();
              },
              child: const Text("Purchase and Refund"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () async {
                purchaseWithReverse();
              },
              child: const Text("Purchase and Reverse"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () async {
                reconcileAction();
              },
              child: const Text("RECONCILE"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () async {
                setupAction();
              },
              child: const Text("Setup"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () async {
                logoutAction();
              },
              child: const Text("Logout"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () async {
                sessionAction();
              },
              child: const Text("Session"),
            ),
            TextButton(
              onPressed: () async {
                getTransaction();
              },
              child: const Text("get transaction by uuid"),
            ),
            TextButton(
              onPressed: () async {
                getTransactions();
              },
              child: const Text("get transactions"),
            ),
            TextButton(
              onPressed: () async {
                getReconciliation();
              },
              child: const Text("get reconciliation by uuid"),
            ),
            TextButton(
              onPressed: () async {
                getReconciliations();
              },
              child: const Text("get reconciliations"),
            ),
            TextButton(
              onPressed: () async {
                final transactionData = await nearpay.purchase(
                  amount: 1200,
                );

                if (transactionData.receipts == null) return;

                await nearpay.receiptToImage(
                  receipt: transactionData.receipts![0],
                  fontSize: 1,
                  width: 850,
                  bitmapHandler: (imageBytes) {
                    setState(() {
                      bytes = imageBytes;
                    });
                  },
                );
              },
              child: const Text("test receipt image"),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: bytes != null ? Image.memory(bytes!) : Text('no Image'),
            ),
            Text("end of receipt")
          ],
        ),
      ),
    );
  }
}

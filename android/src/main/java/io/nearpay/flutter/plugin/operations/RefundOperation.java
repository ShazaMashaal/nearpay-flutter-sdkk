package io.nearpay.flutter.plugin.operations;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.MethodCall;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;

import io.nearpay.flutter.plugin.ErrorStatus;
import io.nearpay.flutter.plugin.NearpayLib;
import io.nearpay.flutter.plugin.PluginProvider;
import io.nearpay.sdk.data.models.TransactionReceipt;
import io.nearpay.sdk.utils.ReceiptUtilsKt;
import io.nearpay.sdk.utils.enums.RefundFailure;
import io.nearpay.sdk.utils.listeners.RefundListener;

public class RefundOperation extends BaseOperation {

    public RefundOperation(PluginProvider provider) {
        super(provider);
    }

    private void refundValidation(Map args, CompletableFuture<Map> promise) {
        String amountStr = args.get("amount") != null ? args.get("amount").toString() : "";
        String reference_retrieval_number = args.get("transaction_uuid") != null
                ? args.get("transaction_uuid").toString()
                : "";
        String customer_reference_number = args.get("customer_reference_number").toString();
        Boolean enableReceiptUi = args.get("enableReceiptUi") == null ? true : (Boolean) args.get("enableReceiptUi");
        String authvalue = args.get("authvalue") == null ? this.provider.getNearpayLib().authValueShared
                : args.get("authvalue").toString();
        String authType = args.get("authtype") == null ? this.provider.getNearpayLib().authTypeShared
                : args.get("authtype").toString();
        Boolean enableReversal =(Boolean) args.get("enableReversal");
        Boolean enableEditableRefundAmountUi = args.get("enableEditableRefundAmountUi") == null ? true
                : (Boolean) args.get("enableEditableRefundAmountUi");
        String finishTimeout = args.get("finishTimeout") != null ? args.get("finishTimeout").toString()
                : this.provider.getNearpayLib().timeOutDefault;
        Long timeout = Long.valueOf(finishTimeout);
        boolean isAuthValidated = this.provider.getNearpayLib().isAuthInputValidation(authType, authvalue);
        String adminPin = args.get("adminPin") == null ? null : (String) args.get("adminPin");

        if (amountStr == "") {
            Map<String, Object> paramMap = NearpayLib.commonResponse(ErrorStatus.invalid_argument_code,
                    "Purchase amount parameter missing");
            promise.complete(paramMap);
            return;
        }

        if (reference_retrieval_number == "") {
            Map<String, Object> paramMap = NearpayLib.commonResponse(ErrorStatus.invalid_argument_code,
                    "Transaction UUID parameter missing");
            promise.complete(paramMap);

            return;
        }

        if (!isAuthValidated) {
            Map<String, Object> paramMap = NearpayLib.commonResponse(ErrorStatus.invalid_argument_code,
                    "Authentication parameter missing");
            promise.complete(paramMap);
            return;
        }

        Long amount = Long.valueOf(amountStr);
        // doRefundAction(amount, reference_retrieval_number, customer_reference_number,
        // enableReceiptUi, enableReversal,
        // enableEditableRefundAmountUi, authType, authvalue, timeout, adminPin);

        provider.getNearpayLib().nearpay.refund(amount, reference_retrieval_number,
                customer_reference_number, enableReceiptUi,
                enableReversal, enableEditableRefundAmountUi, timeout, adminPin, new RefundListener() {
                    @Override
                    public void onRefundFailed(@NonNull RefundFailure refundFailure) {

                        if (refundFailure instanceof RefundFailure.GeneralFailure) {
                            // when there is General error .
                            Map<String, Object> paramMap = NearpayLib.commonResponse(ErrorStatus.general_failure_code,
                                    ErrorStatus.general_messsage);
                            promise.complete(paramMap);

                        } else if (refundFailure instanceof RefundFailure.RefundDeclined) {
                            // when the payment declined.
                            String messageResp = ((RefundFailure.RefundDeclined) refundFailure).toString();
                            String message = messageResp != "" && messageResp.length() > 0 ? messageResp
                                    : ErrorStatus.refund_declined_message;
                            Map<String, Object> paramMap = NearpayLib.commonResponse(ErrorStatus.refund_declined_code,
                                    message);
                            promise.complete(paramMap);

                        } else if (refundFailure instanceof RefundFailure.RefundRejected) {
                            // when the payment rejected.
                            String messageResp = ((RefundFailure.RefundRejected) refundFailure).toString();
                            String message = messageResp != "" && messageResp.length() > 0 ? messageResp
                                    : ErrorStatus.refund_rejected_message;
                            Map<String, Object> paramMap = NearpayLib.commonResponse(ErrorStatus.refund_rejected_code,
                                    message);
                            promise.complete(paramMap);

                        } else if (refundFailure instanceof RefundFailure.AuthenticationFailed) {
                            String messageResp = ((RefundFailure.AuthenticationFailed) refundFailure).toString();
                            String message = messageResp != "" && messageResp.length() > 0 ? messageResp
                                    : ErrorStatus.authentication_failed_message;
                            if (authType.equalsIgnoreCase("jwt")) {
                                Log.d("..call jwt call.1111...", authvalue);
                                provider.getNearpayLib().nearpay
                                        .updateAuthentication(provider.getNearpayLib().getAuthType(authType, authvalue));
                            }
                            Map<String, Object> paramMap = NearpayLib.commonResponse(ErrorStatus.auth_failed_code,
                                    message);
                            promise.complete(paramMap);

                        } else if (refundFailure instanceof RefundFailure.InvalidStatus) {
                            // you can get the status using the following code
                            String messageResp = ((RefundFailure.InvalidStatus) refundFailure).toString();
                            String message = messageResp != "" && messageResp.length() > 0 ? messageResp
                                    : ErrorStatus.invalid_status_messsage;
                            Map<String, Object> paramMap = NearpayLib.commonResponse(ErrorStatus.invalid_code, message);
                            promise.complete(paramMap);

                        }
                    }

                    @Override
                    public void onRefundApproved(@Nullable List<TransactionReceipt> list) {
                        List<Map<String, Object>> transactionList = new ArrayList<>();
                        for (TransactionReceipt transReceipt : list) {
                            String jsonStr = ReceiptUtilsKt.toJson(transReceipt);
                            transactionList.add(NearpayLib.JSONStringToMap(jsonStr));
                        }
                        Map<String, Object> responseDict = NearpayLib.commonResponse(ErrorStatus.success_code,
                                "Refund Success");
                        responseDict.put("list", transactionList);
                        promise.complete(responseDict);
                    }
                });

    }

    @Override
    public void run(Map args, CompletableFuture<Map> promise) {
        refundValidation(args, promise);
    }
}

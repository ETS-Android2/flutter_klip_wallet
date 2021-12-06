package com.example.flutter_klip_wallet;

import androidx.annotation.NonNull;

import com.klipwallet.app2app.api.Klip;
import com.klipwallet.app2app.api.KlipCallback;
import com.klipwallet.app2app.api.response.KlipErrorResponse;
import com.klipwallet.app2app.api.response.KlipResponse;
import com.klipwallet.app2app.exception.KlipRequestException;

import org.json.JSONException;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.flutter_klip_wallet/klip";

    @Override
    public void configureFlutterEngine(@NonNull io.flutter.embedding.engine.FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            Klip klip = Klip.getInstance(this);
                            if (call.method.equals("getUserPermission")) {
                                try {
                                    getUserPermission(klip, call.argument("requestKey"));
                                    result.success("success permission");
                                } catch (KlipRequestException e) {
                                    e.printStackTrace();
                                    result.error("UNAVAILABLE", "User address not available.", null);
                                }
                            } 
                            /*
                            else if (call.method.equals("getUserAddress")) {
                                String userAddress = null;
                                try {
                                    userAddress = getUserAddress(klip, call.argument("requestKey"));
                                    if (userAddress != null) {
                                        result.success(userAddress);
                                    } else {
                                        result.error("UNAVAILABLE", "User address null.", null);
                                    }
                                } catch (KlipRequestException e) {
                                    e.printStackTrace();
                                    result.error("UNAVAILABLE", "User address not available.", null);
                                }
                            }
                            */
                             else {
                                result.notImplemented();
                            }
                        }
                );
    }

    public void getUserPermission(Klip klip, String requestKey) throws KlipRequestException {
        klip.request(requestKey);
    }

    /*
    public String getUserAddress(Klip klip, String requestKey) throws KlipRequestException {
        //final String[] requestKey = new String[1];
        final String[] result = new String[1];

        KlipCallback getResultCallback = new KlipCallback<KlipResponse>() {
            @Override
            public void onSuccess(final KlipResponse res) {
                if (res.getResult() != null) {
                    try {
                        result[0] = res.getResult().toJson().get("klaytn_address").toString();
                        System.out.println("################################################");
                        System.out.println("getResult onSuccess : " + result[0]);
                        System.out.println("################################################");
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                } else {
                    //System.out.println("################################################");
                    //System.out.println("################# getResult : result is null !!!");
                    //System.out.println("################################################");
                }
            }

            @Override
            public void onFail(final KlipErrorResponse res) {
                //System.out.println("################################################");
                //System.out.println("get result error: " + res.getErrorMsg());
                //System.out.println("################################################");
            }
        };

        klip.getResult(requestKey, getResultCallback);
        System.out.println("################################################");
        System.out.println("getResult return value : " + result[0]);
        System.out.println("################################################");
        return result[0];
    }
    */
}


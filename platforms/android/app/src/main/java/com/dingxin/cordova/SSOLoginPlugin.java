package com.dingxin.cordova;

import android.app.Activity;
import android.app.AlertDialog;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;
import android.content.DialogInterface;
import com.comtop.eim.appstore.sso.ErrorInfo;
import com.comtop.eim.appstore.sso.IRenewTokenListener;
import com.comtop.eim.appstore.sso.SsoUtils;
import com.comtop.eim.appstore.sso.UserInfo;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Intent;
import android.provider.Settings;
import android.net.Uri;
/**
 * Created by seven on 2018/5/9. desc
 */

public class SSOLoginPlugin extends CordovaPlugin {
    private Activity context;
    private CallbackContext logincallBack;
    private static final String TAG = "sso";
    private static final int REQUEST_CODE_PERMISSION = 1;
    @Override
    public boolean execute(final String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

        Log.d(TAG, "sso plugin: " + action + ", args: " + args);

        context = cordova.getActivity();
        logincallBack = callbackContext;
        if ("ssoLogin".equals(action)) {
            context.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    renewToken();
                }
            });
            return true;
        }

        return false;
    }

    private String getParams(String token, UserInfo userInfo) {
        StringBuffer params = new StringBuffer("{");
        params.append("\"username\":\"");
        params.append(userInfo.getUserAccount());
        params.append("\",\"password\":\"");
        params.append(userInfo.getUserPd());
        params.append("\",\"token\":\"");
        params.append(token);
        params.append("\"}");

        return params.toString();
    }

    /**
     * 检查权限，如果没有权限会自动申请权限
     * @param requestCode 申请权限的requestCode
     * @return 返回true表示有权限，否则没有
     */
    private boolean checkPermission(int requestCode) {
        return SsoUtils.checkPermission(context, requestCode);
    }


    public void renewToken() {

         // Token过期后续期
         if (!checkPermission(REQUEST_CODE_PERMISSION)) {
           
                    return;
        }
        // Token过期后续期
        SsoUtils.renewToken(context, new IRenewTokenListener() {
            @Override
            public void onRenewError(ErrorInfo info) {
                String msg = info.getErrorMsg();
                if (TextUtils.isEmpty(msg)) {
                    String res;
                    switch (info.getErrorCode()) {
                    case ErrorInfo.ERROR_SSO_CANCEL:
                        res = "用户取消操作";
                        break;
                    case ErrorInfo.ERROR_INVALID_ARGS:
                        res = "登录所需参数错误";
                        break;
                    case ErrorInfo.ERROR_NO_APP_STORE:
                        res = "没有安装移动应用门户";
                        break;
                    case ErrorInfo.ERROR_SSO_ERROR:
                        res = "续期Token失败";
                        break;
                    default:
                        res = "续期Token失败";
                    }
                    msg = res;
                }
                showToast(msg);
            }

            @Override
            public void onRenewToken(String newToken, UserInfo userInfo) {

                Log.d(TAG, "newToken: " + newToken + ", " + ", userInfo: " + userInfo);
                showToast("续期Token成功");

                String paramStr = getParams(newToken, userInfo);
                logincallBack.success(paramStr);
            }
        });
    }
    private void launchPrivilege() {
        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        Uri uri = Uri.fromParts("package", context.getPackageName(), null);
        intent.setData(uri);
        context.startActivity(intent);
    }

    @Override
    public void onRequestPermissionResult(int requestCode, String[] permissions, int[] grantResults) throws JSONException {
        super.onRequestPermissionResult(requestCode, permissions, grantResults);
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setTitle("权限提示")
                .setMessage("没有获取移动应用门户的用户信息权限")
                .setPositiveButton("去开启", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        launchPrivilege();
                    }
                })
                .setNegativeButton("取消", null)
                .show();
    }

    private void showToast(String msg) {
        Toast.makeText(context, msg, Toast.LENGTH_SHORT).show();
    }

}

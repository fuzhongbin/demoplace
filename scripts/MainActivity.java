package {{appid}};

import android.Manifest;
import android.app.Activity;
import android.content.Intent;

import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.text.TextUtils;
import android.widget.Toast;

import org.apache.cordova.*;

import java.util.ArrayList;

public class MainActivity extends CordovaActivity {

    private static MainActivity activity;
    public static String param = "";

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getParamsFromIntentAndSet(this);
        // enable Cordova apps to be started in the background
        Bundle extras = getIntent().getExtras();
        if (extras != null && extras.getBoolean("cdvStartInBackground", false)) {
            moveTaskToBack(true);
            activity = this;
        }
        checkPermission();
        // Set by <content src="index.html" /> in config.xml
        loadUrl(launchUrl);
    }

    /**
     * 启动获取参数
     */
    private void getParamsFromIntentAndSet(Activity context) {
        Intent intent = context.getIntent();
        StringBuffer params = new StringBuffer("{");
        if (TextUtils.isEmpty(intent.getStringExtra("token"))) {
            return;
        }
        params.append("\"username\":\"");
        params.append(Base64Utils.getFromBase64(intent.getStringExtra("username")));
        params.append("\",\"password\":\"");
        params.append(Base64Utils.getFromBase64(intent.getStringExtra("password")));
        params.append("\",\"token\":\"");
        params.append(Base64Utils.getFromBase64(intent.getStringExtra("token")));
        params.append("\"}");
        param = params.toString();
    }

    /**
     * 检查权限
     *
     * @return 有权限，则返回true，否则返回false
     */
    public boolean checkPermission() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return true;
        }
        ArrayList<String> permissions = new ArrayList();
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            permissions.add(Manifest.permission.WRITE_EXTERNAL_STORAGE);
        }
        if (!permissions.isEmpty()) {
            String[] arr = new String[permissions.size()];
            permissions.toArray(arr);
            ActivityCompat.requestPermissions(this, arr, PERMISSION_REQUEST_CODE_RS);
            return false;
        }
        return true;
    }

    private static final int PERMISSION_REQUEST_CODE_RS = 1;

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        switch (requestCode) {
            case PERMISSION_REQUEST_CODE_RS:
                if (grantResults[0] != PackageManager.PERMISSION_GRANTED) {
                    Toast.makeText(this, "没有权限", Toast.LENGTH_SHORT).show();
                    finish();
                }
                break;
            default:
        }
    }
}

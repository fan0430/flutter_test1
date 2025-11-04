package com.example.test_flutter;

import java.io.File;
import java.io.IOException;
import java.util.List;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterShellArgs;

import android.os.Bundle;
import android.widget.Toast;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.StringCodec;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.basic_channel";
    @Override
    public FlutterShellArgs getFlutterShellArgs() {
        Log.e("asdasd","asdasdsad");
        // 获取应用程序的私有数据目录
        File appDirectory = this.getFilesDir(); // /data/data/com.example.untitled1/files
        File subDirectory = new File(appDirectory, "subdirectory");
        Log.e("asdasd",appDirectory.toString());
        // 创建子目录
        if (!subDirectory.exists()) {
            boolean isCreated = subDirectory.mkdirs();
            if (isCreated) {
                System.out.println("Subdirectory created successfully.");
            } else {
                System.out.println("Failed to create subdirectory.");
            }
        }

        // 在子目录中创建一个文件
        File file = new File(subDirectory, "myfile.txt");
        if (!file.exists()) {
            try {
                boolean isFileCreated = file.createNewFile();
                if (isFileCreated) {
                    System.out.println("File created successfully.");
                } else {
                    System.out.println("Failed to create file.");
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        FlutterShellArgs args = super.getFlutterShellArgs();
        args.add("--aot-shared-library-name=libfixedapp.so");
        args.add("--aot-shared-library-name="+appDirectory.toString()+"/libfixedapp.so");
        args.add("--aot-shared-library-name=libfixedflutter.so");
        args.add("--aot-shared-library-name="+appDirectory.toString()+"/libfixedflutter.so");
        Log.e("asdasd",args.toString());
        // 获取所有参数
        List<String> allArgs = List.of(args.toArray());

        // 打印所有参数
        System.out.println("FlutterShellArgs contents:");
        for (String arg : allArgs) {
            System.out.println(arg);
        }
        return args;
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        BasicMessageChannel<String> channel = new BasicMessageChannel<>(
                flutterEngine.getDartExecutor().getBinaryMessenger(),
                CHANNEL,
                StringCodec.INSTANCE
        );

        channel.setMessageHandler((message, reply) -> {
            Log.e("setMessageHandler",message);
            Toast.makeText(this, "Received from Flutter: " + message, Toast.LENGTH_SHORT).show();
            reply.reply("Hello from Android!");
        });
    }
}

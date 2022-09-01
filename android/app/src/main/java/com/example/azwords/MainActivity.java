package com.example.azwords;

import android.content.Context;
import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.Map;
import java.util.List;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.android.FlutterActivity;
import java.io.*;

public class MainActivity extends FlutterActivity {

    static String word;
    static String meaning;
    static ArrayList<Word> words = new ArrayList<>();
    
    static Word loadword(Context context)
    {
        return new Word(word,meaning);
    }

    @Override public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        String CHANNEL = "sendData";
        new  MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
               (call,result) ->
               {

                   if(call.method.equals("fun"))
                   {

                       result.success(WordWidget.synData());
//                      WordWidget.words = WordWidget.dataBase.getwords();
//                       WordWidget.words = new ArrayList<>();


                      return;
                   }
//

               }
       );
    }
}

package com.example.azwords;

import static android.content.Intent.getIntent;
import static android.content.Intent.getIntentOld;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.widget.RemoteViews;
import android.widget.Toast;

import java.net.URISyntaxException;
import java.util.Random;
import java.util.Timer;
import java.util.TimerTask;

public class WordWidget extends AppWidgetProvider
{
    public static final String FORWARD = "FORWARD";
    public static final String BACKWORD = "BACKWARD";
    static int n=-1;
    static DataBase dataBase;
    static Timer timer = new Timer();
    static TimerTask  timerTask;
    static Word root;
    static int l=-1;
    static int synData()
    {
        MainActivity.words= dataBase.getwords();

        return MainActivity.words.size();
    }
    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        dataBase = new DataBase(context);
        synData();
        for (int appWidgetId :appWidgetIds) {
            update(context,appWidgetManager,appWidgetId,0);
        }
        super.onUpdate(context, appWidgetManager, appWidgetIds);
    }

    @Override
    public void onDeleted(Context context, int[] appWidgetIds) {
        super.onDeleted(context, appWidgetIds);
    }

    void update(Context context, AppWidgetManager appWidgetManager, int appWidgetId,int index)
    {

        Intent forwardIntent = new Intent(context,WordWidget.class);
        forwardIntent.setAction(FORWARD);
        Intent backwardIntent = new Intent(context,WordWidget.class);
        backwardIntent.setAction(BACKWORD);
//        Toast.makeText(context, "appWidgetID : "+appWidgetId + " index : " + index, Toast.LENGTH_SHORT).show();
        forwardIntent.putExtra("appWidgetId",appWidgetId);

        forwardIntent.putExtra("index",index);
        forwardIntent.setData(Uri.parse(forwardIntent.toUri(Intent.URI_INTENT_SCHEME)));
        backwardIntent.putExtra("appWidgetId",appWidgetId);

        backwardIntent.putExtra("index",index);
        backwardIntent.setData(Uri.parse(backwardIntent.toUri(Intent.URI_INTENT_SCHEME)));
        PendingIntent forwardPendingIntent = PendingIntent.getBroadcast(context,0,forwardIntent,0);
        PendingIntent backwardPendingIntent = PendingIntent.getBroadcast(context,1,backwardIntent,0);
        Timer timer = new Timer();

        RemoteViews views = new RemoteViews(context.getPackageName(),R.layout.word_widget);
        views.setOnClickPendingIntent(R.id.forwar_button,forwardPendingIntent);
        views.setOnClickPendingIntent(R.id.back_button,backwardPendingIntent);
        views.setTextViewText(R.id.word,MainActivity.words.get(index).word);

        appWidgetManager.updateAppWidget(appWidgetId,views);

    }
    @Override
    public void onReceive(Context context, Intent intent) {
        if(FORWARD.equals(intent.getAction()))
        {
            int index = intent.getIntExtra("index",0);
            int appWidgetId = intent.getIntExtra("appWidgetId",0);
            if(index < MainActivity.words.size() -1 )
            update(context,AppWidgetManager.getInstance(context),appWidgetId,index +1);
            else
                update(context,AppWidgetManager.getInstance(context),appWidgetId,0);
        }
        if(BACKWORD.equals(intent.getAction()))
        {
            int index = intent.getIntExtra("index",0);
            int appWidgetId = intent.getIntExtra("appWidgetId",0);
            if(index > 0)
                update(context,AppWidgetManager.getInstance(context),appWidgetId,index -1);
            else
                update(context,AppWidgetManager.getInstance(context),appWidgetId,MainActivity.words.size() -1);
        }
        super.onReceive(context, intent);
    }
}
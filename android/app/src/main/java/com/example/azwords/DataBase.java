package com.example.azwords;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import java.util.ArrayList;

public class DataBase extends SQLiteOpenHelper {
    public static final String DB_Name = "words.db";
    public static  final int DB_Verson = 1;
    public DataBase(Context context){
        super(context,DB_Name,null,DB_Verson);
    }

    @Override
    public void onCreate(SQLiteDatabase sqLiteDatabase)
    {

    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }


    public ArrayList<Word> getwords()
    {
        ArrayList<Word> words = new ArrayList<>();
        SQLiteDatabase db = getReadableDatabase();
        Cursor cursor = db.rawQuery("SELECT * FROM wordsTable",null);
        if(cursor.moveToFirst())
        {
            do {
                String word = cursor.getString(0);
                String meanings = cursor.getString(1);
                words.add(new Word(word,meanings));
            }while (cursor.moveToNext());
            cursor.close();
        }
        return words;
    }
}

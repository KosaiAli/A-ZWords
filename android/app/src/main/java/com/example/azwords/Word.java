package com.example.azwords;

import java.util.List;

public class Word {
    String word;
    String meanings;
    Word next;
    public Word(String word,String meanings)
    {
        this.word = word;
        this.meanings = meanings;
    }
}

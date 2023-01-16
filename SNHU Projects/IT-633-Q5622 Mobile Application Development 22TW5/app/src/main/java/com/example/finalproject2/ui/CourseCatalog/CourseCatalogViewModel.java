package com.example.finalproject2.ui.CourseCatalog;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

public class CourseCatalogViewModel extends ViewModel {

    private final MutableLiveData<String> mText;

    public CourseCatalogViewModel() {
        mText = new MutableLiveData<>();
        mText.setValue("This is course catalog fragment");
    }

    public LiveData<String> getText() {
        return mText;
    }
}
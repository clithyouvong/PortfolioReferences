package com.example.finalproject2.ui.Admissions;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

public class AdmissionsViewModel extends ViewModel {

    private final MutableLiveData<String> mText;

    public AdmissionsViewModel() {
        mText = new MutableLiveData<>();
        mText.setValue("This the admissions fragment");
    }

    public LiveData<String> getText() {
        return mText;
    }
}
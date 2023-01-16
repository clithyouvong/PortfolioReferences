package com.example.finalproject2.ui.TuitionAndFinancialAid;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

public class TuitionAndFinancialAidViewModel extends ViewModel {
    private final MutableLiveData<String> mText;

    public TuitionAndFinancialAidViewModel() {
        mText = new MutableLiveData<>();
        mText.setValue("This the tuition and financial aid fragment");
    }

    public LiveData<String> getText() {
        return mText;
    }
}
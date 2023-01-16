package com.example.finalproject2.ui.TuitionAndFinancialAid;

import androidx.lifecycle.ViewModelProvider;

import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.example.finalproject2.databinding.FragmentTuitionAndFinancialAidBinding;

public class TuitionAndFinancialAidFragment extends Fragment {

    private FragmentTuitionAndFinancialAidBinding binding;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        TuitionAndFinancialAidViewModel tuitionAndFinancialAidViewModel =
                new ViewModelProvider(this).get(TuitionAndFinancialAidViewModel.class);

        binding = FragmentTuitionAndFinancialAidBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        final TextView textView = binding.textTuitionAndFinancialAid;
        tuitionAndFinancialAidViewModel.getText().observe(getViewLifecycleOwner(), textView::setText);
        return root;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }

}
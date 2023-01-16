package com.example.finalproject2.ui.Admissions;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;

import com.example.finalproject2.databinding.FragmentAdmissionsBinding;

public class AdmissionsFragment extends Fragment {

    private FragmentAdmissionsBinding binding;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        AdmissionsViewModel admissionsViewModel =
                new ViewModelProvider(this).get(AdmissionsViewModel.class);

        binding = FragmentAdmissionsBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        final TextView textView = binding.textAdmissions;
        admissionsViewModel.getText().observe(getViewLifecycleOwner(), textView::setText);
        return root;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}
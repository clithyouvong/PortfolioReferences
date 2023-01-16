package com.example.finalproject2.ui.CourseCatalog;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;

import com.example.finalproject2.databinding.FragmentCoursecatalogBinding;

public class CourseCatalogFragment extends Fragment {

    private FragmentCoursecatalogBinding binding;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        CourseCatalogViewModel courseCatalogViewModel =
                new ViewModelProvider(this).get(CourseCatalogViewModel.class);

        binding = FragmentCoursecatalogBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        final TextView textView = binding.textCoursecatalog;
        courseCatalogViewModel.getText().observe(getViewLifecycleOwner(), textView::setText);
        return root;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}
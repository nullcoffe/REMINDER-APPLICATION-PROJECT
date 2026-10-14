import 'dart:async';
import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryProvider extends ChangeNotifier {

  final CategoryService _categoryService = CategoryService();

  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  StreamSubscription<List<CategoryModel>>?
      _categorySubscription;


  void listenCategories(String userId) {

    _isLoading = true;

    notifyListeners();

    _categorySubscription =
        _categoryService
            .getCategories(userId)
            .listen((categoryList) {


              _categories = categoryList;


              _isLoading = false;


              notifyListeners();


            });


  }

  Future<void> addCategory(CategoryModel category) async {

    await _categoryService.createCategory(category);

  }

  Future<void> updateCategory(CategoryModel category) async {

    await _categoryService.updateCategory(category);

  }

  Future<void> deleteCategory(String categoryId) async {

    await _categoryService.deleteCategory(categoryId);

  }

  @override
  void dispose() {


    _categorySubscription?.cancel();


    super.dispose();

  }

}
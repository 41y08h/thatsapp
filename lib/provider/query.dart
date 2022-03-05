import 'package:flutter/cupertino.dart';

class Query with ChangeNotifier {
  bool _isLoading = false;
  dynamic _data;
  Object? _error;

  bool get isLoading => _isLoading;
  dynamic get data => _data;
  Object? get error => _error;

  Future Function()? fetcher;

  void init(Future Function() fetcher) async {
    this.fetcher = fetcher;
    _isLoading = true;
    try {
      _data = await fetcher();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _error = error;
      notifyListeners();
    }
  }

  void refresh() async {
    try {
      _data = await fetcher!();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _error = error;
      notifyListeners();
    }
  }
}

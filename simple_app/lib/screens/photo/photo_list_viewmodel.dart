import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_app/data/api/responses/unsplash/unsplash_response.dart';
import 'package:simple_app/data/models/result.dart';
import 'package:simple_app/data/repository/unsplash_repository.dart';
import 'package:simple_app/data/repository/unsplash_repository_impl.dart';

final photoListViewModelProvider =
    ChangeNotifierProvider((ref) => PhotoListViewModel(ref.read));

class PhotoListViewModel extends ChangeNotifier {
  PhotoListViewModel(this._reader);

  final Reader _reader;

  late final UnsplashRepository _repository =
      _reader(unsplashRepositoryProvider);

  Result<UnsplashResponse>? _news;
  Result<UnsplashResponse>? get news => _news;

  Future<void> searchPhotos() {
    return _repository
        .getUnsplashPhoto()
        .then((value) => _news = value)
        .whenComplete(notifyListeners);
  }
}
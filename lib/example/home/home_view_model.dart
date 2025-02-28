import 'package:jelly_2vm/quantum.dart';
import 'package:jelly_2vm/view_model.dart';

import './home_view.dart';

class HomeViewModel extends ViewModel
    with ViewModelDelegator<HomeViewDelegate> {
  HomeViewModel({required HomeViewDelegate delegate}) {
    addDelegate(delegate);

    counter.addListener(() {
      delegate.onCounterChanged(counter.value);
    });
  }

  final counter = Atom(0);

  final persistedCounter = Atom.persisted(
    0,
    persistentStorageInterface: PersistentStorageInterface(
      key: 'counter',
      encoder: (value) => value.toString(),
      decoder: (value) => value != null ? int.parse(value) : 0,
    ),
  );

  late final showWarning = MoleculeFrom1<int, bool>(
    quantum: persistedCounter,
    map: (value) => value > 10,
  );
}

class PersistentStorageInterface<T>
    implements AtomPersistentStorageInterface<T> {
  PersistentStorageInterface({
    required this.key,
    required this.encoder,
    required this.decoder,
  });

  final String? Function(T value) encoder;
  final T Function(String? value) decoder;
  final String key;

  @override
  Future<T> get() async {
    // Here you get the value from the persistent storage

    throw UnimplementedError();
  }

  @override
  Future<void> save(T value) async {
    //final encodedValue = encoder(value);

    // Here you save the value to the persistent storage
    throw UnimplementedError();
  }

  @override
  // Set this to false if you want to use the given default value instead of getting it from the persistent storage
  bool get initialValueFromStorage => true;

  @override
  void onGetError(Object? e, T lastValue) {}

  @override
  void onSaveError(Object? e) {
    // TODO: implement onSaveError
  }

  @override
  void onSaveSuccess(Object? e) {
    // TODO: implement onSaveSuccess
  }
}

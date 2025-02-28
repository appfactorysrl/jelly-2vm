# Quantums

### What is a Quantum

A Quantum is an object that represents a value that can change over time and notifies its listeners when it is modified.

### Why

Sometimes having a state for the entire page can lead to performance issues. For this reason, you can use a Quantum to represent the state of a specific portion of the page. Then using the QuantumBuilder you can make that portion reactive.

### How

Let's take a simple counter as an example:


```dart
// counter_view.dart

class CounterView extends ViewWidget<CounterViewModel> {
  const CounterView({super.key});
  
  @override
  HomeViewModel createViewModel() {
    return HomeViewModel(delegate: this);
  }

  @override
  Widget build(BuildContext context, CounterViewModel viewModel) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            QuantumBuilder<int>(
              quantum: viewModel.counter,
              builder: (context, value) {
                return Text('$value');
              },
            ),
            ElevatedButton(
              onPressed: viewModel.increment,
              child: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
```

```dart
// counter_view_model.dart

class CounterViewModel extends ViewModel {
  final Quantum<int> counter = Quantum<int>(0);

  void increment() {
    counter.value++;
  }
}
```

In this way we can limit the reactivity to the only text to be re-rendered.

(For a more complete example, see the example in [HomeView](https://github.com/appfactorysrl/jelly-2vm/blob/main/example/home/home_view.dart))

### Persistence of atoms

The value of an atom can be persisted using `persistentStorageInterface`

```dart
final persistedCounter = Atom.persisted(
  0,
  persistentStorageInterface: PersistentStorageInterface(
    key: 'counter',
    encoder: (value) => value.toString(),
    decoder: (value) => value != null ? int.parse(value) : 0,
  ),
);
```

In this way the value of `persistedCounter` will be saved and can be retrieved even after the app is restarted.

### Molecules

Molecules are functions that take one (or more) quantum as input and return another quantum as output.

```dart
final showWarning = MoleculeFrom1<int, bool>(
  quantum: persistedCounter,
  map: (value) => value > 10,
);
```

Molecules can be used to process the data of a quantum and return for example a string to be displayed.
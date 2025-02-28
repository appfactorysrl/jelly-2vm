# jelly-2vm: A Lightweight MVVM Microframework for Flutter

[![GitHub Stars](https://img.shields.io/github/stars/appfactorysrl/jelly-2vm?style=social)](https://github.com/appfactorysrl/jelly-2vm/stargazers)
[![GitHub Issues](https://img.shields.io/github/issues/appfactorysrl/jelly-2vm)](https://github.com/appfactorysrl/jelly-2vm/issues)
[![GitHub License](https://img.shields.io/github/license/appfactorysrl/jelly-2vm)](https://github.com/appfactorysrl/jelly-2vm/blob/main/LICENSE)

**jelly-2vm** is a lightweight microframework for Flutter, based on the Model-View-ViewModel (MVVM) pattern, designed to enhance the **maintainability**, **simplicity**, and **scalability** of your applications. Born from AppFactory's experience with apps serving millions of users in Italy, jelly-2vm provides a clear and reactive structure for Flutter app development.

**Read more about the philosophy and implementation of jelly-2vm in our article on Medium: [Building Scalable Flutter Apps with jelly-2vm: A Lightweight MVVM Architecture](https://medium.com/@luca.roverelli/95be868b18b9)**

## Key Features

* **Clear MVVM Architecture**: Clean separation between View, ViewModel, and Service for more organized code.
* **Optimized Reactivity**: Targeted UI updates with `ChangeBuilder`, avoiding unnecessary rebuilds.
* **Service Management**: Services as singletons managed with `GetIt` for easy dependency injection.
* **Reactive Services**: `ServiceNotifier` for reactive communication between services.
* **Simplicity**: Minimal API with only three main classes: `ViewModel`, `ViewWidget`, and `ChangeBuilder`.
* **Testability**: Easy mocking and testing thanks to dependency injection.
* **Scalability**: Designed for large-scale applications and extended teams.

## Installation

Add `jelly-2vm` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  jelly_2vm: ^latest_version
```

Run `flutter pub get` to install the package.

## Usage

### Example: Counter App

#### ViewModel:

```dart
class CounterViewModel extends ViewModel {
  CounterViewModel(this.count);
  int count;

  void increment(int amount) {
    count += amount;
    notifyListeners();
  }

  void decrement(int amount) {
    count -= amount;
    notifyListeners();
  }
}
```

#### View:

```dart
class CounterView extends ViewWidget<CounterViewModel> {
  CounterView({Key? key}) : super(key: key);

  @override
  CounterViewModel createViewModel() {
    return CounterViewModel(0);
  }

  @override
  Widget builder(BuildContext context, CounterViewModel counterViewModel) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () => counterViewModel.increment(1),
                child: const Text("Increment"),
              ),
              ChangeBuilder<CounterViewModel>(
                listen: counterViewModel,
                builder: (context, state) => Text("${state.count}"),
              ),
              MaterialButton(
                onPressed: () => counterViewModel.decrement(1),
                child: const Text("Decrement"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Services

Please refer to the Medium article for more details on the services and how to use them.

#### StorageService (Example):

```dart
class StorageService {
  StorageService();

  Future<void> save(String key, String value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(key, value);
  }

  // ... other methods ...
}
```

#### Service Initialization:

```dart
final getIt = GetIt.instance;

class Services {
  static void init() {
    getIt.registerSingleton<StorageService>(StorageService());
    // ... other services ...
  }

  static T get<T extends Object>() {
    return getIt.get<T>();
  }
}
```

#### Service Notifier:

```dart
mixin class ServiceNotifier {
  final List<VoidCallback> _callbacks = [];
  void addListener(VoidCallback callback) {
    if (_callbacks.contains(callback)) {
      return;
    }
    _callbacks.add(callback);
  }

  void removeListener(VoidCallback callback) {
    _callbacks.remove(callback);
  }

  void notifyListeners() {
    for (final c in _callbacks) {
      try {
        c();
      } catch (e) {
        AppLogger.d(e.toString());
      }
    }
  }
}
```

### Delegator 🐊

Inspired by Swift for iOS, it will help you to dispatch functions that will run on the View from your ViewModel.

Please refer to the [docs](https://github.com/appfactorysrl/jelly-2vm/blob/main/docs/delegate.md) for more details.


## Best Practices

- A `View + ViewModel` can represent an entire page or a portion of it.
- Views can use `StatelessWidget` for layout sections.
- Services are singletons managed with `GetIt`.
- Use `ServiceNotifier` to make services reactive.



## Quantums ⚛️

Quantums is the evolution of the Model-View-ViewModel pattern, in order to have a finer-grained reactivity and control over the state of the UI.
Using quantums you can have a state of a specific part of the UI that can be observed and updated independently from the rest of the UI.

### Why

Sometimes having a state of the whole page can lead to performance issues, for this reason you can use a Quantum to represent the state of a specific part of the page. Using then the QuantumBuilder you can make the part reactive.

### How

Let's take as an example a simple counter:

** View **

```dart
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

** ViewModel **

```dart
class CounterViewModel extends ViewModel {
  final Quantum<int> counter = Quantum<int>(0);

  void increment() {
    counter.value++;
  }
}
```

For more examples, see the [docs](https://github.com/appfactorysrl/jelly-2vm/blob/main/docs/quantums.md).




## Contributing
jelly-2vm is open-source! Feel free to contribute with pull requests, report bugs, or suggest new features.

## License
jelly-2vm is released under the MIT License. See the [LICENSE](https://github.com/appfactorysrl/jelly-2vm/blob/main/LICENSE) file for details.

## Contact
For questions or support, please open an issue on GitHub.


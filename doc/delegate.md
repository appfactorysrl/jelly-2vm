## Delegates in the jelly-2vm framework

### What is a delegate

A delegate allows a viewModel to execute functions that use the interface, for example, opening a popup following an error.

### Why

Let's say we have a Login page. In this page's View there is a button that calls a method (asynchronous) within its related ViewModel. We want the application to move to the next page once the call is completed.

To keep as little logic as possible in the View, we'll only use two methods: one to go to the next page `goToNextPage` and one to show an error popup `showLoginErrorAlert`.

Still aiming to keep minimal logic in the View, we want to somehow call these two methods from the viewModel. This is where delegates come into play - they are **objects** to which we can **delegate actions**. These actions are defined in an interface that the View must implement, along with its methods.

### How

In this case, we're referring to delegates between View and ViewModel, but the concept can be extended to Services as well.

In the View, we create the Delegate interface
```dart
// login_view.dart

abstract class LoginViewDelegate {
  // The viewModel might be useful for calling methods later
  onLoginError(Object e, LoginViewModel viewModel); 
  onLoginSuccess(LoginViewModel viewModel); 
}
```

We adapt the ViewModel
```dart
// login_view_model.dart

// import

class LoginViewModel extends ViewModel with ViewModelDelegator<LoginView>{ // 1 - ViewModelDelegator mixin
  LoginViewModel({required LoginViewDelegate delegate}){
    addDelegate(delegate); // 2 - addDelegate
  }
}
```

- In Step 1, we add the ViewModelDelegator mixin to the ViewModel. This mixin is simply an abstraction for adding/removing delegates, and it also exposes a method for calling delegates, which we'll see later.

- In Step 2, we add the delegate, which is passed in the constructor, to the ViewModel.

We pass the delegate to the ViewModel during creation in the View, and implement the methods
```dart
class LoginView extends ViewWidget<LoginViewModel> 
    implements LoginViewDelegate{
  // code
  
  @override
  LoginViewModel createViewModel() {
    return LoginViewModel(delegate: this); // LoginView is itself the delegate
  }

  @override
  onLoginError(Object e, LoginViewModel viewModel){
    showDialog(
      // code
    );
  }

  @override
  onLoginSuccess(Object e, LoginViewModel viewModel){
    
  }

  void goToNextPage(){
    if(!context.mounted) return; // Check that the context is still mounted
    context.pushNamed(...);
  }

  void showLoginErrorAlert{
    if(!context.mounted) return; // Check that the context is still mounted
    showDialog(
      ...
    );
  }

  // code
}
```

We can now use the delegate from the ViewModel like this

```dart
// code

Future<void> makeLogin({required String email, required String password}){
  try{
    // Make api call

    // Handling success
    delegateAction((delegate) => delegate.onLoginSuccess(this))
  }catch (e){
    delegateAction((delegate) => delegate.onLoginError(e, this))
  }
}

// code
```

By doing this, in the View we'll only need to call `makeLogin` without waiting for its completion.

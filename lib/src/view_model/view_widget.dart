import 'package:flutter/material.dart';
import 'package:jelly_2vm/view_model.dart';

abstract class ViewWidget<T extends ViewModel> extends StatefulWidget {
  ViewWidget({
    Key? key,
  }) : super(key: key);

  final _BuildContextContainer _contextContainer = _BuildContextContainer();

  T createViewModel();
  Widget builder(BuildContext context, T viewModel);

  void initState(T viewModel) {}

  void dispose(T viewModel) {}

  /// Obtains (if available) the current context
  BuildContext get context {
    if (_contextContainer.context == null) {
      throw 'Trying to access the context when is not yet initialized';
    }
    return _contextContainer.context!;
  }

  TickerProviderStateMixin get vsync {
    return _contextContainer.vsync!;
  }

  @override
  State<ViewWidget<T>> createState() => _ViewWidgetState<T>();
}

class _ViewWidgetState<T extends ViewModel> extends State<ViewWidget<T>>
    with TickerProviderStateMixin {
  late T viewModel;
  @override
  void initState() {
    super.initState();
    widget._contextContainer.vsync = this;
    viewModel = widget.createViewModel();
    widget.initState(viewModel);
  }

  @override
  void dispose() {
    widget.dispose(viewModel);
    viewModel.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ViewWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ignore: unnecessary_null_comparison
    if (mounted && context == null) {
      widget._contextContainer.context = context;
      widget._contextContainer.vsync = this;
    }
  }

  @override
  Widget build(BuildContext context) {
    widget._contextContainer.context = context;
    widget._contextContainer.vsync = this;
    return widget.builder(context, viewModel);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ignore: unnecessary_null_comparison
    if (mounted && context != null) {
      widget._contextContainer.context = context;
    }
  }
}

class _BuildContextContainer {
  BuildContext? context;
  TickerProviderStateMixin? vsync;
}

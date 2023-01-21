import 'package:flutter/material.dart';
import 'package:view_model_x/view_model_x.dart';
import 'package:view_model_x_state_management/ui/home_page.dart';

void main() {
  runApp(const MyApp());
}

class CounterViewModel extends ViewModel {
  // initialize MutableStateFlow with initial value 1
  final _counterStateFlow = MutableStateFlow<int>(1);

  StateFlow<int> get counterStateFlow => _counterStateFlow;

  // you can also define more the one StateFlow or SharedFlow inside any ViewModel

  void increment() {
    // by changing the value, listeners notified
    _counterStateFlow.value = _counterStateFlow.value + 1;
  }

  @override
  void dispose() {
    // must dispose all the StateFlows and SharedFlows
    _counterStateFlow.dispose();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: ViewModelProvider(create: (BuildContext context) {
        return CounterViewModel();
      },
      // child: const MyHomePage(title: 'Flutter Demo Home Page')),
      child: HomePage()),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            StateFlowBuilder(
              builder: (context, value) {
                return Text(
                  '$value',
                  style: Theme.of(context).textTheme.headline4,
                );
              }, stateFlow: context.vm<CounterViewModel>().counterStateFlow,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.vm<CounterViewModel>().increment();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

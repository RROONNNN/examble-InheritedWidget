import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Inherited Widget',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: MyHomePage(aaa: api(), child: gesteurepage()));
  }
}

class MyHomePage extends StatefulWidget {
  Widget child;
  api aaa;
  MyHomePage({super.key, required this.aaa, required this.child});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title = 'asf';
  @override
  void didChangeDependencies() {
    print("dependencis\n");
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    print("build home");
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ApiProvider(Api: widget.aaa, child: widget.child),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        // nhấn vào thì sẽ rebuild hàm build này
        final title1 = await widget.aaa.getdateandtime();
        setState(() {
          title = title1;
        });
      }),
    );
  }
}

class gesteurepage extends StatefulWidget {
  const gesteurepage({super.key});

  @override
  State<gesteurepage> createState() => _gesteurepageState();
}

class _gesteurepageState extends State<gesteurepage> {
  @override
  Widget build(BuildContext context) {
    String title = 'abc';
    return GestureDetector(
      onTap: () async {
        final a = ApiProvider.of(context).Api;
        print("deptrai");
        final title1 = await a.getdateandtime();
        title = title1;
        print("build ges ${title}\n");
      },
      child: SizedBox.expand(
        child: Container(color: Colors.amber, child: DateTimeWidget()),
      ),
    );
  }
}

class DateTimeWidget extends StatefulWidget {
  const DateTimeWidget({super.key});

  @override
  State<DateTimeWidget> createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  @override
  Widget build(BuildContext context) {
    // final a = ApiProvider.of(context).Api;

    print("build datetime \n"); //${a.dateandtime}

    return Text('Tappp'); //a.dateandtime ??
  }
}

class api {
  String? dateandtime;
  Future<String> getdateandtime() {
    return Future.delayed(
            const Duration(seconds: 1), () => DateTime.now().toIso8601String())
        .then((value) {
      dateandtime = value;
      return value;
    });
  }
}

class ApiProvider extends InheritedWidget {
  api Api;
  final String uuid;
  final Widget child;
  ApiProvider({Key? key, required this.Api, required this.child})
      : uuid = const Uuid().v4(),
        super(child: child, key: key) {
    print("OKe $uuid \n");
  }

  @override
  bool updateShouldNotify(covariant ApiProvider oldWidget) {
    print("oke");
    return uuid != oldWidget.uuid;
  }

  static ApiProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ApiProvider>()!;
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizzo_order_app/cart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class Pizza {
  final String id;
  final String name;
  final String desc;
  final int defaultCrust;
  final bool isVeg;
  final List crusts;

  const Pizza({
    required this.id,
    required this.name,
    required this.desc,
    required this.defaultCrust,
    required this.isVeg,
    required this.crusts,
  });

  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      id: json['id'],
      name: json['name'],
      desc: json['description'],
      defaultCrust: json['defaultCrust'],
      isVeg: json['isVeg'],
      crusts: json['crusts'],
    );
  }
}

Future<Pizza> fetchPizzas() async {
  final response = await http.get(
      Uri.parse('https://625bbd9d50128c570206e502.mockapi.io/api/v1/pizza/1'));

  if (response.statusCode == 200) {
    return Pizza.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Pizza> futurePizza;
  late Map cart = {};

  @override
  void initState() {
    super.initState();
    futurePizza = fetchPizzas();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder(
        future: futurePizza,
        builder: (context, AsyncSnapshot<Pizza> snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        snapshot.data!.name.toString(),
                        style: const TextStyle(
                            fontSize: 26.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                    child: Column(
                      children: <Widget>[
                        ...snapshot.data!.crusts
                            .map((e) => menuItemtab(
                                "assets/images/mexicanPizza.png",
                                e,
                                snapshot.data!.desc.toString()))
                            .toList(),
                        // menuItemtab("assets/images/mexicanPizza.png",
                        //     snapshot.data!.name, snapshot.data!.desc)
                      ],
                    )),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
      floatingActionButton: cart.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CartScreen(cart, futurePizza)));
              },
              child: Icon(Icons.shopping_bag_outlined),
            ),
    );
  }

  showAlertDialog(
      BuildContext context, List pizzas, int defaultSize, String name) {
    // set up the button

    late List<bool> selected = [];
    for (var i = 0; i < pizzas.length; i++) {
      selected.add(false);
    }
    selected[defaultSize - 1] = true;
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Customize Pizza"),
      content: StatefulBuilder(
        builder: (context, setState) =>
            Column(mainAxisSize: MainAxisSize.min, children: [
          ...Iterable<int>.generate(pizzas.length).map((e) {
            return Row(
              children: [
                Checkbox(
                    value: selected[e],
                    onChanged: (value) {
                      for (var i = 0; i < pizzas.length; i++) {
                        setState(() {
                          selected[i] = false;
                        });
                      }
                      setState(() {
                        selected[e] = true;
                      });
                    }),
                Text(pizzas[e]['name'].toString()),
                Expanded(
                    child: Text(
                  '₹' + pizzas[e]['price'].toString(),
                  textAlign: TextAlign.end,
                ))
              ],
            );
          }).toList(),
        ]),
      ),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text("Add to Cart"),
          onPressed: () {
            // print(name);
            // print(pizzas[selected.indexOf(true)]);
            var id = selected.indexOf(true);
            if (cart.keys.contains(name)) {
              if (cart[name].keys.contains(id)) {
                setState(() {
                  cart[name][id] = cart[name][id] + 1;
                });
              } else {
                setState(() {
                  cart[name][id] = 1;
                });
              }
            } else {
              setState(() {
                cart[name] = {id: 1};
              });
            }
            // print(cart);
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget menuItemtab(String pizzaImage, Map details, String desc) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: SizedBox(
        height: 100.0,
        width: width - 40.0,
        child: Stack(
          children: [
            //let have the clok for the pizza items....
            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Container(
                padding: const EdgeInsets.only(left: 70.0, right: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white),
                height: 100.0,
                width: width - 90.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          details['name'],
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                            desc,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () {
                        showAlertDialog(context, details['sizes'],
                            details['defaultSize'], details['name']);
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                left: 0.0,
                child: Image(
                  image: AssetImage(pizzaImage),
                  height: 100.0,
                  width: 100.0,
                ))
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pizzo_order_app/main.dart';

class CartScreen extends StatefulWidget {
  final Map cart;
  final Future<Pizza> pizza;
  CartScreen(@required this.cart, @required this.pizza, {Key? key})
      : super(key: key);
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: widget.pizza,
            builder: (context, AsyncSnapshot<Pizza> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Text("Cart"),
                    // Text(
                    //   widget.cart.toString(),
                    // ),
                    ...widget.cart.keys.map((e) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                            children: widget.cart[e].keys.map<Widget>((id) {
                          return Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.cart[e][id].toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(width: 20),
                              const Text('x',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.toString(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  // Text(id.toString()),
                                  SizedBox(
                                    width: 150,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          snapshot
                                              .data!
                                              .crusts[returnIndex(
                                                      snapshot.data!.crusts, e)]
                                                  ['sizes'][id]['name']
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey),
                                        ),
                                        Text(
                                          '₹' +
                                              snapshot
                                                  .data!
                                                  .crusts[returnIndex(
                                                      snapshot.data!.crusts,
                                                      e)]['sizes'][id]['price']
                                                  .toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Text(
                                    '₹' +
                                        (snapshot.data!.crusts[returnIndex(
                                                    snapshot.data!.crusts,
                                                    e)]['sizes'][id]['price'] *
                                                widget.cart[e][id])
                                            .toString(),
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                            ],
                          );
                        }).toList()),
                      );
                    }).toList(),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            }),
      ),
    );
  }
}

int returnIndex(List crusts, String name) {
  int index = 0;
  for (var i = 0; i < crusts.length; i++) {
    if (crusts[i]['name'] == name) {
      index = i;
    }
  }
  return index;
}

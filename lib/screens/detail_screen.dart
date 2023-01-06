import 'package:cwallet/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

class DetailScreen extends StatefulWidget {
  final String id;
  final String image;
  final String name;
  final double unitPrice;
  final String code;
  final String description;

  const DetailScreen({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.unitPrice,
    required this.code,
    required this.description,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late double balance;
  late String userid;

  TextEditingController idController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController convertAmountController = TextEditingController();

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    idController.text = widget.id;
    SharedPreferences.getInstance().then((prefs) {
      balance = prefs.getDouble("balance")!;
      userid = prefs.getString("userid")!;
    });
  }

  @override
  void dispose() {
    super.dispose();
    idController.clear();
    amountController.clear();
    convertAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          buyCrypto();
        },
        label: const Text(" Buy "),
        icon: const Icon(Icons.shopping_basket),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(widget.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
          child: Form(
            key: _keyForm,
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    "assets/${widget.image}",
                    width: 200,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.name} [${widget.code}]",
                    textScaleFactor: 1.8,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "\$ ${widget.unitPrice}",
                    textScaleFactor: 1.1,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    // ignore: unnecessary_string_interpolations
                    "${widget.description}",
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: idController,
                    readOnly: true,
                    enabled: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              convertAmountController.text = (double.parse(
                                          amountController.text.toString()) *
                                      widget.unitPrice)
                                  .toString();
                            });
                          },
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Amount"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: TextFormField(
                          controller: convertAmountController,
                          enabled: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buyCrypto() {
    double amountToPurchase = double.parse(convertAmountController.text);

    if (balance >= amountToPurchase) {
      Map<String, dynamic> currenciesData = {
        "currencyId": widget.id,
        "quantity": amountToPurchase,
      };

      Map<String, String> headers = {
        "Content-Type": "application/json; charset=UTF-8"
      };

      http
          .post(Uri.http(Config.baseUrl, "/api/currencies/$userid"),
              headers: headers, body: json.encode(currenciesData))
          .then(
        (http.Response response) {
          if (response.statusCode == 200) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Dismiss"),
                    ),
                  ],
                  title: const Text("Congrats"),
                  content: Text(
                    "You just bought ${amountController.text} ${widget.name} [${widget.code}]",
                  ),
                );
              },
            );
          } else if (response.statusCode == 403) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK"),
                    ),
                  ],
                  title: const Text("Warnings"),
                  content: const Text(
                    "No Available Funds !",
                  ),
                );
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK"),
                    ),
                  ],
                  title: const Text("Information"),
                  content: const Text(
                    "An error has occurred, please try again later!",
                  ),
                );
              },
            );
          }
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
            title: const Text("Warnings"),
            content: const Text(
              "No Available Funds !",
            ),
          );
        },
      );
    }
  }
}

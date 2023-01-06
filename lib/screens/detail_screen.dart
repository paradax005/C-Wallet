import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  TextEditingController idController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController convertAmountController = TextEditingController();

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      idController.text = widget.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text(" Buy "),
        icon: const Icon(Icons.shopping_basket),
      ),
      appBar: AppBar(
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
}

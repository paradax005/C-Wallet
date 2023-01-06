import 'dart:convert';

import 'package:cwallet/models/cypto.dart';
import 'package:cwallet/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/config.dart';
import '../widgets/currency_card.dart';
import "package:http/http.dart" as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double balance = 10000;

  @override
  void initState() {
    super.initState();

    fetchCurrenciesData();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        balance = prefs.getDouble("balance") ?? 1000;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text("Crypto Wallet"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "BALANCE",
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.8,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "\$ ${balance.toString()}",
                  textScaleFactor: 1.2,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Popular coins"),
              ),
              FutureBuilder<List<Crypto>>(
                future: fetchCurrenciesData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    List<Crypto> currencyData = snapshot.data as List<Crypto>;
                    return ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: currencyData.length,
                      itemBuilder: (context, index) {
                        return CurrencyCard(
                          id: currencyData[index].id,
                          name: currencyData[index].name,
                          code: currencyData[index].code,
                          description: currencyData[index].description,
                          image: currencyData[index].image,
                          unitPrice: currencyData[index].unitPrice,
                        );
                      },
                    );
                  }
                  return const CircularProgressIndicator();
                },
              )
              // ListView(
              //   controller: _scrollController,
              //   scrollDirection: Axis.vertical,
              //   shrinkWrap: true,
              //   children: [

              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Crypto>> fetchCurrenciesData() async {
    var response = await http.get(Uri.http(Config.baseUrl, "/api/currencies"));
    return (json.decode(response.body) as List)
        .map((e) => Crypto.fromJson(e))
        .toList();
  }
}

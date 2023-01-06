import 'package:cwallet/screens/detail_screen.dart';
import 'package:flutter/material.dart';

class CurrencyCard extends StatelessWidget {
  final String id;
  final String image;
  final String name;
  final double unitPrice;
  final String code;
  final String description;

  const CurrencyCard({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.unitPrice,
    required this.code,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DetailScreen(
                id: id,
                image: image,
                name: name,
                unitPrice: unitPrice,
                code: code,
                description: description,
              );
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset(
                  "assets/$image",
                  width: 90,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      textScaleFactor: 1.5,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      code,
                      textScaleFactor: 0.9,
                    ),
                    Text(unitPrice.toString())
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

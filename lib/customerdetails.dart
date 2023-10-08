import "package:cloud_firestore/cloud_firestore.dart";
import "package:customer_payment_tracking/customer.dart";
import "package:flutter/material.dart";

class CustomerDetails extends StatefulWidget {
  static const String id = "customer_details";

  Customer customer;

  CustomerDetails({super.key, required this.customer});

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appbar")),
      body: Column(
        children: [
          const Image(
              image: NetworkImage(
                  "https://img.freepik.com/premium-vector/man-character_665280-46970.jpg?size=626&ext=jpg")),
          Text("Name $widget.customer.name"),
          const SizedBox(
            height: 10,
          ),
          const Text("Total"),
          const SizedBox(
            height: 10,
          ),
          const Text("Received"),
          const SizedBox(
            height: 10,
          ),
          const Text("Remaining"),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(onPressed: () {}, child: const Text("Add New Bill"))
        ],
      ),
    );
  }
}

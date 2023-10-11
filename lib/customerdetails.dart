import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_payment_tracking/customer.dart';
import 'package:flutter/material.dart';

class CustomerDetails extends StatefulWidget {
  final Customer customer;

  CustomerDetails({Key? key, required this.customer}) : super(key: key);

  @override
  _CustomerDetailsState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey ScaffoldState();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _totalBillController = TextEditingController();
  final TextEditingController _receivedAmountController =
      TextEditingController();

  Future<void> _submitPayment() async {
    double totalBill = double.tryParse(_totalBillController.text) ?? 0.0;
    double receivedAmount =
        double.tryParse(_receivedAmountController.text) ?? 0.0;

    try {
      bool? isConfirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('New Bill'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _totalBillController,
                  decoration: const InputDecoration(
                    labelText: "Total amount",
                    isDense: true,
                  ),
                ),
                TextField(
                  controller: _receivedAmountController,
                  decoration: const InputDecoration(
                    labelText: "Received",
                    isDense: true,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );

      if (isConfirmed ?? false) {
        // Fetch the customer's existing data from Firestore
        DocumentReference customerRef =
            _firestore.collection('customers').doc(widget.customer.name);
        DocumentSnapshot customerSnapshot = await customerRef.get();

        if (customerSnapshot.exists) {
          Map<String, dynamic> existingData =
              customerSnapshot.data() as Map<String, dynamic>;

          // Update existing data with new bill details
          existingData['total'] += totalBill;
          existingData['received'] += receivedAmount;
          existingData['remaining'] =
              existingData['total'] - existingData['received'];

          // Update Firestore with the modified data
          await customerRef.update(existingData);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Bill added successfully.'),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Customer not found in Firestore.'),
          ));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error updating payment: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      appBar: AppBar(title: Text(widget.customer.name)),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Image(
                image: NetworkImage(
                    "https://img.freepik.com/premium-vector/man-character_665280-46970.jpg?size=626&ext=jpg"),
                width: 250,
                height: 250,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Name : ",
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  width: 50,
                ),
                Text(widget.customer.name,
                    style: const TextStyle(fontSize: 25)),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Total : ",
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  width: 65,
                ),
                Text("${widget.customer.total}",
                    style: const TextStyle(fontSize: 25)),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Received : ",
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  width: 13,
                ),
                Text("${widget.customer.received}",
                    style: const TextStyle(fontSize: 25)),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Remaining : ",
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("${widget.customer.remaining}",
                    style: const TextStyle(fontSize: 25)),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Builder(builder: (BuildContext innerContext) {
            return ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              onPressed: () {
                _submitPayment();
              },
              child: const Text('Add new Bill'),
            );
          })
        ],
      ),
    );
  }
}

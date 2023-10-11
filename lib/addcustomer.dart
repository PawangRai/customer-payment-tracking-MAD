import 'package:flutter/material.dart';
import "firebase_options.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  int _total = 0;
  int _received = 0;

  var customers =
      FirebaseFirestore.instance.collection("customers");

  addCustomer() {
    customers.doc(_name).set({
      "name": _name,
      "total": _total,
      "received": _received,
      "remaining": _total - _received,
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Customer Added")));
  }

  void _submitForm() {
    final formState = _formKey.currentState;
    if (formState != null) {
      if (formState.validate()) {
        formState.save();
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Add a Customer",
          style: TextStyle(fontSize: 26),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Enter Customer Name'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter customer name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value ?? "";
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Total Bill'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter total bill amount';
                    }
                    if (int.tryParse(value!) == null) {
                      return 'Invalid integer format';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _total = int.parse(value!);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Amount Received'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter amount received';
                    }
                    if (int.tryParse(value!) == null) {
                      return 'Invalid integer format';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _received = int.parse(value!);
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  height: 40,
                  width: 90,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue),
                  child: ElevatedButton(
                    onPressed: () {
                      _submitForm();
                      addCustomer();
                    },
                    child: const Text('Submit'),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

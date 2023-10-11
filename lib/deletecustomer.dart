import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_payment_tracking/customer.dart';
import 'package:flutter/material.dart';

class DeleteCustomer extends StatefulWidget {
  const DeleteCustomer({super.key});

  @override
  State<DeleteCustomer> createState() => DeleteCustomerState();
}

class DeleteCustomerState extends State<DeleteCustomer> {
  final TextEditingController _searchController = TextEditingController();
  final CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  final fireStore =
      FirebaseFirestore.instance.collection('customers').snapshots();

  String staticText = "Remaining";
  String search = '';

  Future<bool?> showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text(
              'Are you sure you want to delete this customer?'), // Your confirmation message
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // User clicked Cancel
              },
            ),
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop(true); // User clicked Yes
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Delete Customer"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search Customer to Delete',
                prefixIcon: Icon(Icons.search),
                isDense: true,
                contentPadding: EdgeInsets.all(1),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
              onChanged: (String? value) {
                setState(() {
                  search = value.toString();
                });
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) return const Text("Some error occurred");

                return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          Customer customer = Customer(
                            name: snapshot.data!.docs[index]['name'].toString(),
                            total: snapshot.data!.docs[index]['total'],
                            received:
                                snapshot.data!.docs[index]['received'],
                            remaining:
                                snapshot.data!.docs[index]['remaining'],
                          );
                          late String position =
                              snapshot.data!.docs[index]['name'].toString();
                          if (_searchController.text.isEmpty) {
                            return ListTile(
                              leading: const Image(
                                  image: NetworkImage(
                                      "https://img.freepik.com/premium-vector/man-character_665280-46970.jpg?size=626&ext=jpg")),
                              title: Text(snapshot.data!.docs[index]['name']
                                  .toString()),
                              subtitle: Text(
                                  "$staticText ${snapshot.data!.docs[index]['remaining']}"),
                              onTap: () async {
                                bool? isConfirmed =
                                    await showConfirmationDialog(context);

                                if (isConfirmed == null) {
                                  return;
                                }
                                if (isConfirmed) {
                                  customers
                                      .doc(snapshot.data!.docs[index].id)
                                      .delete();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Customer Deleted")));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Customer Not Deleted")));
                                }
                              },
                            );
                          } else if (position
                              .toLowerCase()
                              .contains(_searchController.text.toString())) {
                            return ListTile(
                              leading: const Image(
                                  image: NetworkImage(
                                      "https://img.freepik.com/premium-vector/man-character_665280-46970.jpg?size=626&ext=jpg")),
                              title: Text(snapshot.data!.docs[index]['name']
                                  .toString()),
                              subtitle: Text(
                                  "$staticText ${snapshot.data!.docs[index]['remaining']}"),
                              onTap: () async {
                                bool? isConfirmed =
                                    await showConfirmationDialog(context);

                                if (isConfirmed == null) {
                                  return;
                                }
                                if (isConfirmed) {
                                  customers
                                      .doc(snapshot.data!.docs[index].id)
                                      .delete();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Customer Deleted")));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Customer Not Deleted")));
                                }
                              },
                            );
                          } else {
                            return Container();
                          }
                        }));
              }),
        ],
      ),
    );
  }
}

import "package:cloud_firestore/cloud_firestore.dart";
import "package:customer_payment_tracking/customer.dart";
import "package:customer_payment_tracking/customerdetails.dart";
import "package:customer_payment_tracking/route_names.dart";
import "package:flutter/material.dart";
import "package:customer_payment_tracking/testscreen.dart";

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();

  final CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  final fireStore =
      FirebaseFirestore.instance.collection('customers').snapshots();

  String staticText = "Remaining";
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Customers",
            style: TextStyle(fontSize: 26),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.person_add_alt_1),
                iconSize: 30,
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.addUser);
                }),
            IconButton(
                icon: const Icon(Icons.delete),
                iconSize: 30,
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.deleteUser);
                }),
          ]),
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
                labelText: 'Search Customers',
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
                            total: snapshot.data!.docs[index]['total'] as int,
                            received: snapshot.data!.docs[index]['received'] as int,
                            remaining: snapshot.data!.docs[index]['remaining'] as int,
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
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CustomerDetails(
                                              customer: customer)));
                                });
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
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CustomerDetails(
                                            customer: customer)));
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

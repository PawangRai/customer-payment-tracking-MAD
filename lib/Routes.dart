import "package:customer_payment_tracking/addcustomer.dart";
import "package:customer_payment_tracking/customer.dart";
import "package:customer_payment_tracking/customerdetails.dart";
import "package:customer_payment_tracking/homepage.dart";
import "package:flutter/material.dart";
import "route_names.dart";

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.homeScreen:
        return MaterialPageRoute(builder: (context) => const MyHomePage());

      case RouteName.addUser:
        return MaterialPageRoute(builder: (context) => const AddCustomer());

      case RouteName.editUser:
        return MaterialPageRoute(builder: (context) => const MyHomePage());

      case RouteName.customerDetails:
        return MaterialPageRoute(
            builder: (context) => CustomerDetails(
                  customer: Customer(),
                ));

      default:
        return MaterialPageRoute(builder: ((context) => const MyHomePage()));
    }
  }
}

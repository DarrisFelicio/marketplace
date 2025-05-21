import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Total Price: \$${cartProvider.totalPrice.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed:
                cartProvider.items.isEmpty
                    ? null
                    : () {
                      Navigator.pushNamed(context, '/checkout');
                    },
            child: const Text('Proceed to Checkout'),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (ctx, i) {
                final item = cartProvider.items.values.toList()[i];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text("\$${item.price} x ${item.quantity}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

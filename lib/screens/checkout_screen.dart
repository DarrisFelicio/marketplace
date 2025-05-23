import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  void _showOrderConfirmation(BuildContext context) {
    final cart = Provider.of<CartProvider>(
      context,
      listen: false,
    ); // Get CartProvider
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Order Confirmed'),
            content: const Text('Thank you for your purchase!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  cart.clearCart(); // Clear the cart
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                final item = cart.items.values.toList()[i];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text("\$${item.price} x ${item.quantity}"),
                  trailing: Text(
                    "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              onPressed:
                  cart.items.isEmpty
                      ? null
                      : () => _showOrderConfirmation(context),
              child: const Text('Place Order'),
            ),
          ),
        ],
      ),
    );
  }
}

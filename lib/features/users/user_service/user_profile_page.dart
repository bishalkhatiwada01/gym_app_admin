import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymappadmin/features/payments/payment_model.dart';
import 'package:gymappadmin/features/payments/payment_service.dart';
import 'package:gymappadmin/features/users/user_service/user_service.dart';
import 'package:intl/intl.dart';

class UserProfilePage extends ConsumerWidget {
  final User user;

  const UserProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentHistoryAsyncValue = ref.watch(paymentHistoryProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(user.name),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue.shade700, Colors.blue.shade900],
                  ),
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style:
                          TextStyle(fontSize: 48, color: Colors.blue.shade900),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(context),
                  const SizedBox(height: 20),
                  Text(
                    'Payment History',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  paymentHistoryAsyncValue.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Text('Error loading payments: $error'),
                    ),
                    data: (paymentHistory) {
                      final userPayments = paymentHistory
                          .where(
                              (payment) => payment['payment'].userId == user.id)
                          .toList();
                      return _buildPaymentHistoryList(context, userPayments);
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildDeleteUserButton(context, ref),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Delete user button with confirmation dialog
  Widget _buildDeleteUserButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
      ),
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete User'),
              content: const Text('Are you sure you want to delete this user?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    ref.refresh(userListProvider);
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );

        if (confirm == true) {
          // Trigger user deletion using the deleteUserProvider
          final result = ref.read(deleteUserProvider(user.id));
          result.when(
            error: (error, stack) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error deleting user: $error')),
              );
            },
            loading: () => const CircularProgressIndicator(),
            data: (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User successfully deleted')),
              );
              Navigator.of(context).pop(); // Navigate back after deleting
            },
          );
        }
      },
      child: const Text('Delete User'),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(context, Icons.email, 'Email', user.email),
            const Divider(),
            _buildInfoRow(context, Icons.fingerprint, 'User ID', user.id),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade700),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistoryList(
      BuildContext context, List<Map<String, dynamic>> userPayments) {
    if (userPayments.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('No payment history available.')),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: userPayments.length,
      itemBuilder: (context, index) {
        final payment = userPayments[index]['payment'] as Payment;
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.attach_money, color: Colors.white),
            ),
            title: Text('\$${payment.amount.toStringAsFixed(2)}'),
            subtitle: Text(_formatDate(payment.paymentDate)),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, y HH:mm').format(date);
  }
}

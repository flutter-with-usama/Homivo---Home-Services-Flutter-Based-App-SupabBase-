import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/booking_record_model.dart';
import '../widgets/booking_details/booking_details_header.dart';
import '../widgets/booking_details/booking_details_row.dart';
import '../widgets/booking_details/booking_status_card.dart';

class ClientBookingDetailsScreen extends StatelessWidget {
  final BookingRecordModel booking;

  const ClientBookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Booking Details'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookingDetailsHeader(booking: booking),
            const SizedBox(height: 16),
            BookingStatusCard(status: booking.status),
            const SizedBox(height: 16),
            _DetailsCard(
              children: [
                BookingDetailsRow(
                  icon: Icons.calendar_month_rounded,
                  label: 'Date',
                  value: booking.bookingDate,
                ),
                const _Divider(),
                BookingDetailsRow(
                  icon: Icons.access_time_rounded,
                  label: 'Time',
                  value: booking.bookingTime,
                ),
                const _Divider(),
                BookingDetailsRow(
                  icon: Icons.location_on_outlined,
                  label: 'Service Address',
                  value: booking.clientAddress.isEmpty
                      ? 'Address not provided'
                      : booking.clientAddress,
                ),
                const _Divider(),
                BookingDetailsRow(
                  icon: Icons.payments_outlined,
                  label: 'Agreed Quote',
                  value: booking.amount > 0
                      ? '\$${booking.amount.toStringAsFixed(2)}'
                      : 'Waiting for provider quote',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _DetailsCard(
              children: [
                BookingDetailsRow(
                  icon: Icons.description_outlined,
                  label: 'Additional Notes',
                  value: booking.notes.trim().isEmpty
                      ? 'No additional notes'
                      : booking.notes.trim(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final List<Widget> children;

  const _DetailsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Divider(height: 1, color: Color(0xFFF0F0F0)),
    );
  }
}

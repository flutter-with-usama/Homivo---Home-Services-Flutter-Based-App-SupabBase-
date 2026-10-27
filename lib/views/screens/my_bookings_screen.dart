import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/booking_record_model.dart';
import '../../data/repositories/booking_repository.dart';
import 'client_booking_details_screen.dart';

/// My Bookings tab — shows past and upcoming bookings.
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  final _repository = BookingRepository();
  StreamSubscription<List<BookingRecordModel>>? _subscription;
  List<_BookingData> _bookings = const [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _subscription = _repository.watchCurrentClientBookings().listen(
      (bookings) {
        if (!mounted) return;
        setState(() {
          _bookings = bookings.map(_BookingData.fromRecord).toList();
          _isLoading = false;
        });
      },
      onError: (_) {
        if (mounted) setState(() => _isLoading = false);
      },
    );
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  List<_BookingData> get _upcoming => _bookings
      .where(
        (b) =>
            b.status != _BookingStatus.completed &&
            b.status != _BookingStatus.cancelled,
      )
      .toList();

  List<_BookingData> get _completed =>
      _bookings.where((b) => b.status == _BookingStatus.completed).toList();

  List<_BookingData> get _cancelled =>
      _bookings.where((b) => b.status == _BookingStatus.cancelled).toList();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      appBar: _BookingsAppBar(tabCtrl: _tabCtrl),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabCtrl,
              children: [
                _BookingsList(
                  bookings: _upcoming,
                  emptyMessage: 'No pending bookings',
                ),
                _BookingsList(
                  bookings: _completed,
                  emptyMessage: 'No completed bookings',
                ),
                _BookingsList(
                  bookings: _cancelled,
                  emptyMessage: 'No cancelled bookings',
                ),
              ],
            ),
    );
  }
}

// ── App bar with tab bar ──────────────────────────────────────────────────────
class _BookingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabCtrl;
  const _BookingsAppBar({required this.tabCtrl});

  @override
  Size get preferredSize => const Size.fromHeight(110);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: const Text(
        'My Bookings',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A1A2E),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Column(
          children: [
            Container(height: 1, color: const Color(0xFFF0F0F0)),
            TabBar(
              controller: tabCtrl,
              labelColor: AppTheme.primary,
              unselectedLabelColor: AppTheme.textGrey,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              indicatorColor: AppTheme.primary,
              indicatorWeight: 2.5,
              tabs: const [
                Tab(text: 'Pending'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bookings list ─────────────────────────────────────────────────────────────
class _BookingsList extends StatelessWidget {
  final List<_BookingData> bookings;
  final String emptyMessage;

  const _BookingsList({required this.bookings, required this.emptyMessage});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 56,
              color: AppTheme.primaryLight,
            ),
            const SizedBox(height: 14),
            Text(
              emptyMessage,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: bookings.length,
      itemBuilder: (_, i) => _BookingCard(
        booking: bookings[i],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ClientBookingDetailsScreen(booking: bookings[i].record),
          ),
        ),
      ),
    );
  }
}

// ── Booking card ──────────────────────────────────────────────────────────────
class _BookingCard extends StatelessWidget {
  final _BookingData booking;
  final VoidCallback onTap;

  const _BookingCard({required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: booking.color.withValues(alpha: 0.10),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Colour top bar
              Container(height: 4, color: booking.color),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Provider row
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: booking.color.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              booking.initials,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: booking.color,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.provider,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                booking.service,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: booking.color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Price
                        Text(
                          booking.price,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Date + status row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 13,
                              color: AppTheme.textGrey,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              booking.date,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textGrey,
                              ),
                            ),
                          ],
                        ),
                        _StatusChip(status: booking.status),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Status chip ───────────────────────────────────────────────────────────────
enum _BookingStatus { confirmed, pending, completed, cancelled }

class _StatusChip extends StatelessWidget {
  final _BookingStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color, bg) = switch (status) {
      _BookingStatus.confirmed => (
        'Confirmed',
        AppTheme.primary,
        AppTheme.primaryLight,
      ),
      _BookingStatus.pending => (
        'Pending',
        const Color(0xFFF59E0B),
        const Color(0xFFFEF3C7),
      ),
      _BookingStatus.completed => (
        'Completed',
        const Color(0xFF00B4D8),
        const Color(0xFFCFF4FC),
      ),
      _BookingStatus.cancelled => (
        'Cancelled',
        const Color(0xFFEF4444),
        const Color(0xFFFEE2E2),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ── Data class ────────────────────────────────────────────────────────────────
class _BookingData {
  final String id;
  final String service;
  final String provider;
  final String initials;
  final String date;
  final String price;
  final _BookingStatus status;
  final Color color;
  final BookingRecordModel record;

  const _BookingData({
    required this.id,
    required this.service,
    required this.provider,
    required this.initials,
    required this.date,
    required this.price,
    required this.status,
    required this.color,
    required this.record,
  });

  factory _BookingData.fromRecord(BookingRecordModel booking) {
    return _BookingData(
      id: booking.id,
      service: booking.serviceName,
      provider: booking.providerName,
      initials: _initials(booking.providerName),
      date: '${booking.bookingDate}, ${booking.bookingTime}',
      price: booking.amount > 0 ? '\$${booking.amount.toStringAsFixed(0)}' : '',
      status: switch (booking.status) {
        'accepted' => _BookingStatus.confirmed,
        'completed' => _BookingStatus.completed,
        'rejected' => _BookingStatus.cancelled,
        _ => _BookingStatus.pending,
      },
      color: AppTheme.primary,
      record: booking,
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'P';
  }
}

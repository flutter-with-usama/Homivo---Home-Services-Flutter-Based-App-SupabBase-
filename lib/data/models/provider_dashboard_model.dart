import 'package:flutter/material.dart';

/// Status of a single job request.
enum JobStatus { pending, accepted, rejected, completed }

/// A single job request assigned to the service provider.
class JobModel {
  final String id;
  final String clientId;
  final String clientName;
  final String clientAvatar; // initials fallback
  final String serviceType;
  final IconData serviceIcon;
  final Color serviceColor;
  final String address;
  final String scheduledDate;
  final String scheduledTime;
  final double amount;
  final DateTime? completedAt;
  final JobStatus status;

  const JobModel({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.clientAvatar,
    required this.serviceType,
    required this.serviceIcon,
    required this.serviceColor,
    required this.address,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.amount,
    this.completedAt,
    this.status = JobStatus.pending,
  });

  JobModel copyWith({JobStatus? status}) => JobModel(
    id: id,
    clientId: clientId,
    clientName: clientName,
    clientAvatar: clientAvatar,
    serviceType: serviceType,
    serviceIcon: serviceIcon,
    serviceColor: serviceColor,
    address: address,
    scheduledDate: scheduledDate,
    scheduledTime: scheduledTime,
    amount: amount,
    completedAt: completedAt,
    status: status ?? this.status,
  );
}

/// Earnings summary data.
class EarningsSummaryModel {
  final double totalEarnings;
  final double thisWeek;
  final double thisMonth;
  final int completedJobs;
  final int activeJobs;
  final int pendingJobs;

  const EarningsSummaryModel({
    required this.totalEarnings,
    required this.thisWeek,
    required this.thisMonth,
    required this.completedJobs,
    required this.activeJobs,
    required this.pendingJobs,
  });
}

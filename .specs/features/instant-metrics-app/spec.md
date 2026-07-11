# INSTANT Metrics - App (User Interaction Tracking)

## Problem
The app tracks INSTANT user interactions via Firebase Analytics, but these events are:
1. Not easily queryable in real time during the test
2. Not aggregated into INSTANT-specific KPIs (next step CTR, info card CTR, etc.)
3. Missing `user_id` in some events (user_id is only in params, not the top-level field)

## Goal
Complement Firebase Analytics with direct Firestore writes to `instantMetrics` collection, capturing user interaction events in real time.

## Requirements

### R1: New Firestore metrics helper
Create a fire-and-forget method to write events to `instantMetrics` collection:

```dart
Future<void> _writeInstantMetric({
  required String event,
  required String userId,
  required String sessionId,
  Map<String, dynamic>? extra,
}) async {
  await FirebaseFirestore.instance.collection('instantMetrics').add({
    'event': event,
    'userId': userId,
    'sessionId': sessionId,
    ...?extra,
    'createdAt': FieldValue.serverTimestamp(),
  });
}
```

### R2: Events to capture at the exact existing call sites

| Current method | Event name | Extra fields |
|---|---|---|
| `MetricsTrackingService.trackNextStepShown` | `next_step_shown` | `{ nextStepId }` |
| `MetricsTrackingService.trackNextStepClicked` | `next_step_clicked` | `{ targetRoute }` |
| `MetricsTrackingService.trackInfoCardShown` | `info_card_shown` | `{ infoType, source }` |
| `MetricsTrackingService.trackInfoCardClicked` | `info_card_clicked` | `{ infoType, targetRoute }` |
| `MetricsTrackingService.trackInstantAdaptationApplied` | `adaptation_applied` | `{ components, componentCount, usedFallback }` |
| `MetricsTrackingService.trackShortcutClicked` | `shortcut_clicked` | `{ route }` |
| `MetricsTrackingService.trackSessionStart` | `session_start` | `{ mode }` |

### R3: Non-blocking
Firestore writes must be fire-and-forget. Errors must be silently caught (print only).

### R4: Cleanup deduplication logic
The deduplication in `InstantAdaptiveHomeMetrics` (`_shownComponents` set) already prevents duplicate "shown" events per session. This logic must be preserved.

### R5: File to modify
- `lib/core/services/metrics_tracking_service.dart` — add Firestore helper + calls alongside existing Firebase Analytics calls

## Dependencies
- `cloud_firestore` package (already in pubspec.yaml)
- `firebase_auth` for user identification

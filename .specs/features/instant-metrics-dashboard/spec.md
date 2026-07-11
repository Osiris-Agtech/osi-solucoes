# INSTANT Metrics - Dashboard

## Problem
The current metrics dashboard (`metrics_dashboard_page.dart`) shows only legacy GRADUAL metrics (acceptance rate, pass-through rate, time-to-task) from the old API. There is no visibility into INSTANT-specific KPIs like next step CTR, cache hit rate, or fallback rate.

## Goal
Add a new section to the existing metrics dashboard that reads directly from Firestore `instantMetrics` collection and displays real-time INSTANT KPIs.

## Requirements

### R1: New INSTANT metrics section
Add a new section below the existing "Visão Geral" section titled "🤖 Métricas INSTANT (tempo real)".

### R2: KPI cards to display

| KPI | Calculation |
|---|---|
| **Next Step CTR** | `next_step_clicked` / `next_step_shown` |
| **Info Card CTR** | `info_card_clicked` / `info_card_shown` |
| **Shortcut CTR** | `shortcut_clicked` / `shortcuts_shown` (INSTANT) |
| **Cache Hit Rate** | events with event = `cache_hit` / (hits + all non-cache events) |
| **Fallback Rate** | events with fallbackUsed = true / total adaptation events |
| **Gemini Calls** | count of `gemini_success` events |
| **Total Sessions** | count of `session_start` events |

### R3: Per-user timeline
Add an expandable section per user showing chronological events from `instantMetrics`, filtered by `sessionId` and sorted by `createdAt`. Each event shows:
- Icon by event type (green check for success, orange for click, etc.)
- Event name and key fields
- Timestamp

### R4: Data source
Read directly from Firestore `instantMetrics` collection. Do NOT use the old `MetricsService` HTTP API.

```dart
final snapshot = await FirebaseFirestore.instance
  .collection('instantMetrics')
  .orderBy('createdAt', descending: true)
  .limit(500)
  .get();
```

### R5: Real-time refresh
Add a pull-to-refresh or refresh button. No auto-refresh or streaming needed for this test.

### R6: Files to modify
- `lib/features/presenter/views/adaptive_admin/metrics_dashboard_page.dart` — add INSTANT section
- (minor) `lib/core/services/metrics_service.dart` — no changes needed; new section reads directly from Firestore

## Dependencies
- `cloud_firestore` package (already in pubspec.yaml)
- `instantMetrics` collection must have data (from API and App workstreams)

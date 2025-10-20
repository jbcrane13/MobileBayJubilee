# Cloud Functions Architecture Documentation

**Version**: 1.0
**Last Updated**: 2025-10-20
**Status**: Architecture Design (Implementation Pending)

---

## Overview

This document defines the architecture for Firebase Cloud Functions that will power the Mobile Bay Jubilee app's backend automation, notifications, and data processing.

## Architecture Principles

1. **Event-Driven**: Functions triggered by Firestore changes, scheduled jobs, and HTTPS requests
2. **Scalable**: Automatically scale based on load
3. **Serverless**: No server management required
4. **Cost-Effective**: Pay only for execution time
5. **Reliable**: Built-in retry logic and error handling

---

## Function Categories

### 1. Data Ingestion & Processing

#### `fetchEnvironmentalData` (Scheduled - Every 30 minutes)
**Purpose**: Fetch latest environmental data from NOAA and ARCOS APIs

**Trigger**: Cloud Scheduler (cron: `*/30 * * * *`)

**Process**:
1. Fetch tide data from NOAA Tides & Currents API
2. Fetch weather data from NOAA Weather Service API
3. Fetch water quality from ARCOS API
4. Calculate Condition Score using ConditionScoreService logic
5. Store in Firestore `conditions` collection
6. Trigger alert evaluation

**Dependencies**:
- NOAA Tides API: https://api.tidesandcurrents.noaa.gov/api/prod/
- NOAA Weather API: https://api.weather.gov/
- ARCOS API: https://arcos.disl.org/api/

**Error Handling**:
- Retry 3 times with exponential backoff
- Log failures to Cloud Logging
- Send admin alert if all retries fail

**Cost Estimate**: ~$5/month (1,440 invocations/month)

---

#### `calculateConditionScore` (Firestore Trigger)
**Purpose**: Recalculate condition score when new environmental data arrives

**Trigger**: `onCreate` on `/conditions/{conditionId}`

**Process**:
1. Extract environmental data from document
2. Apply scoring algorithm:
   - Seasonal score (0-20 pts)
   - Time window score (0-20 pts)
   - Wind score (0-20 pts)
   - Tide score (0-15 pts)
   - Water quality score (0-15 pts)
   - Weather pattern score (0-10 pts)
3. Update document with calculated score
4. Trigger alert level evaluation

**Implementation Reference**: `MobileBayJubilee/Services/ConditionScoreService.swift`

**Cost Estimate**: ~$2/month (1,440 invocations/month)

---

### 2. Alert System

#### `evaluateAlertLevel` (Firestore Trigger)
**Purpose**: Evaluate current alert level based on reports and conditions

**Trigger**:
- `onCreate` on `/reports/{reportId}`
- `onUpdate` on `/conditions/{conditionId}`

**Process**:
1. Fetch recent reports (last 6 hours)
2. Apply AlertLevelManager logic:
   - **QUIET → WATCH**: 1 verified watcher OR 3 regular users
   - **WATCH → CONFIRMED**: 2 verified watchers OR 5 total users
   - **De-escalation**: Based on "All Clear" reports
3. Update `alertLevel` field in Firestore
4. Trigger notifications if level changed

**Implementation Reference**: `MobileBayJubilee/Services/AlertLevelManager.swift`

**Geographic Clustering**:
- Group reports within 2-mile radius
- Only count geographically clustered reports

**Cost Estimate**: ~$3/month (~1,500 invocations/month)

---

#### `sendPushNotifications` (Firestore Trigger)
**Purpose**: Send push notifications when alert level changes

**Trigger**: `onUpdate` on `/alertLevel/current`

**Process**:
1. Detect alert level change
2. Query users with `notificationsEnabled: true`
3. Filter by `notificationThreshold` (user preference)
4. Build notification payload:
   ```json
   {
     "title": "Jubilee Alert: WATCH Level",
     "body": "Conditions favorable for jubilee event. 3 reports in your area.",
     "data": {
       "alertLevel": "WATCH",
       "conditionScore": 75,
       "reportCount": 3,
       "deepLink": "mobileBayJubilee://dashboard"
     }
   }
   ```
5. Send via Firebase Cloud Messaging (FCM)
6. Log delivery status

**Notification Types**:
- **WATCH**: "Conditions improving for jubilee"
- **CONFIRMED**: "Jubilee event confirmed! [Location]"
- **Custom Score**: User-defined threshold reached

**Cost Estimate**: ~$5/month (batch sends, ~500 notifications/month)

---

### 3. User Management

#### `onUserCreate` (Auth Trigger)
**Purpose**: Initialize new user document in Firestore

**Trigger**: `onCreate` on Firebase Auth user

**Process**:
1. Extract user info (uid, email, displayName)
2. Create Firestore document at `/users/{uid}`:
   ```json
   {
     "displayName": "User Name",
     "email": "user@example.com",
     "profilePhotoURL": null,
     "reputation": 50,
     "isVerifiedWatcher": false,
     "favoriteLocations": [],
     "notificationsEnabled": true,
     "notificationThreshold": 70,
     "createdAt": "2025-10-20T12:00:00Z",
     "lastLoginAt": "2025-10-20T12:00:00Z"
   }
   ```
3. Send welcome notification

**Cost Estimate**: ~$1/month (~50 new users/month)

---

#### `updateUserReputation` (Firestore Trigger)
**Purpose**: Update user reputation based on report verifications

**Trigger**:
- `onCreate` on `/reports/{reportId}/verifications/{verificationId}`
- `onUpdate` on `/reports/{reportId}`

**Process**:
1. Count total verifications for report
2. Apply ReputationManager rules:
   - **+2 pts**: First verification
   - **+2 pts**: Second verification
   - **+5 pts**: Third verification
   - **-3 pts**: Three or more disputes
   - **-10 pts**: Moderator flag
3. Cap reputation between 0-100
4. Update `isVerifiedWatcher` if reputation ≥ 70
5. Update user document

**Implementation Reference**: `MobileBayJubilee/Services/ReputationManager.swift`

**Cost Estimate**: ~$2/month (~1,000 verifications/month)

---

### 4. Data Cleanup & Maintenance

#### `archiveOldReports` (Scheduled - Daily at 3 AM)
**Purpose**: Archive reports older than 7 days

**Trigger**: Cloud Scheduler (cron: `0 3 * * *`)

**Process**:
1. Query reports with `reportedAt < 7 days ago`
2. Move to `/archivedReports/{reportId}` collection
3. Delete from `/reports/` collection
4. Update storage metrics

**Cost Estimate**: ~$1/month (30 invocations/month)

---

#### `cleanupOldConditions` (Scheduled - Daily at 4 AM)
**Purpose**: Remove condition data older than 30 days

**Trigger**: Cloud Scheduler (cron: `0 4 * * *`)

**Process**:
1. Query conditions with `fetchedAt < 30 days ago`
2. Delete documents (keep only summary stats)
3. Update storage metrics

**Cost Estimate**: ~$1/month (30 invocations/month)

---

### 5. Analytics & Reporting

#### `generateDailyStats` (Scheduled - Daily at midnight)
**Purpose**: Generate daily statistics for admin dashboard

**Trigger**: Cloud Scheduler (cron: `0 0 * * *`)

**Process**:
1. Count total reports (by type)
2. Calculate average condition score
3. Count active users
4. Track alert level changes
5. Store in `/analytics/daily/{date}` collection

**Cost Estimate**: ~$1/month (30 invocations/month)

---

## Function Deployment Structure

```
functions/
├── src/
│   ├── index.ts                    # Main exports
│   ├── dataIngestion/
│   │   ├── fetchEnvironmentalData.ts
│   │   └── calculateConditionScore.ts
│   ├── alerts/
│   │   ├── evaluateAlertLevel.ts
│   │   └── sendPushNotifications.ts
│   ├── users/
│   │   ├── onUserCreate.ts
│   │   └── updateUserReputation.ts
│   ├── maintenance/
│   │   ├── archiveOldReports.ts
│   │   └── cleanupOldConditions.ts
│   ├── analytics/
│   │   └── generateDailyStats.ts
│   ├── utils/
│   │   ├── scoring.ts              # Port from ConditionScoreService.swift
│   │   ├── alerts.ts               # Port from AlertLevelManager.swift
│   │   └── reputation.ts           # Port from ReputationManager.swift
│   └── types/
│       ├── conditions.ts
│       ├── reports.ts
│       └── users.ts
├── package.json
├── tsconfig.json
└── .env.example
```

---

## Environment Configuration

### Required Environment Variables

```bash
# Firebase Project
FIREBASE_PROJECT_ID=mobile-bay-jubilee

# NOAA APIs
NOAA_TIDES_API_URL=https://api.tidesandcurrents.noaa.gov/api/prod/
NOAA_WEATHER_API_URL=https://api.weather.gov/
NOAA_STATION_ID=8737048  # Mobile State Docks

# ARCOS API
ARCOS_API_URL=https://arcos.disl.org/api/
ARCOS_API_KEY=<obtain-from-dauphin-island-sea-lab>

# OpenWeather (Backup)
OPENWEATHER_API_KEY=<your-key>

# FCM (Firebase Cloud Messaging)
FCM_SERVER_KEY=<from-firebase-console>

# Admin
ADMIN_EMAIL=admin@mobileBayjubilee.com
```

---

## Security Rules

### Function Authentication

```typescript
// Only admin users can manually trigger functions
export const adminOnly = (request: https.Request) => {
  const auth = request.auth;
  if (!auth || !auth.token.admin) {
    throw new https.HttpsError('permission-denied', 'Admin access required');
  }
};

// Rate limiting for public functions
export const rateLimited = (request: https.Request) => {
  // Implement rate limiting logic
  // Max 100 requests per user per hour
};
```

### Firestore Security Rules Integration

```javascript
// Cloud Functions have full admin access
// But client-side rules still apply for direct access
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow Cloud Functions to write anywhere
    // (Functions use Admin SDK)

    // Client access controlled by existing security rules
    match /reports/{reportId} {
      allow read: if true;  // Public read
      allow create: if request.auth != null;  // Authenticated write
    }
  }
}
```

---

## Error Handling Strategy

### Retry Logic

```typescript
const MAX_RETRIES = 3;
const BACKOFF_BASE = 1000; // 1 second

async function executeWithRetry<T>(
  fn: () => Promise<T>,
  retries = MAX_RETRIES
): Promise<T> {
  try {
    return await fn();
  } catch (error) {
    if (retries === 0) throw error;

    const delay = BACKOFF_BASE * Math.pow(2, MAX_RETRIES - retries);
    await new Promise(resolve => setTimeout(resolve, delay));

    return executeWithRetry(fn, retries - 1);
  }
}
```

### Logging

```typescript
import * as functions from 'firebase-functions';

// Structured logging
functions.logger.info('Fetching environmental data', {
  timestamp: new Date().toISOString(),
  source: 'NOAA',
  station: '8737048'
});

functions.logger.error('API fetch failed', {
  error: error.message,
  stack: error.stack,
  retryCount: 2
});
```

---

## Monitoring & Alerts

### Cloud Monitoring Metrics

1. **Function Execution Count**: Track invocations per function
2. **Execution Time**: Monitor performance
3. **Error Rate**: Alert if >5% errors
4. **API Response Times**: Track external API latency
5. **Notification Delivery**: FCM success rate

### Alert Policies

```yaml
# Cloud Monitoring Alert Policy
- name: "High Error Rate"
  condition: error_rate > 5%
  duration: 5 minutes
  notification: admin@mobileBayjubilee.com

- name: "API Failure"
  condition: api_fetch_failures > 3
  duration: 15 minutes
  notification: admin@mobileBayjubilee.com

- name: "Function Timeout"
  condition: execution_time > 540s
  duration: 1 minute
  notification: admin@mobileBayjubilee.com
```

---

## Cost Estimates

### Monthly Cloud Functions Costs (Estimated)

| Function | Invocations/Month | Cost/Invocation | Total |
|----------|------------------|-----------------|-------|
| fetchEnvironmentalData | 1,440 | $0.0035 | $5.00 |
| calculateConditionScore | 1,440 | $0.0014 | $2.00 |
| evaluateAlertLevel | 1,500 | $0.0020 | $3.00 |
| sendPushNotifications | 500 batches | $0.0100 | $5.00 |
| onUserCreate | 50 | $0.0200 | $1.00 |
| updateUserReputation | 1,000 | $0.0020 | $2.00 |
| archiveOldReports | 30 | $0.0333 | $1.00 |
| cleanupOldConditions | 30 | $0.0333 | $1.00 |
| generateDailyStats | 30 | $0.0333 | $1.00 |

**Total Estimated Cost**: ~$21/month

**Note**: Costs will scale with user base. At 10,000 active users, estimate ~$50-75/month.

---

## Deployment Process

### Initial Setup

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Cloud Functions
firebase init functions

# Select TypeScript
# Install dependencies
cd functions
npm install
```

### Deploy Functions

```bash
# Deploy all functions
firebase deploy --only functions

# Deploy specific function
firebase deploy --only functions:fetchEnvironmentalData

# Deploy with environment config
firebase functions:config:set \
  noaa.api_url="https://api.tidesandcurrents.noaa.gov/api/prod/" \
  arcos.api_key="your-key"
```

### Testing Locally

```bash
# Start Firebase emulators
firebase emulators:start --only functions,firestore

# Test function locally
curl http://localhost:5001/mobile-bay-jubilee/us-central1/fetchEnvironmentalData
```

---

## Implementation Checklist

### Phase 1 (Immediate - Sprint 2)
- [ ] Set up Cloud Functions project structure
- [ ] Implement `fetchEnvironmentalData` function
- [ ] Implement `calculateConditionScore` function
- [ ] Deploy and test data ingestion pipeline

### Phase 2 (Sprint 3)
- [ ] Implement `evaluateAlertLevel` function
- [ ] Implement `sendPushNotifications` function
- [ ] Configure FCM server key
- [ ] Test notification flow end-to-end

### Phase 3 (Sprint 4)
- [ ] Implement `onUserCreate` function
- [ ] Implement `updateUserReputation` function
- [ ] Test user management flows

### Phase 4 (Pre-Launch)
- [ ] Implement maintenance functions (archiving, cleanup)
- [ ] Implement analytics functions
- [ ] Set up monitoring and alerts
- [ ] Load testing

### Phase 5 (Post-Launch)
- [ ] Monitor performance and costs
- [ ] Optimize slow functions
- [ ] Scale as needed

---

## References

- **Swift Services to Port**:
  - `MobileBayJubilee/Services/ConditionScoreService.swift`
  - `MobileBayJubilee/Services/AlertLevelManager.swift`
  - `MobileBayJubilee/Services/ReputationManager.swift`
  - `MobileBayJubilee/Services/NotificationManager.swift`

- **Firebase Documentation**:
  - [Cloud Functions Documentation](https://firebase.google.com/docs/functions)
  - [Cloud Scheduler](https://cloud.google.com/scheduler/docs)
  - [Firebase Admin SDK](https://firebase.google.com/docs/admin/setup)

- **API Documentation**:
  - [NOAA Tides & Currents API](https://api.tidesandcurrents.noaa.gov/api/prod/)
  - [NOAA Weather Service API](https://www.weather.gov/documentation/services-web-api)
  - [ARCOS API](https://arcos.disl.org)

---

**Last Updated**: 2025-10-20
**Status**: Architecture Defined - Ready for Implementation
**Next Step**: Begin Phase 1 implementation in Sprint 2

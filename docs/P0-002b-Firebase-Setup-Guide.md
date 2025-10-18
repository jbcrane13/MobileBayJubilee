# Firebase Backend Setup Guide

**Project**: JubileeHub iOS Application
**Created**: 2025-10-18
**Phase**: P0-002b - Backend Infrastructure Scaffolding
**Platform**: Firebase (Google Cloud Platform)
**Owner**: Backend Lead

---

## Executive Summary

This guide provides step-by-step instructions for setting up the Firebase backend infrastructure for JubileeHub. Follow these steps during Phase 0 (Weeks 1-4) to establish the complete backend architecture.

**Estimated Time**: 3-4 weeks
**Prerequisites**: Google Cloud account, Firebase CLI installed, basic Node.js knowledge

---

## Table of Contents

1. [Firebase Project Setup](#1-firebase-project-setup)
2. [Firebase Authentication](#2-firebase-authentication)
3. [Cloud Firestore Database](#3-cloud-firestore-database)
4. [Realtime Database (Chat)](#4-realtime-database-chat)
5. [Cloud Storage](#5-cloud-storage)
6. [Cloud Functions](#6-cloud-functions)
7. [Cloud Run (NOAA/ARCOS Ingestion)](#7-cloud-run-noaaarc OS-ingestion)
8. [Cloud Scheduler](#8-cloud-scheduler)
9. [Firebase Cloud Messaging](#9-firebase-cloud-messaging)
10. [Security Rules](#10-security-rules)
11. [Testing & Validation](#11-testing--validation)

---

## 1. Firebase Project Setup

### 1.1 Create Firebase Project

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Create new Firebase project via console
# Navigate to: https://console.firebase.google.com
# Click: "Add project"
```

**Project Configuration**:
- **Project Name**: `JubileeHub`
- **Project ID**: `jubileehub-prod`
- **Enable Google Analytics**: Yes (recommended)
- **Analytics Location**: United States
- **Cloud Firestore Location**: `us-central1` (recommended for US East Coast)

### 1.2 Initialize Firebase in Local Directory

```bash
cd /path/to/MobileBayJubilee

# Create backend directory
mkdir -p backend
cd backend

# Initialize Firebase
firebase init

# Select features:
# [x] Firestore
# [x] Functions
# [x] Storage
# [x] Emulators (for local testing)

# Configuration:
# - Use existing project: jubileehub-prod
# - Firestore rules: firestore.rules
# - Firestore indexes: firestore.indexes.json
# - Functions language: TypeScript
# - ESLint: Yes
# - Install dependencies: Yes
```

### 1.3 Project Structure

After initialization, your directory structure should be:

```
backend/
├── firestore.rules          # Firestore security rules
├── firestore.indexes.json   # Firestore composite indexes
├── storage.rules            # Cloud Storage security rules
├── firebase.json            # Firebase configuration
├── .firebaserc              # Firebase project aliases
├── functions/               # Cloud Functions
│   ├── src/
│   │   └── index.ts
│   ├── package.json
│   └── tsconfig.json
└── cloud-run/               # Cloud Run containers (create manually)
    └── noaa-ingest/
```

---

## 2. Firebase Authentication

### 2.1 Enable Authentication Methods

**Via Firebase Console**:
1. Navigate to **Authentication** > **Sign-in method**
2. Enable **Email/Password**
3. Enable **Sign in with Apple**
   - Provide Apple Team ID
   - Configure Service ID
   - Upload private key (.p8 file)

**Apple Sign-In Configuration**:
```typescript
// iOS app will handle Apple Sign-In via AuthenticationServices
// Backend validates token via Firebase Admin SDK

// Example: functions/src/auth.ts
import * as admin from 'firebase-admin';

export const verifyAppleToken = async (idToken: string) => {
  const decodedToken = await admin.auth().verifyIdToken(idToken);
  return decoded Token;
};
```

### 2.2 Custom Claims (User Roles)

```typescript
// functions/src/auth.ts
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const setUserRole = functions.https.onCall(async (data, context) => {
  // Only admins can set roles
  if (!context.auth?.token.admin) {
    throw new functions.https.HttpsError(
      'permission-denied',
      'Only admins can set user roles.'
    );
  }

  await admin.auth().setCustomUserClaims(data.uid, {
    verifiedWatcher: data.verifiedWatcher || false,
    moderator: data.moderator || false,
    admin: data.admin || false,
  });

  return { success: true };
});
```

---

## 3. Cloud Firestore Database

### 3.1 Create Firestore Database

**Via Firebase Console**:
1. Navigate to **Firestore Database**
2. Click **Create database**
3. Select **Production mode** (we'll configure rules separately)
4. Choose location: `us-central1`

### 3.2 Database Schema

Create collections with the following structure:

**`users` Collection**:
```
/users/{userId}
  - displayName: string
  - email: string
  - profilePhotoURL: string | null
  - reputation: number (default: 50)
  - isVerifiedWatcher: boolean
  - favoriteLocations: string[]
  - notificationThreshold: number (default: 70)
  - notificationsEnabled: boolean
  - createdAt: timestamp
  - lastLoginAt: timestamp
```

**`reports` Collection**:
```
/reports/{reportId}
  - reportType: string ("Full Jubilee" | "Early Warning" | "All Clear")
  - latitude: number
  - longitude: number
  - locationName: string
  - species: string[]
  - intensity: string ("Low" | "Moderate" | "Heavy" | "Extreme")
  - description: string | null
  - photoURLs: string[]
  - verifications: number (default: 0)
  - isVerified: boolean
  - authorId: string (reference to /users/{userId})
  - reportedAt: timestamp
  - createdAt: timestamp
```

**`locations` Collection**:
```
/locations/{locationId}
  - locationType: string ("Beach" | "Webcam" | "Monitoring Station")
  - name: string
  - latitude: number
  - longitude: number
  - webcamURL: string | null
  - stationID: string | null
  - stationSource: string | null ("NOAA" | "ARCOS")
  - favoritesCount: number
```

**`condition_snapshots` Collection**:
```
/condition_snapshots/{snapshotId}
  - score: number (0-100)
  - seasonalScore: number
  - timeWindowScore: number
  - windScore: number
  - tideScore: number
  - weatherPatternScore: number
  - waterQualityScore: number
  - windSpeed: number
  - windDirection: string
  - temperature: number
  - tide: string ("High" | "Low" | "Rising" | "Falling")
  - salinity: number | null
  - waterTemperature: number | null
  - dissolvedOxygen: number | null
  - alertLevel: string ("None" | "WATCH" | "CONFIRMED")
  - fetchedAt: timestamp
  - createdAt: timestamp
```

### 3.3 Create Composite Indexes

Edit `firestore.indexes.json`:

```json
{
  "indexes": [
    {
      "collectionGroup": "reports",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "createdAt", "order": "DESCENDING" },
        { "fieldPath": "isVerified", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "reports",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "reportType", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "condition_snapshots",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "createdAt", "order": "DESCENDING" },
        { "fieldPath": "alertLevel", "order": "ASCENDING" }
      ]
    }
  ],
  "fieldOverrides": []
}
```

Deploy indexes:
```bash
firebase deploy --only firestore:indexes
```

---

## 4. Realtime Database (Chat)

### 4.1 Create Realtime Database Instance

**Via Firebase Console**:
1. Navigate to **Realtime Database**
2. Click **Create Database**
3. Choose location: `us-central1`
4. Start in **locked mode** (we'll configure rules)

### 4.2 Chat Data Structure

```
/chats
  /{chatId}  (e.g., "jubilee-2026-06-15")
    /messages
      /{messageId}
        - authorId: string
        - authorName: string
        - text: string
        - timestamp: number
        - photoURL: string | null
    /metadata
      - title: string
      - createdAt: number
      - activeUsers: number
      - isActive: boolean
```

### 4.3 Message TTL (Time-to-Live)

Implement Cloud Function to delete old messages:

```typescript
// functions/src/chat.ts
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

const SEVEN_DAYS_MS = 7 * 24 * 60 * 60 * 1000;

export const cleanupOldMessages = functions.pubsub
  .schedule('every 24 hours')
  .onRun(async (context) => {
    const db = admin.database();
    const now = Date.now();
    const cutoff = now - SEVEN_DAYS_MS;

    const chatsRef = db.ref('/chats');
    const chatsSnapshot = await chatsRef.once('value');

    const deletePromises: Promise<void>[] = [];

    chatsSnapshot.forEach((chatSnap) => {
      const messagesRef = chatSnap.ref.child('messages');
      messagesRef.once('value', (messagesSnapshot) => {
        messagesSnapshot.forEach((messageSnap) => {
          const message = messageSnap.val();
          if (message.timestamp < cutoff) {
            deletePromises.push(messageSnap.ref.remove());
          }
        });
      });
    });

    await Promise.all(deletePromises);
    console.log(`Cleaned up ${deletePromises.length} old messages`);
  });
```

---

## 5. Cloud Storage

### 5.1 Create Storage Bucket

Storage bucket is created automatically with Firebase project.

**Bucket Name**: `jubileehub-prod.appspot.com`

### 5.2 Directory Structure

```
/users/{userId}/profile-photo.jpg
/reports/{reportId}/photos/{photoId}.jpg
/reports/{reportId}/thumbnails/{photoId}_thumb.jpg
```

### 5.3 Image Resizing Extension

Install Firebase Extension for automatic image resizing:

```bash
firebase ext:install storage-resize-images

# Configuration:
# - Cloud Storage bucket: jubileehub-prod.appspot.com
# - Sizes: 200x200,800x800
# - Delete original: No
# - Cache-Control header: max-age=31536000
```

---

## 6. Cloud Functions

### 6.1 Initialize Functions

Already initialized in step 1.2. Now implement core functions:

**`functions/src/index.ts`**:

```typescript
import * as admin from 'firebase-admin';
admin.initializeApp();

export { onUserCreate } from './auth';
export { onReportCreate, onReportUpdate } from './reports';
export { checkScoreThreshold } from './conditions';
export { cleanupOldMessages } from './chat';
```

**`functions/src/auth.ts`**:

```typescript
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const onUserCreate = functions.auth.user().onCreate(async (user) => {
  const { uid, email, displayName, photoURL } = user;

  // Create Firestore user document
  await admin.firestore().collection('users').doc(uid).set({
    displayName: displayName || 'Jubilee Watcher',
    email: email || '',
    profilePhotoURL: photoURL || null,
    reputation: 50,
    isVerifiedWatcher: false,
    favoriteLocations: [],
    notificationThreshold: 70,
    notificationsEnabled: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    lastLoginAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  console.log(`Created user document for ${uid}`);
});
```

**`functions/src/reports.ts`**:

```typescript
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const onReportCreate = functions.firestore
  .document('reports/{reportId}')
  .onCreate(async (snap, context) => {
    const report = snap.data();

    // Increment author's reputation
    if (report.authorId) {
      const userRef = admin.firestore().collection('users').doc(report.authorId);
      await userRef.update({
        reputation: admin.firestore.FieldValue.increment(5),
      });
    }

    // Send notification to nearby users (if Jubilee report)
    if (report.reportType === 'Full Jubilee') {
      // TODO: Implement geo-based push notifications
      console.log(`New Jubilee report at ${report.locationName}`);
    }
  });
```

**`functions/src/conditions.ts`**:

```typescript
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const checkScoreThreshold = functions.firestore
  .document('condition_snapshots/{snapshotId}')
  .onCreate(async (snap, context) => {
    const condition = snap.data();

    if (condition.score >= 70 && condition.alertLevel === 'WATCH') {
      // Send push notification to users with threshold <= condition.score
      const usersSnapshot = await admin
        .firestore()
        .collection('users')
        .where('notificationsEnabled', '==', true)
        .where('notificationThreshold', '<=', condition.score)
        .get();

      const tokens = usersSnapshot.docs
        .map((doc) => doc.data().fcmToken)
        .filter(Boolean);

      if (tokens.length > 0) {
        await admin.messaging().sendMulticast({
          tokens,
          notification: {
            title: 'Jubilee WATCH Alert!',
            body: `Condition Score is ${condition.score}. Conditions are favorable for a jubilee event.`,
          },
          data: {
            score: condition.score.toString(),
            alertLevel: condition.alertLevel,
          },
        });

        console.log(`Sent notifications to ${tokens.length} users`);
      }
    }
  });
```

### 6.2 Deploy Functions

```bash
cd functions
npm install
npm run build

cd ..
firebase deploy --only functions
```

---

## 7. Cloud Run (NOAA/ARCOS Ingestion)

### 7.1 Create Cloud Run Container

**Directory**: `cloud-run/noaa-ingest/`

**`Dockerfile`**:

```dockerfile
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

CMD ["node", "index.js"]
```

**`package.json`**:

```json
{
  "name": "noaa-ingest",
  "version": "1.0.0",
  "description": "NOAA/ARCOS data ingestion service",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "axios": "^1.6.0",
    "firebase-admin": "^12.0.0",
    "express": "^4.18.0"
  }
}
```

**`index.js`**:

```javascript
const express = require('express');
const admin = require('firebase-admin');
const axios = require('axios');

admin.initializeApp();
const db = admin.firestore();

const app = express();
const PORT = process.env.PORT || 8080;

// NOAA API endpoints (from P0-001-API-Research-Report.md)
const NOAA_TIDE_URL = 'https://api.tidesandcurrents.noaa.gov/api/prod/datagetter';
const NOAA_WEATHER_URL = 'https://api.weather.gov/points/{lat},{lon}';
const ARCOS_URL = 'https://arcos.disl.org/api/data';  // TODO: Update with actual endpoint

app.get('/ingest', async (req, res) => {
  try {
    console.log('Starting NOAA/ARCOS data ingestion...');

    // 1. Fetch NOAA Tide Data (Mobile Bay)
    const tideResponse = await axios.get(NOAA_TIDE_URL, {
      params: {
        product: 'predictions',
        application: 'JubileeHub',
        station: '8735180',  // Dauphin Island, AL
        datum: 'MLLW',
        units: 'english',
        time_zone: 'lst_ldt',
        format: 'json',
        interval: 'hilo',  // High/low predictions
        date: 'today',
      },
    });

    // 2. Fetch NOAA Weather Data
    const weatherResponse = await axios.get(NOAA_WEATHER_URL.replace('{lat}', '30.4866').replace('{lon}', '-87.9249'));
    const forecastUrl = weatherResponse.data.properties.forecast;
    const forecastResponse = await axios.get(forecastUrl);

    // 3. Fetch ARCOS Water Quality Data
    // TODO: Replace with actual ARCOS API endpoint after contacting Dauphin Island Sea Lab
    const arcosResponse = await axios.get(ARCOS_URL, {
      params: {
        station: 'mobile_bay_east',  // TODO: Update with actual station ID
        parameters: 'salinity,water_temp,dissolved_oxygen',
      },
    });

    // 4. Calculate Condition Score
    const conditionScore = calculateConditionScore({
      tide: tideResponse.data,
      weather: forecastResponse.data,
      waterQuality: arcosResponse.data,
    });

    // 5. Save to Firestore
    await db.collection('condition_snapshots').add({
      ...conditionScore,
      fetchedAt: admin.firestore.Timestamp.now(),
      createdAt: admin.firestore.Timestamp.now(),
    });

    console.log('Data ingestion complete. Score:', conditionScore.score);
    res.json({ success: true, score: conditionScore.score });

  } catch (error) {
    console.error('Ingestion error:', error);
    res.status(500).json({ error: error.message });
  }
});

// Condition Score Algorithm (simplified - refine based on PRD)
function calculateConditionScore(data) {
  // TODO: Implement full algorithm from PRD
  // This is a placeholder
  let score = 0;

  // Seasonal component (June-August = high)
  const month = new Date().getMonth();
  const seasonalScore = (month >= 5 && month <= 7) ? 20 : 5;

  // Time window (2am-6am = high)
  const hour = new Date().getHours();
  const timeWindowScore = (hour >= 2 && hour <= 6) ? 20 : 5;

  // Wind score (low wind = high score)
  // TODO: Extract from weather data
  const windScore = 15;

  // Tide score (low tide + rising = high score)
  // TODO: Extract from tide data
  const tideScore = 15;

  // Weather pattern score
  const weatherPatternScore = 15;

  // Water quality score (low salinity + high temp = high score)
  // TODO: Extract from ARCOS data
  const waterQualityScore = 10;

  score = seasonalScore + timeWindowScore + windScore + tideScore + weatherPatternScore + waterQualityScore;

  // Determine alert level
  let alertLevel = 'None';
  if (score >= 80) alertLevel = 'CONFIRMED';
  else if (score >= 70) alertLevel = 'WATCH';

  return {
    score,
    seasonalScore,
    timeWindowScore,
    windScore,
    tideScore,
    weatherPatternScore,
    waterQualityScore,
    windSpeed: 5.2,  // TODO: Extract from weather data
    windDirection: 'N',
    temperature: 78,
    tide: 'Low',
    salinity: 15.3,  // TODO: Extract from ARCOS
    waterTemperature: 82.1,
    dissolvedOxygen: 6.5,
    alertLevel,
  };
}

app.listen(PORT, () => {
  console.log(`NOAA Ingest service listening on port ${PORT}`);
});
```

### 7.2 Deploy to Cloud Run

```bash
cd cloud-run/noaa-ingest

# Build container
gcloud builds submit --tag gcr.io/jubileehub-prod/noaa-ingest

# Deploy to Cloud Run
gcloud run deploy noaa-ingest \
  --image gcr.io/jubileehub-prod/noaa-ingest \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --memory 512Mi \
  --timeout 300s

# Note the service URL (e.g., https://noaa-ingest-xxxxx.run.app)
```

---

## 8. Cloud Scheduler

### 8.1 Create Scheduler Job

```bash
# Create Cloud Scheduler job to trigger Cloud Run every 30 minutes
gcloud scheduler jobs create http noaa-ingest-cron \
  --schedule="*/30 * * * *" \
  --uri="https://noaa-ingest-xxxxx.run.app/ingest" \
  --http-method=GET \
  --time-zone="America/Chicago" \
  --description="Fetch NOAA/ARCOS data every 30 minutes"

# Test the job
gcloud scheduler jobs run noaa-ingest-cron
```

---

## 9. Firebase Cloud Messaging

### 9.1 Enable FCM

FCM is enabled by default in Firebase projects.

### 9.2 iOS APNs Configuration

1. Upload APNs Authentication Key (.p8 file) to Firebase Console
2. Navigate to **Project Settings** > **Cloud Messaging** > **iOS app configuration**
3. Upload .p8 file and provide:
   - Key ID
   - Team ID

### 9.3 Send Test Notification

```bash
# Via Firebase Console
# Navigate to: Cloud Messaging > Send test message
# Enter FCM token from iOS device
```

---

## 10. Security Rules

### 10.1 Firestore Rules

Edit `firestore.rules`:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helper functions
    function isSignedIn() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return request.auth.uid == userId;
    }

    function isVerifiedWatcher() {
      return isSignedIn() && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isVerifiedWatcher == true;
    }

    // Users collection
    match /users/{userId} {
      allow read: if isSignedIn();
      allow create: if isOwner(userId);
      allow update: if isOwner(userId) && !request.resource.data.diff(resource.data).affectedKeys().hasAny(['reputation', 'isVerifiedWatcher']);
      allow delete: if false;  // No deletions
    }

    // Reports collection
    match /reports/{reportId} {
      allow read: if true;  // Public read
      allow create: if isSignedIn() && request.resource.data.authorId == request.auth.uid;
      allow update: if isSignedIn() && (
        isOwner(resource.data.authorId) ||  // Owner can update
        request.resource.data.diff(resource.data).affectedKeys().hasOnly(['verifications'])  // Anyone can verify
      );
      allow delete: if false;  // No deletions
    }

    // Locations collection
    match /locations/{locationId} {
      allow read: if true;  // Public read
      allow write: if false;  // Admin only (via functions)
    }

    // Condition snapshots
    match /condition_snapshots/{snapshotId} {
      allow read: if true;  // Public read
      allow write: if false;  // System only (via Cloud Run)
    }
  }
}
```

Deploy rules:
```bash
firebase deploy --only firestore:rules
```

### 10.2 Realtime Database Rules

Edit `database.rules.json`:

```json
{
  "rules": {
    "chats": {
      "$chatId": {
        "messages": {
          ".read": true,
          ".write": "auth != null",
          "$messageId": {
            ".validate": "newData.hasChildren(['authorId', 'authorName', 'text', 'timestamp']) && newData.child('authorId').val() === auth.uid"
          }
        },
        "metadata": {
          ".read": true,
          ".write": false
        }
      }
    }
  }
}
```

### 10.3 Storage Rules

Edit `storage.rules`:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {

    // User profile photos
    match /users/{userId}/profile-photo.jpg {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }

    // Report photos
    match /reports/{reportId}/photos/{photoId} {
      allow read: if true;
      allow write: if request.auth != null;  // Any authenticated user can upload
    }

    // Thumbnails (generated by resize extension)
    match /reports/{reportId}/thumbnails/{photoId} {
      allow read: if true;
      allow write: if false;  // System only
    }
  }
}
```

Deploy rules:
```bash
firebase deploy --only storage
```

---

## 11. Testing & Validation

### 11.1 Local Emulator Suite

```bash
# Start emulators
firebase emulators:start

# Emulators will run on:
# - Firestore: http://localhost:8080
# - Auth: http://localhost:9099
# - Functions: http://localhost:5001
# - Storage: http://localhost:9199
# - Realtime Database: http://localhost:9000
```

### 11.2 Integration Tests

Create `backend/test/integration.test.ts`:

```typescript
import * as testing from '@firebase/rules-unit-testing';
import { readFileSync } from 'fs';

let testEnv: testing.RulesTestEnvironment;

beforeAll(async () => {
  testEnv = await testing.initializeTestEnvironment({
    projectId: 'jubileehub-test',
    firestore: {
      rules: readFileSync('../firestore.rules', 'utf8'),
    },
  });
});

afterAll(async () => {
  await testEnv.cleanup();
});

test('authenticated user can create own profile', async () => {
  const alice = testEnv.authenticatedContext('alice');
  const userDoc = alice.firestore().doc('users/alice');

  await testing.assertSucceeds(
    userDoc.set({
      displayName: 'Alice',
      email: 'alice@example.com',
      reputation: 50,
    })
  );
});

test('user cannot modify own reputation', async () => {
  const alice = testEnv.authenticatedContext('alice');
  const userDoc = alice.firestore().doc('users/alice');

  await userDoc.set({ displayName: 'Alice', reputation: 50 });

  await testing.assertFails(
    userDoc.update({ reputation: 100 })
  );
});
```

Run tests:
```bash
cd backend
npm test
```

### 11.3 End-to-End Validation

**Checklist**:
- [ ] Firebase project created and configured
- [ ] Authentication methods enabled (Email/Password, Apple)
- [ ] Firestore database created with schema
- [ ] Realtime Database created for chat
- [ ] Cloud Storage bucket configured
- [ ] Cloud Functions deployed and running
- [ ] Cloud Run service deployed
- [ ] Cloud Scheduler job created and triggering
- [ ] FCM configured with APNs
- [ ] Security rules deployed
- [ ] Local emulators tested
- [ ] Integration tests passing
- [ ] iOS app successfully connects to Firebase
- [ ] NOAA/ARCOS data ingestion working

---

## Cost Monitoring

### Enable Budget Alerts

```bash
# Via Google Cloud Console
# Navigate to: Billing > Budgets & alerts
# Create budget:
# - Name: "JubileeHub Monthly Budget"
# - Amount: $250/month
# - Alert thresholds: 50%, 90%, 100%
# - Email notifications: enabled
```

### Monitor Usage

```bash
# Firebase Console > Usage and Billing
# Monitor:
# - Firestore: document reads/writes
# - Cloud Functions: invocations
# - Cloud Storage: storage + egress
# - Realtime Database: concurrent connections + bandwidth
```

---

## Troubleshooting

### Cloud Run Returns 500

**Possible causes**:
- Firestore permission denied (check service account)
- NOAA/ARCOS API rate limiting
- Invalid API parameters

**Debug**:
```bash
# View Cloud Run logs
gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=noaa-ingest" --limit 50
```

### Firestore Security Rules Blocking Writes

**Debug**:
```bash
# Check Firestore rules in emulator
firebase emulators:start --only firestore
# Navigate to: http://localhost:4000/firestore
```

### Cloud Scheduler Not Triggering

**Debug**:
```bash
# Check scheduler job status
gcloud scheduler jobs describe noaa-ingest-cron

# View scheduler logs
gcloud logging read "resource.type=cloud_scheduler_job" --limit 20
```

---

## Next Steps

After completing this setup:

1. **Contact ARCOS**: Email Dauphin Island Sea Lab for API access
2. **Test Data Flow**: Manually trigger scheduler, verify Firestore updates
3. **iOS Integration**: Integrate Firebase SDKs into iOS app
4. **Refine Algorithm**: Implement full Condition Score calculation
5. **Phase 1**: Begin feature development with backend ready

---

**Document Version**: 1.0
**Created**: 2025-10-18
**Last Updated**: 2025-10-18
**Owner**: Backend Lead
**Status**: READY FOR IMPLEMENTATION ✅

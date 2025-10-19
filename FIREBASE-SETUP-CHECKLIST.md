# Firebase Setup Checklist - Mobile Bay Jubilee

## ✅ Completed
- [x] Created Firebase project "Mobile-Bay-Jubilee"
- [x] Added Firebase SDK to Xcode project

## 📋 To Do Now

### 1. Download & Add Configuration File ⭐ **DO THIS FIRST**
- [ ] Firebase Console → Project Settings → iOS app
- [ ] Download `GoogleService-Info.plist`
- [ ] Drag to `MobileBayJubilee/` folder in Xcode
  - ✅ Check "Copy items if needed"
  - ✅ Check "MobileBayJubilee" target

### 2. Enable Authentication
- [ ] Firebase Console → Authentication → Get Started
- [ ] Enable **Email/Password** provider
- [ ] Enable **Apple** provider
- [ ] (Optional) Enable **Google** provider

### 3. Create Firestore Database
- [ ] Firebase Console → Firestore Database → Create database
- [ ] Choose location: **us-central1** or **us-east1**
- [ ] Start in **TEST MODE** (for development)
- [ ] Create collections:
  - [ ] `conditions` (see structure in firebase-security-rules.txt)
  - [ ] `reports` (see structure in firebase-security-rules.txt)
  - [ ] `users` (see structure in firebase-security-rules.txt)
  - [ ] `locations` (see structure in firebase-security-rules.txt)

### 4. Configure Cloud Storage
- [ ] Firebase Console → Storage → Get Started
- [ ] Choose same location as Firestore
- [ ] Start in **TEST MODE**
- [ ] Create folders:
  - [ ] `report_photos/`
  - [ ] `profile_photos/`

### 5. Enable Cloud Messaging (Optional - for notifications)
- [ ] Firebase Console → Cloud Messaging
- [ ] Upload APNs certificate (requires Apple Developer account)
  - See detailed steps in firebase-security-rules.txt

### 6. Initialize Firebase in App
- [ ] Add Firebase initialization to `MobileBayJubileeApp.swift`:

```swift
import SwiftUI
import FirebaseCore

@main
struct MobileBayJubileeApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 7. Create RealFirebaseService
- [ ] Create new file: `RealFirebaseService.swift`
- [ ] Implement `FirebaseServiceProtocol` using real Firebase calls
- [ ] Update `FirebaseServiceManager.shared` to use `RealFirebaseService()`

### 8. Test the Integration
- [ ] Build and run app
- [ ] Test authentication (sign in with email)
- [ ] Test creating a report
- [ ] Test fetching conditions
- [ ] Verify data appears in Firebase Console

---

## 🔒 Before Production (Later)

- [ ] Apply production security rules (see firebase-security-rules.txt)
- [ ] Configure APNs for push notifications
- [ ] Enable rate limiting
- [ ] Set up billing alerts
- [ ] Enable Crashlytics
- [ ] Enable Analytics
- [ ] Test with Firebase Emulator Suite

---

## 📄 Reference Files
- `firebase-security-rules.txt` - Complete security rules and setup instructions
- `MobileBayJubilee/Services/FirebaseService.swift` - Implementation guide (see line 127)

## 🆘 Need Help?
- Firebase Docs: https://firebase.google.com/docs/ios/setup
- Sign in with Apple: https://firebase.google.com/docs/auth/ios/apple
- Firestore: https://firebase.google.com/docs/firestore/quickstart

---

**Current Status**: Ready for GoogleService-Info.plist integration
**Next Step**: Download and add GoogleService-Info.plist to Xcode

# Firebase Configuration Setup

## GoogleService-Info.plist

**IMPORTANT**: The `GoogleService-Info.plist` file is **NOT** included in version control for security reasons.

### How to Get Your Configuration File

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Select the "Mobile-Bay-Jubilee" project
3. Click the ⚙️ gear icon → **Project Settings**
4. Scroll down to **Your apps** section
5. Click on the iOS app
6. Click **Download GoogleService-Info.plist**

### Installation

1. Download the file from Firebase Console
2. In Xcode, drag `GoogleService-Info.plist` to the `MobileBayJubilee/` folder
3. Make sure to:
   - ✅ Check **"Copy items if needed"**
   - ✅ Check **"MobileBayJubilee" target**
4. Click **Finish**

### Verification

The file should be located at:
```
MobileBayJubilee/GoogleService-Info.plist
```

And should be added to the **MobileBayJubilee** target (visible in File Inspector).

### Security Note

⚠️ **NEVER commit this file to git!** It contains sensitive API keys and configuration.

The file is already in `.gitignore` to prevent accidental commits.

---

For complete Firebase setup instructions, see [FIREBASE-SETUP-CHECKLIST.md](./FIREBASE-SETUP-CHECKLIST.md)

# Sign in with Apple Setup Guide

## Prerequisites

- Apple Developer Program membership ($99/year)
- Xcode installed
- Firebase project configured with Apple Sign In provider enabled

## Part 1: Enable Capability in Xcode

### Step 1: Open Project Settings
1. Open `MobileBayJubilee.xcodeproj` in Xcode
2. Select the **MobileBayJubilee** project in the Navigator (left sidebar)
3. Select the **MobileBayJubilee** target (under TARGETS)
4. Click the **Signing & Capabilities** tab

### Step 2: Add Sign in with Apple Capability
1. Click the **+ Capability** button (top left of the content area)
2. Search for **"Sign in with Apple"**
3. Double-click **"Sign in with Apple"** to add it

You should now see "Sign in with Apple" listed in the capabilities section.

### Step 3: Configure Team and Bundle ID
1. In **Signing & Capabilities** tab:
   - **Team**: Select your Apple Developer team
   - **Bundle Identifier**: Should be `com.yourcompany.MobileBayJubilee` (or your chosen ID)

2. Xcode will automatically:
   - Create an App ID in your Apple Developer account
   - Enable "Sign in with Apple" capability on that App ID
   - Generate provisioning profiles

## Part 2: Apple Developer Portal Configuration

### Step 4: Verify App ID in Apple Developer Portal

1. Go to [Apple Developer](https://developer.apple.com/)
2. Navigate to **Certificates, Identifiers & Profiles**
3. Click **Identifiers** (left sidebar)
4. Find your app's identifier (e.g., `com.yourcompany.MobileBayJubilee`)
5. Verify that **Sign in with Apple** is checked/enabled

### Step 5: (Optional) Configure Additional Settings

If you need to customize the Sign in with Apple experience:

1. In the App ID configuration, click **Edit** next to "Sign in with Apple"
2. Configure:
   - **Enable as primary App ID** (default)
   - Or group with another App ID if you have a website/other apps

## Part 3: Firebase Console Configuration (Already Done)

✅ You mentioned you already enabled Apple Sign In in Firebase Console. Verify it's configured:

1. Firebase Console → **Authentication** → **Sign-in method** tab
2. **Apple** should show as **"Enabled"**

### (Optional) Add OAuth Redirect URL to Apple

If Firebase shows a redirect URL:
1. Copy the OAuth redirect URL from Firebase Console
2. Go to Apple Developer Portal → Your App ID → **Sign in with Apple** → **Configure**
3. Add Firebase's redirect URL to the allowed list

## Part 4: Testing

### Test on iOS Simulator (Limited)
- Sign in with Apple on simulator will use a test account
- Full functionality requires a real device

### Test on Real Device
1. Connect your iPhone/iPad
2. Select your device in Xcode (top toolbar)
3. Build and run (Cmd+R)
4. Tap "Sign in with Apple" button
5. You should see the Apple Sign In dialog

## Troubleshooting

### Error: "Sign in with Apple is not configured"
**Fix**: Make sure you've added the capability in Xcode and selected a valid team

### Error: "Invalid client"
**Fix**:
1. Verify Bundle ID matches in Xcode and Apple Developer Portal
2. Verify App ID has Sign in with Apple enabled
3. Regenerate provisioning profiles

### Error: "The operation couldn't be completed"
**Fix**:
1. Make sure you're signed in to iCloud on your test device
2. Verify your Apple ID is valid
3. Check that Firebase is properly configured

### Simulator Shows Test Account
This is normal. Sign in with Apple on simulator always shows:
- Email: test@example.com (or similar)
- Name: Test User

Use a real device for actual testing.

## Current Implementation Status

✅ **Completed**:
- AuthenticationManager service with Apple Sign In support
- ProfileView with "Sign in with Apple" button
- Firebase integration for Apple authentication
- Email/Password authentication as alternative

⏳ **Required (Manual Steps)**:
- Enable "Sign in with Apple" capability in Xcode (follow steps above)
- Test on real device with Apple Developer account

## Code References

**AuthenticationManager.swift**: Handles Apple Sign In flow
- `signInWithApple()`: Initiates Apple Sign In
- `handleAppleSignInCompletion()`: Processes Apple credential
- Uses `ASAuthorizationAppleIDProvider` for authentication

**ProfileView.swift**: UI implementation
- "Sign in with Apple" button triggers `authManager.signInWithApple()`
- Automatic Firebase user creation on first sign-in

## Next Steps

1. **Enable capability in Xcode** (follow Part 1 above)
2. **Build and run on simulator** to test basic flow
3. **Test on real device** for full functionality
4. **Monitor Firebase Console** → Authentication → Users to see new sign-ins

---

**Note**: Sign in with Apple requires an active Apple Developer Program membership. If you don't have one, you can still use Email/Password authentication which is already implemented and working.

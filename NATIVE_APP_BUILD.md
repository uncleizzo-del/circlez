# Building Native Apps with Capacitor

Your Circlez app is now set up for iOS and Android via Capacitor!

## Before Building

Make sure your web app is up to date:
```bash
npm run build  # or manually run: cp legacy.html dist/index.html
```

## iOS Build & Submit

### Prerequisites
- Xcode installed (Mac only)
- Apple Developer Account ($99/year)

### Build Steps
```bash
# Open iOS project in Xcode
npx cap open ios

# In Xcode:
# 1. Select "circlez" target
# 2. Set Bundle ID to match your app ID (io.circlez.app)
# 3. Add your Apple Developer signing certificate
# 4. Build → Archive → Upload to App Store Connect
```

## Android Build & Submit

### Prerequisites
- Android Studio installed
- Google Play Developer Account ($25 one-time)
- Android SDK

### Build Steps
```bash
# Sync code changes
npx cap sync android

# Open Android Studio
npx cap open android

# In Android Studio:
# 1. Build → Generate Signed Bundle/APK
# 2. Create a new keystore for your app
# 3. Upload to Google Play Console
```

## Update Native Code After Changes

Whenever you change `legacy.html`:
```bash
cp legacy.html dist/index.html
npx cap sync
```

Then rebuild in Xcode or Android Studio.

## Useful Commands

```bash
# Sync web assets to both platforms
npx cap sync

# Update only iOS
npx cap sync ios

# Update only Android
npx cap sync android

# Open iOS in Xcode
npx cap open ios

# Open Android in Android Studio
npx cap open android

# View live logs from device
npx cap open ios  # then run in Xcode with device connected
```

## Bundle Identifiers
- **iOS**: `io.circlez.app`
- **Android**: `io.circlez.app`

## App Icons & Splash Screens

To add custom icons/splash:
1. Create 1024x1024 PNG for icon
2. Create 2732x2732 PNG for splash
3. Use Capacitor resource generator:
```bash
npm install -g @capacitor/assets
npx cap-assets generate --ios --android
```

## Testing on Real Device

### iOS
1. Connect iPhone
2. In Xcode: Product → Run (or ⌘R)
3. App will install and run on device

### Android
1. Enable Developer Mode on Android phone (tap Build Number 7x in Settings)
2. Connect phone via USB
3. In Android Studio: Run → Run App
4. Select your phone

---

**Need help?** Visit: https://capacitorjs.com/docs/guides

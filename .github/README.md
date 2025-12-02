# 🤖 GitHub Actions CI/CD

## Automated AAB Build

This workflow automatically builds a signed Android App Bundle (AAB) for VoiceBubble.

### 🚀 When It Runs
- **Automatically:** Every push to `main` branch
- **Manually:** Click "Actions" → "Build Flutter AAB" → "Run workflow"

### 📦 What It Does
1. ✅ Sets up Java 17 & Flutter 3.35.6
2. ✅ Verifies keystore and extracts SHA fingerprints
3. ✅ Builds signed release AAB
4. ✅ Uploads AAB as downloadable artifact
5. ✅ Uploads ProGuard mapping file (for crash analysis)

### 📥 Download Built AAB
1. Go to **Actions** tab in GitHub
2. Click on the latest successful workflow run
3. Scroll down to **Artifacts** section
4. Download `voicebubble-release-aab-build-XXX`
5. Extract the ZIP to get `app-release.aab`

### 🔐 Keystore Configuration
- **Location:** `android/app/keystore/voicebubble-release.jks`
- **Alias:** `voicebubble`
- **Passwords:** `voicebubble2024` (both store & key)
- **Validity:** 27+ years (10,000 days)

**SHA Fingerprints (for Firebase):**
```
SHA-1:   C4:AC:8A:A6:F2:12:E6:1F:9B:8F:B2:0F:EC:3C:18:1E:7B:D0:A1:E3
SHA-256: 49:6E:31:8D:C8:23:4B:77:68:79:62:BF:3C:3C:82:46:73:DB:BE:2E:B8:39:95:D0:5A:B7:1F:B4:42:06:99:7F
```

### 📊 Build Number
Each build automatically increments using GitHub run number:
- Run #1 → `versionCode: 1`
- Run #2 → `versionCode: 2`
- etc.

### 🛠️ Local Build (same as CI)
```bash
# Build AAB locally with same settings
flutter build appbundle --release --no-tree-shake-icons
```

**Output:** `build/app/outputs/bundle/release/app-release.aab`

### ⚠️ Important Notes
1. **Keystore is in repo** - This is intentional for CI/CD automation
2. **For production:** Consider using GitHub Secrets for passwords
3. **Mapping file:** Always upload to Play Console for crash symbolication
4. **First build:** May take 5-7 minutes (subsequent builds ~3-4 min)

### 🔄 Workflow Status
Check the badge in main README or visit Actions tab to see build status.

---

**File:** `.github/workflows/build-aab.yml`  
**Last Updated:** December 2024


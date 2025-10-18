# Product Requirements Document (PRD)

**Project Name**: JubileeHub
**Version**: 1.0
**Last Updated**: October 18, 2025
**Owner**: Product Team
**Status**: Draft

---

## 📋 Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | October 18, 2025 | Product Team | Initial draft |

---

## 🎯 Executive Summary

### Product Vision
> JubileeHub is the community intelligence platform that helps Mobile Bay residents and visitors experience one of nature's rarest phenomena by aggregating environmental data, community observations, and 150+ years of traditional knowledge into a modern, purpose-built iOS application.

### Problem Statement

**Who**: Mobile Bay Eastern Shore residents (Point Clear, Fairhope, Daphne), fishing enthusiasts, families with jubilee traditions, and newcomers to the area.

**What**: The current jubilee alert system is fragmented across multiple Facebook groups, lacks data-driven insights, provides no educational resources for newcomers, and offers no way to aggregate environmental conditions that experienced watchers use for pattern recognition.

**Why**: Jubilees are unpredictable events that occur in the pre-dawn hours (1-4 AM), requiring rapid community mobilization. Missing a jubilee means missing a cherished tradition, potential year's worth of seafood, and unique cultural experience that has shaped the Eastern Shore for over 150 documented years.

**Current Solution**: 
- Multiple Facebook groups ("Jubilee Alert for Eastern Shore," "Jubilee Watch Baldwin County," "Jubilee Report Mobile Bay")
- Text message chains
- Veteran watchers like Doris Bishop who physically check beaches after midnight
- Word-of-mouth alerts via dinner bells and phone trees

**Gap**: 
- No centralized, purpose-built platform
- No aggregation of environmental data (wind, tides, temperature, salinity)
- No educational resources about the science and culture
- No location-precise mapping of reports
- Fragmented community across multiple platforms
- No systematic preservation of generational knowledge

### Success Criteria
- **User Adoption**: 500 active users within first summer season (1% of Eastern Shore population ~50,000)
- **Engagement**: 60%+ of users check app at least weekly during jubilee season (June-September)
- **Alert Accuracy**: 80%+ of jubilee reports verified by multiple users within 30 minutes
- **Community Health**: <5% of interactions requiring moderation
- **Retention**: 70% year-over-year return for summer season
- **Educational Impact**: 80% of new users complete "What is a Jubilee?" onboarding

---

## 👥 Target Users & Personas

### Primary Persona: The Veteran Watcher

**Name**: Doris (based on real Doris Bishop profiled in research)

**Demographics**:
- Age: 65-80
- Occupation: Retired, lifelong Eastern Shore resident
- Tech Savviness: Medium (uses Facebook, smartphone comfortable)
- Location: Point Clear waterfront property

**Goals**:
- Be first to detect early jubilee signs
- Efficiently alert extended network of 25-30 people
- Maintain reputation as reliable jubilee spotter
- Preserve and pass down traditional knowledge
- Reduce time spent on manual beach checks

**Pain Points**:
- Physical burden of walking to beach multiple times per night
- Managing phone list manually
- No way to see if others are seeing same signs
- Difficulty reaching people who aren't on Facebook
- Can't easily share photos/videos of early warning signs

**User Needs**:
- Real-time environmental data to supplement physical observations
- Quick, reliable alert distribution system
- Recognition for accurate reports
- Platform that respects traditional knowledge
- Simple, accessible interface (large text, high contrast)

---

### Secondary Persona: The Family Tradition Keeper

**Name**: Marcus

**Demographics**:
- Age: 35-50
- Occupation: Professional working in Mobile or Eastern Shore
- Tech Savviness: High
- Location: Fairhope, grew up on Eastern Shore

**Goals**:
- Share jubilee tradition with children
- Not miss jubilees due to unpredictable schedule
- Learn to read natural signs like grandparents did
- Build freezer stock for family of 4-5
- Document family jubilee memories

**Pain Points**:
- Unreliable Facebook notifications at 2 AM
- Doesn't have waterfront property for direct observation
- Kids don't understand the science or cultural significance
- Worried tradition is dying as older generation passes
- Needs to balance work schedule with middle-of-night events

**User Needs**:
- Customizable alert thresholds and notification preferences
- Educational content to teach children
- Photo/video sharing to document experiences
- Historical data to show patterns and frequency
- Geographic alerts for preferred beach locations

---

### Tertiary Persona: The Newcomer/Tourist

**Name**: Sarah

**Demographics**:
- Age: 25-40
- Occupation: Recent transplant or vacation rental guest
- Tech Savviness: High
- Location: New to area or visiting

**Goals**:
- Experience this unique phenomenon
- Understand what jubilees are and why they matter
- Learn fishing regulations and etiquette
- Connect with local community
- Know where to go and what to bring

**Pain Points**:
- Doesn't know what to look for
- Unfamiliar with geography and best locations
- Doesn't understand cultural significance
- Worried about breaking rules or social norms
- Not in established alert networks

**User Needs**:
- Comprehensive educational onboarding
- Clear explanation of regulations and size limits
- Community connection with experienced users
- Map showing recommended locations
- "What to bring" preparation guide

---

### Quaternary Persona: The Researcher/Data Collector

**Name**: Dr. Chen

**Demographics**:
- Age: 30-60
- Occupation: Marine biologist, environmental scientist
- Tech Savviness: High
- Location: University or research institution

**Goals**:
- Collect citizen science data on jubilee patterns
- Study correlation between environmental factors
- Document long-term trends and climate impacts
- Validate scientific models
- Publish peer-reviewed research

**Pain Points**:
- No systematic data collection infrastructure
- Scattered anecdotal reports across social media
- Difficulty accessing real-time environmental data
- No historical database of jubilee events
- Can't easily verify user reports

**User Needs**:
- Data export functionality
- Historical event database
- API access to aggregated conditions
- Verified report timestamps and locations
- Environmental data correlation tools

---

## 🎨 Product Overview

### Core Value Proposition

JubileeHub replaces fragmented Facebook groups and text chains with a purpose-built iOS app that combines real-time environmental data, community-verified reports, location-precise mapping, structured watch coordination, and rich historical preservation—making Mobile Bay's 150-year jubilee tradition more accessible, organized, and sustainable for future generations while fostering genuine community connections through both urgent real-time coordination and thoughtful long-form discussion.

### Key Features Overview

1. **Conditions Dashboard**: Real-time environmental monitoring with transparent "Condition Score" showing how current factors align with historical jubilee patterns
2. **Smart Alert System**: Customizable notifications based on environmental thresholds, community reports, and user preferences
3. **Interactive Map**: Live view of jubilee reports, webcam locations, monitoring stations, and historical heatmaps
4. **Dual Community Architecture**: 
   - **Event-Based Live Chat**: Real-time coordination during active jubilees
   - **Discussion Boards**: Persistent forums for planning watch parties, sharing historical photos/stories, asking questions, and preserving cultural knowledge
5. **Watch Coordination System**: Structured tool for organizing overnight watch shifts with RSVP scheduling and automated reminders
6. **Educational Library**: Comprehensive guides on science, culture, regulations, and species identification
7. **User Reputation System**: Recognition for accurate reports and community contributions

### Product Scope

**In Scope**:
- ✅ Real-time environmental data aggregation (weather, tides, temperature)
- ✅ User-submitted jubilee reports with verification system
- ✅ Push notifications with customizable thresholds
- ✅ Interactive map with report markers and webcam links
- ✅ Event-based community chat rooms
- ✅ Educational content library
- ✅ Basic user profiles and reputation system
- ✅ iOS app (iPhone and iPad)
- ✅ Dark mode optimized interface

**Out of Scope** (for initial release):
- ❌ Android version (future consideration)
- ❌ Web application (future consideration)
- ❌ Embedded livestreaming webcams (P1 uses curated links only)
- ❌ Advanced AI/ML prediction models (legal/ethical concerns)
- ❌ E-commerce for fishing gear
- ❌ Integrated fishing license purchasing
- ❌ Social media cross-posting features
- ❌ Gamification features (P3 only, carefully designed)

---

## 🚀 Feature Requirements

### Feature Prioritization Framework

| Priority | Meaning | Release |
|----------|---------|---------|
| **P0** | Critical foundation - must complete before any features | Foundation Phase |
| **P1** | Must-have for MVP launch | Phase 1 (Summer 2026) |
| **P2** | Should-have for enhanced experience | Phase 2 (Fall 2026) |
| **P3** | Nice-to-have for long-term growth | Phase 3+ (2027) |
| **P4** | Future consideration | Backlog |

---

### P0: Foundation Features

#### P0-1: Data Source Validation & API Infrastructure

**Description**: Validate existence and accessibility of all required environmental data sources and establish backend infrastructure for data aggregation.

**Rationale**: The entire Condition Score algorithm depends on reliable, real-time data. Without confirmed data sources, the app's core value proposition fails.

**Requirements**:
- [ ] **CRITICAL VALIDATION TASK**: Confirm existence of real-time water temperature and salinity sensors in Mobile Bay Eastern Shore (Point Clear to Daphne) via NOAA CO-OPS or equivalent
- [ ] Establish API access to NOAA Tides & Currents for Mobile Bay station
- [ ] Establish API access to NOAA Weather Service for Eastern Shore meteorological data
- [ ] Investigate Mobile Bay National Estuary Program data availability
- [ ] Setup USGS Water Data access for Mobile-Tensaw River discharge rates
- [ ] Evaluate backup weather APIs (OpenWeather, Weather Underground)
- [ ] Document API rate limits, update frequencies, and reliability SLAs
- [ ] Create fallback plan if critical data sources are unavailable

**Technical Notes**:
- If water quality sensors don't exist in critical locations, consider Phase 2 partnership with Mobile Bay NEP or university researchers to deploy sensors
- API response time must be <2 seconds for acceptable user experience
- Data staleness tolerance: Weather (15 min), Tides (1 hour), Water quality (if available: 30 min)

**Success Criteria**:
- All required data sources confirmed accessible
- API integration layer built and tested
- Fallback mechanisms documented
- Data refresh rates meet performance requirements

---

#### P0-2: Backend Architecture & Serverless Infrastructure

**Description**: Build cloud-based backend service for data aggregation, condition score calculation, and push notification distribution.

**Rationale**: The Condition Score cannot be calculated on-device efficiently, and proactive push notifications require server-side logic.

**Requirements**:
- [ ] Deploy serverless functions (AWS Lambda or Google Cloud Functions) for scheduled data polling
- [ ] Implement cron-triggered function running every 15 minutes during jubilee season (June-September)
- [ ] Create unified API endpoint that iOS app calls for consolidated data
- [ ] Setup database (Firestore or DynamoDB) for storing:
  - Current condition scores with timestamps
  - Historical scores for pattern analysis
  - User reports and verification status
  - User preferences and notification thresholds
- [ ] Implement push notification service via Apple Push Notification service (APNs)
- [ ] Build admin dashboard for monitoring system health

**User Flow**:
1. Cron trigger fires every 15 minutes
2. Function fetches latest data from all external APIs
3. Function executes Condition Score algorithm (see P1-1)
4. Function stores score and timestamp in database
5. Function checks if score crosses any user thresholds
6. Function sends push notifications to opted-in users
7. iOS app makes single API call to get consolidated response

**Technical Notes**:
- Use serverless architecture to minimize costs during off-season
- Implement circuit breakers for failing external APIs
- Log all API calls and errors for debugging
- Rate limiting: max 1 request per user per minute to prevent abuse

**Success Metrics**:
- Backend uptime: 99.5% during jubilee season
- API response time: <1 second average
- Push notification delivery: <30 seconds from threshold trigger

---

#### P0-3: Core Data Models & SwiftData Architecture

**Description**: Define foundational data models for Users, Reports, Conditions, and Locations using SwiftData.

**Rationale**: Clean data architecture is essential for app stability, offline functionality, and future feature expansion.

**Requirements**:
```swift
@Model
class User {
    var id: UUID
    var username: String
    var email: String
    var profileImageURL: String?
    var reputationScore: Int  // 0-100
    var isVerifiedWatcher: Bool
    var notificationPreferences: NotificationPreferences
    var favoriteLocations: [Location]
    var joinedDate: Date
    var totalReports: Int
    var verifiedReports: Int
}

@Model
class JubileeReport {
    var id: UUID
    var reporterID: UUID
    var location: CLLocationCoordinate2D
    var timestamp: Date
    var reportType: ReportType  // fullJubilee, earlySigns, allClear
    var species: [String]  // flounder, crabs, shrimp, eels
    var intensity: Int  // 1-5 scale
    var description: String
    var photos: [String]  // URLs
    var verifications: [Verification]
    var flagCount: Int
    var status: ReportStatus  // pending, verified, disputed, archived
}

@Model
class ConditionData {
    var id: UUID
    var timestamp: Date
    var conditionScore: Int  // 0-100
    var scoreBreakdown: [String: Int]  // component scores
    var windSpeed: Double
    var windDirection: String
    var temperature: Double
    var tidePhase: TidePhase
    var nextHighTide: Date
    var waterTemp: Double?
    var salinity: Double?
    var communityAlertLevel: AlertLevel  // none, watch, confirmed
}

@Model  
class Location {
    var id: UUID
    var name: String  // "Point Clear Public Beach"
    var coordinates: CLLocationCoordinate2D
    var type: LocationType  // beach, webcam, station
    var isPublic: Bool
    var webcamURL: String?
    var description: String
}
```

**Technical Notes**:
- Use SwiftData for iOS 17+ native persistence
- Enable CloudKit sync for cross-device user preferences
- Implement data migration strategy for future schema changes
- Cache condition data for offline viewing (last 24 hours)

---

#### P0-4: Legal Framework & Regulatory Compliance

**Description**: Establish legal disclaimers, terms of service, privacy policy, and ensure compliance with fishing regulations.

**Rationale**: Liability protection is essential given app facilitates fishing activity and could lead to false expectations about unpredictable natural events.

**Requirements**:
- [ ] Legal disclaimer on Condition Score: "Environmental conditions are favorable for jubilees, but these events remain inherently unpredictable. This score is for informational purposes only."
- [ ] Terms of Service including:
  - No guarantee of jubilee predictions
  - User responsibility for fishing license compliance
  - User-generated content guidelines
  - Liability waiver
- [ ] Privacy Policy compliant with:
  - Apple App Store requirements
  - California Consumer Privacy Act (CCPA)
  - Location data handling
  - User photo/video rights
- [ ] Prominent display of Alabama fishing regulations:
  - Saltwater fishing license required (ages 16-64)
  - Flounder: 5 per person per day, 14-inch minimum
  - Shrimp and blue crabs: 1 five-gallon bucket per person per day
  - Fines: $50-$500 for violations
- [ ] Age verification (13+ per COPPA)
- [ ] Content moderation policy and reporting system

**UI/UX Requirements**:
- First-launch mandatory disclaimer acceptance
- Regulations accessible via "?" button on Dashboard
- In-app link to Alabama Marine Resources Division
- Report submission includes "I agree to follow regulations" checkbox

---

### P1: Core Features (MVP - Summer 2026 Launch)

#### P1-1: Conditions Dashboard with Intelligent Scoring

**Description**: Primary app screen showing real-time environmental conditions and transparent "Condition Score" using rule-based algorithm with gates and multipliers.

**User Story**:
> As a jubilee watcher, I want to see at-a-glance whether current environmental conditions favor jubilees, so I can decide whether to stay alert or sleep through the night.

**Acceptance Criteria**:
- [ ] Dashboard displays within 2 seconds of app launch
- [ ] Condition Score (0-100) prominently displayed with color coding:
  - 0-30: Gray (Unfavorable)
  - 31-60: Yellow (Possible)
  - 61-80: Orange (Favorable)
  - 81-100: Red (Highly Favorable)
- [ ] Score methodology transparent via tap-to-expand section showing component breakdown
- [ ] All environmental data displayed with timestamp and source
- [ ] Pull-to-refresh updates all data
- [ ] Offline mode shows last cached data with clear staleness indicator

**Condition Score Algorithm v2.0** (Rule-Based Engine):

```
GATING CONDITIONS (Score = 0 if any fail):
- Month must be June, July, August, or September
- Time must be between 9 PM and 8 AM
- Wind direction must NOT be West or Southwest

IF all gates pass, calculate component scores:

SEASONAL ALIGNMENT (max 20 points):
- June: 10 points
- July: 15 points  
- August: 20 points
- September: 12 points

TIME WINDOW (max 15 points):
- 1:00-4:00 AM: 15 points
- 12:00-1:00 AM or 4:00-6:00 AM: 10 points
- 9:00 PM-12:00 AM or 6:00-8:00 AM: 5 points

WIND CONDITIONS (max 25 points):
- Direction:
  - East or Northeast: proceed with speed calc
  - North or Southeast: reduce final score by 30%
- Speed:
  - 1.86-3 m/s: 25 points
  - 3-5 m/s: 20 points
  - 5-8 m/s: 15 points
  - >8 m/s: 5 points (too much mixing)

TIDE PHASE (max 15 points):
- Rising tide: 15 points
- High slack: 10 points
- Falling tide: 5 points
- Low slack: 3 points

MULTIPLIER: If (East/NE wind AND rising tide): apply 1.3x to (wind + tide score)

WATER TEMPERATURE (max 10 points, if available):
- >28°C: 10 points
- 25-28°C: 8 points
- 22-25°C: 5 points
- <22°C: 0 points

WEATHER PATTERN (max 10 points):
- Overcast previous day + light rain: 10 points
- Overcast previous day: 7 points
- Clear skies: 5 points

SALINITY STRATIFICATION (max 5 points, if available):
- >8 PSU gradient: 5 points
- 4-8 PSU gradient: 3 points
- <4 PSU gradient: 0 points

TOTAL: Sum all components (after multipliers), cap at 100
```

**Dashboard UI Elements**:
```
┌─────────────────────────────────────┐
│  Condition Score: 78                 │
│  🟠 FAVORABLE CONDITIONS             │
│  [Tap for breakdown ▼]              │
│                                      │
│  🌡️ Water: 27°C                     │
│  💨 Wind: E 4.2 m/s                 │
│  🌊 Tide: Rising (High at 3:47 AM)  │
│  ⏰ Current: 1:23 AM                 │
│  📅 Aug 15, 2026                     │
│  🌙 Waning Gibbous                   │
│                                      │
│  Updated: 2 min ago                  │
│  [Refresh ↻]                         │
│                                      │
│  ⚠️ Community Alert: WATCH           │
│  3 early sign reports near you       │
│  [View Reports →]                    │
└─────────────────────────────────────┘
```

**Success Metrics**:
- Dashboard accessed by 80%+ of active users during season
- Average session begins with dashboard check
- <3% of users report confusion about score interpretation

**Dependencies**:
- P0-2: Backend API providing consolidated condition data
- P0-1: Validated data sources

**Technical Notes**:
- Implement score calculation on backend (consistency + push notifications)
- Cache last score for offline viewing
- Use Combine for reactive UI updates
- Accessibility: VoiceOver descriptions for all data points

---

#### P1-2: Community Alert System (Separate from Condition Score)

**Description**: Parallel notification system based on user-submitted reports, independent from automated environmental scoring.

**Rationale**: User reports of actual jubilee sightings or early warning signs are more reliable than environmental conditions alone, but should not corrupt the objective Condition Score.

**User Story**:
> As a veteran watcher, when I see eels swimming on the surface at my dock, I want to quickly alert the community and trigger escalating verification from nearby users.

**Acceptance Criteria**:
- [ ] "Submit Report" button prominently placed on Dashboard
- [ ] Report submission takes <30 seconds
- [ ] Community Alert Level displayed separately from Condition Score:
  - QUIET: No active reports
  - WATCH: Unverified early signs
  - CONFIRMED: Verified jubilee in progress
- [ ] Alert escalation logic:
  - 1 report from verified watcher (reputation >70) → WATCH status → push notification to users within 5 miles
  - 3 reports from any users within 30 minutes → WATCH status
  - 2 verified watchers OR 5 total users report full jubilee → CONFIRMED status → push to all opted-in users
- [ ] Users can "verify" nearby reports (within 2 miles) with thumbs up/down
- [ ] False reports decrease reporter reputation; verified reports increase it

**Report Submission Flow**:
1. User taps "Submit Report" on Dashboard
2. App auto-fills current location (user can adjust)
3. User selects report type:
   - 🔴 Full Jubilee (fish/crabs in shallows)
   - 🟡 Early Warning Signs (eels on surface, baby flounder)
   - 🟢 All Clear (no activity)
4. User selects species if applicable (multi-select)
5. User rates intensity (1-5 scale)
6. User adds optional photo/description
7. User confirms "I am at this location now"
8. Report submitted → triggers alert logic on backend
9. Nearby users receive push: "Unverified early signs reported at Point Clear - 0.3 miles from you. Can you verify?"

**Success Metrics**:
- 80%+ of full jubilee reports verified within 30 minutes
- <10% false positive rate (reports not verified)
- Average report submission time <45 seconds

**Dependencies**:
- P0-3: JubileeReport data model
- P0-2: Backend push notification service

**Technical Notes**:
- Use CoreLocation for automatic positioning
- Implement photo compression before upload
- Store reports in backend database with geospatial indexing
- Anti-spam: Max 5 reports per user per hour

---

#### P1-3: Interactive Map with Live Reports

**Description**: MapKit-based view showing Mobile Bay geography with overlay of current reports, webcam locations, and monitoring stations.

**User Story**:
> As a jubilee enthusiast, I want to see exactly where jubilees are being reported in real-time, so I can decide which beach to drive to at 2 AM.

**Acceptance Criteria**:
- [ ] Map centered on Mobile Bay Eastern Shore (Point Clear to Daphne)
- [ ] Custom map markers for:
  - 🔴 Active jubilee reports (last 2 hours)
  - 🟡 Early warning reports (last 4 hours)
  - 📷 Webcam locations (with live status indicator)
  - 🌊 Environmental monitoring stations
  - 👤 User location (if permission granted)
- [ ] Tap marker to see report details in bottom sheet:
  - Reporter name (or anonymous)
  - Timestamp (e.g., "23 minutes ago")
  - Report type and intensity
  - Species reported
  - Photos if available
  - Verification status (3/5 users confirmed)
  - "Verify" button (if user within 2 miles)
- [ ] Toggle layers on/off (Reports, Webcams, Stations)
- [ ] Cluster markers when zoomed out
- [ ] Offline map tiles cached for Eastern Shore region

**Map View UI**:
```
┌─────────────────────────────────────┐
│ [<] Map            [Layers] [●]     │
├─────────────────────────────────────┤
│                                      │
│         Mobile Bay                   │
│                                      │
│    🔴 ← Point Clear                 │
│                                      │
│      🟡 ← Fairhope                  │
│             👤                       │
│                                      │
│          📷 ← Daphne                │
│                                      │
│  [Current Location ⊙]               │
└─────────────────────────────────────┘
│ ┌─────────────────────────┐         │
│ │ 🔴 Point Clear           │         │
│ │ Full Jubilee - High      │         │
│ │ Flounder, Crabs          │         │
│ │ 23 min ago • 3/5 verified│         │
│ │ [View Details →]         │         │
│ └─────────────────────────┘         │
└─────────────────────────────────────┘
```

**Success Metrics**:
- Map accessed by 70%+ of users checking reports
- <5% of users report difficulty finding their location

**Dependencies**:
- P1-2: Report data with geolocation
- P0-3: Location data model

**Technical Notes**:
- Use MapKit for native iOS maps
- Implement geofencing for "nearby" verification (2-mile radius)
- Cache offline map tiles using MKTileOverlay
- Custom annotation views for different marker types
- Accessibility: List view alternative for screen readers

---

#### P1-4: Community Architecture (Chat + Discussion Boards)

**Description**: Dual community system with real-time event-based chat for active jubilees AND persistent discussion boards for planning, history, and community building.

**Rationale**: Event-based chat handles urgent real-time coordination during jubilees, while discussion boards foster long-term community engagement, knowledge sharing, and watch party planning.

**User Stories**:
> As someone at the beach during a confirmed jubilee, I want to chat with others nearby about what's happening in real-time, without wading through off-topic conversations.

> As a veteran watcher, I want to share stories and photos from memorable jubilees over the years, so the history and culture are preserved for future generations.

> As someone who can't stay up all night, I want to coordinate with others to take shifts checking the beach during favorable conditions, so we don't all lose sleep every night.

---

**PART A: Event-Based Live Chat**

**Acceptance Criteria**:
- [ ] Chat room automatically created when:
  - Community Alert Level reaches CONFIRMED
  - Scoped to geographic cluster of reports (e.g., "Point Clear - Aug 15, 2:34 AM")
- [ ] Chat room visible to:
  - Users within 10 miles of event
  - Users who opted in to event notifications
- [ ] Chat features:
  - Text messages only (photos via discussion boards)
  - User avatar and reputation score displayed
  - Timestamp on each message
  - Message limit: 500 characters
  - Rate limit: 1 message per 10 seconds
- [ ] Chat automatically archives 6 hours after last report in that cluster
- [ ] Archived chats viewable in "Past Events" section (read-only)
- [ ] Flag system: 3 flags hides message pending moderator review
- [ ] Block user functionality
- [ ] Push notifications for chat messages: OFF by default

**Chat Room UI**:
```
┌─────────────────────────────────────┐
│ 💬 Point Clear Jubilee LIVE         │
│ Aug 15, 2:34 AM • 12 active          │
├─────────────────────────────────────┤
│                                      │
│ Doris ⭐️85 • 2:37 AM                │
│ Huge run of flounder right now!      │
│ Better than July 12 event            │
│                                      │
│ Marcus 👤67 • 2:38 AM                │
│ Heading over now - still going?      │
│                                      │
│ Sarah 🆕22 • 2:39 AM                 │
│ First jubilee! What size net?        │
│                                      │
├─────────────────────────────────────┤
│ [Type message...]          [Send →] │
└─────────────────────────────────────┘
```

---

**PART B: Discussion Boards**

**Acceptance Criteria**:
- [ ] Board categories accessible via dedicated "Community" tab:
  - **📅 Watch Coordination** - Organize overnight watch parties
  - **📸 Jubilee Stories & Photos** - Share memories, historical photos
  - **❓ New User Questions** - Safe space for beginners
  - **🔬 Science & Research** - Discuss patterns, conditions, data
  - **📜 History & Culture** - Preserving 150+ years of tradition
  - **⚖️ Regulations & Ethics** - Fishing rules, best practices
- [ ] Thread features:
  - Create new thread (title + initial post)
  - Reply to threads (nested up to 2 levels)
  - Upvote/downvote posts
  - Pin important threads (moderators only)
  - Lock threads (moderators only)
  - Photo/video attachments (max 5 per post)
  - Tag users with @ mentions
- [ ] Sort options: Recent Activity, Most Popular, Oldest First
- [ ] Filter options: Unanswered Questions, Has Photos, My Posts
- [ ] Push notifications (opt-in):
  - Replies to your posts
  - Mentions of your username
  - New posts in followed threads
- [ ] Rich text formatting:
  - Bold, italic, links
  - Bullet lists
  - Quote blocks
  - No HTML (prevent XSS)

**Watch Coordination Enhanced Features**:
- [ ] Structured "Watch Party" post type with fields:
  - Date range (e.g., "Aug 10-15")
  - Location (Point Clear, Fairhope, etc.)
  - Time slots (e.g., "12AM-2AM, 2AM-4AM, 4AM-6AM")
  - RSVP system (claim a time slot)
  - Check-in system (post report after your shift)
- [ ] Visual schedule showing who's watching when
- [ ] Reminder notifications 1 hour before your shift
- [ ] Easy report submission directly from watch party thread

**Discussion Board UI**:
```
┌─────────────────────────────────────┐
│ 📋 Community                         │
│ [Boards ▼] [New Post +]             │
├─────────────────────────────────────┤
│ 📅 Watch Coordination                │
│ ├─ 📌 Point Clear Watch: Aug 12-15  │
│ │   12 participants • 3 hours ago    │
│ ├─ Fairhope overnight: Tonight?     │
│ │   5 replies • 23 min ago           │
│                                      │
│ 📸 Jubilee Stories & Photos          │
│ ├─ My grandmother's jubilee - 1952  │
│ │   🖼️ 3 photos • 47 replies         │
│ ├─ 🔥 Best catch ever? Share yours! │
│ │   89 replies • 2 days ago          │
│                                      │
│ ❓ New User Questions                │
│ ├─ What's the best beach for...     │
│ │   8 replies • 1 hour ago           │
└─────────────────────────────────────┘
```

**Watch Party Post UI**:
```
┌─────────────────────────────────────┐
│ 📅 Point Clear Watch Party           │
│ Posted by Doris ⭐️85                │
│ Aug 10-15 • Point Clear Pier         │
├─────────────────────────────────────┤
│ Conditions looking good this week!   │
│ Let's coordinate watches so we       │
│ don't all stay up every night.       │
│                                      │
│ 🗓️ SCHEDULE                          │
│ ┌─────────────────────────────────┐ │
│ │ Aug 12                           │ │
│ │ 12AM-2AM: Marcus ✓               │ │
│ │ 2AM-4AM: [Claim Slot]            │ │
│ │ 4AM-6AM: Sarah ✓                 │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ Aug 13                           │ │
│ │ 12AM-2AM: [Claim Slot]           │ │
│ │ 2AM-4AM: [Claim Slot]            │ │
│ │ 4AM-6AM: Doris ✓                 │ │
│ └─────────────────────────────────┘ │
│                                      │
│ [Claim a Slot] [Join Watch Party]   │
│                                      │
│ 💬 12 Comments                       │
└─────────────────────────────────────┘
```

**Success Metrics**:
- **Live Chat**: 50%+ of confirmed jubilees generate chat activity, <5% moderation rate
- **Discussion Boards**: 
  - 30+ new threads created per month during season
  - 60% of new users post at least once
  - Watch Coordination threads: 10+ active watch parties per month
  - Photo threads: 100+ historical photos shared in first year
- Average time in Community section: 12+ minutes per session

**Dependencies**:
- P1-2: Community Alert System triggers live chat creation
- P0-3: User reputation system
- P0-2: Backend database for discussion threads/posts

**Technical Notes**:
- **Live Chat**: Firebase Realtime Database (real-time sync)
- **Discussion Boards**: Firestore (better querying for threads)
- Photo uploads: Compress to <1MB, store in Cloud Storage
- Implement image content moderation (NSFW detection)
- Rate limiting: 10 posts per hour, 30 replies per hour
- Archive old threads after 1 year (read-only)

---

#### P1-5: Smart Push Notifications

**Description**: Customizable notification system that alerts users based on Condition Score thresholds, Community Alert Level, and geographic preferences.

**User Story**:
> As a working parent, I want to be woken up at 2 AM only when there's a high likelihood of a jubilee near my preferred beach, not every time conditions are marginally favorable.

**Acceptance Criteria**:
- [ ] Notification preferences accessible via Settings screen
- [ ] Customizable thresholds:
  - Condition Score minimum (slider: 0-100, default 75)
  - Community Alert Level (toggle: Watch, Confirmed)
  - Time window (allow overnight notifications: YES/NO)
  - Geographic radius (1, 3, 5, 10 miles from saved locations)
- [ ] Notification types:
  - 🟠 Condition Score threshold reached
  - 🔴 Community Alert: Confirmed jubilee
  - 🟡 Community Alert: Watch status
  - 💬 Chat message (OFF by default)
- [ ] Rich notifications with actions:
  - "View Dashboard"
  - "Open Map"
  - "Snooze 30 min"
- [ ] Quiet hours respect iOS Focus modes
- [ ] Test notification button to verify settings

**Notification Examples**:
```
🟠 JubileeHub
Conditions Highly Favorable (Score: 82)
Point Clear area • Rising tide at 3:14 AM
[View Dashboard] [Snooze]

🔴 JubileeHub  
JUBILEE CONFIRMED - Point Clear
5 reports in last 20 min • 0.8 mi away
[Open Map] [View Chat]
```

**Success Metrics**:
- 85%+ of users enable notifications
- <15% notification opt-out rate after first month
- Notification open rate: >40%

**Dependencies**:
- P0-2: Backend push notification infrastructure
- P1-1: Condition Score algorithm

**Technical Notes**:
- Use UNUserNotificationCenter for local + remote notifications
- Implement notification grouping for multiple alerts
- Respect system notification settings
- Badge icon shows unread Community Alerts count
- Accessibility: Haptic feedback for critical alerts

---

#### P1-6: User Profiles & Reputation System

**Description**: Basic user profile with reputation scoring based on report accuracy and community contributions.

**User Story**:
> As a community member, I want to know which users consistently provide accurate reports, so I can weigh their sightings more heavily when deciding whether to head to the beach.

**Acceptance Criteria**:
- [ ] User profile displays:
  - Username and profile photo (optional)
  - Reputation score (0-100) with badge
  - Total reports submitted
  - Verification rate (verified reports / total reports)
  - Member since date
  - Favorite locations
  - "Verified Watcher" badge (reputation >70)
- [ ] Reputation calculation:
  - +5 points: Report verified by 3+ users
  - +2 points: Report verified by 1-2 users
  - 0 points: No verification data (neutral)
  - -3 points: Report disputed by 3+ users
  - -10 points: Report flagged and confirmed false by moderator
  - Cap: 0-100 range
- [ ] Profile editing:
  - Upload photo
  - Change username (once per 30 days)
  - Set favorite locations (max 5)
  - Bio (150 characters)
- [ ] Privacy settings:
  - Show profile to: Everyone / Followers / Nobody
  - Show reputation score: YES/NO

**Profile UI**:
```
┌─────────────────────────────────────┐
│       [Photo]                        │
│       Doris                          │
│     ⭐️ Verified Watcher             │
│                                      │
│  Reputation: 85  🏆                  │
│  ▓▓▓▓▓▓▓▓▓░ 85%                     │
│                                      │
│  📊 Stats                            │
│  • 127 reports submitted             │
│  • 94% verification rate             │
│  • Member since Jun 2026             │
│                                      │
│  📍 Favorite Locations               │
│  • Point Clear Public Beach          │
│  • Fairhope Pier                     │
│                                      │
│  [Edit Profile]                      │
└─────────────────────────────────────┘
```

**Success Metrics**:
- 60%+ of users upload profile photo
- Users with reputation >70 have 90%+ verification rate
- <5% reputation disputes

**Dependencies**:
- P0-3: User data model
- P1-2: Report verification system

**Technical Notes**:
- Store profile photos in CloudKit
- Implement reputation decay (10% annually to require ongoing accuracy)
- Moderator tools to manually adjust reputation for abuse
- Accessibility: Alt text for profile photos

---

### P2: Enhanced Features (Fall 2026)

#### P2-1: Advanced Map Features

**Description**: Enhanced mapping with historical heatmaps, wind direction overlay, and offline capabilities.

**User Story**:
> As a data-driven watcher, I want to see where jubilees have historically occurred most frequently, so I can strategically choose my observation location.

**Acceptance Criteria**:
- [ ] Historical heatmap toggle showing jubilee frequency by location (past 3 years)
- [ ] Wind direction visualization (animated arrows)
- [ ] Water temperature gradient overlay (if sensor data available)
- [ ] Offline map download for Eastern Shore (reduce data usage at beach)
- [ ] 3D terrain view showing bay bathymetry
- [ ] "Best spots" algorithm based on historical success rate

**Success Metrics**:
- Heatmap accessed by 40%+ of users
- Offline maps downloaded by 30%+ of users

---

#### P2-2: Enhanced Community Features

**Description**: Advanced social features including direct messaging, follower system, and community leaderboards.

**User Story**:
> As a newcomer, I want to follow experienced watchers and ask them questions privately, so I can learn without cluttering public discussions.

**Acceptance Criteria**:
- [ ] **Follow System**:
  - "Follow" button on user profiles
  - Follower/following counts visible
  - Following feed showing recent activity from followed users (reports, posts)
  - Push notifications for follower activity (opt-in)
  
- [ ] **Direct Messaging**:
  - Text only (no photos - use discussion boards)
  - 1000 character limit per message
  - Conversation view with threading
  - Block user functionality
  - Report abuse button
  - Message history stored for 30 days
  - Notification preferences for DMs
  
- [ ] **Enhanced Watch Coordination**:
  - Automatic reminders sent to watch party participants
  - Weather forecast integration in watch party posts
  - Export watch schedule to iOS Calendar
  - "Quick Report" button during assigned shift
  
- [ ] **Community Highlights**:
  - Weekly digest of top discussions
  - Featured historical photos rotation
  - "Veteran Spotlight" profiles
  - Monthly jubilee summary statistics

**Success Metrics**:
- Average user follows 5+ other users
- 20% of users send/receive at least 1 DM per month
- Watch party participation increases 30% over P1

**Dependencies**:
- P1-4: Discussion board infrastructure
- P1-6: User profiles and follower foundation

---

#### P2-3: Curated Webcam Directory

**Description**: Organized directory of links to public webcams showing Mobile Bay, with user-submitted suggestions.

**Rationale**: Embedding webcam streams in MVP creates legal, privacy, and technical risks. Curated links provide value while offloading infrastructure costs.

**User Story**:
> As someone without waterfront property, I want to remotely check water conditions via public webcams before driving to the beach at midnight.

**Acceptance Criteria**:
- [ ] Curated list of verified public webcams:
  - Local news stations
  - Government/NOAA cams
  - Marina cams
  - Public park cams
- [ ] Webcam information displayed:
  - Location on map
  - Provider (e.g., "WKRG News 5")
  - View description ("Eastern Shore looking west")
  - Last verified date
  - Link to external stream
- [ ] User suggestion system:
  - Submit webcam URL for review
  - Moderator approval workflow
  - Requires permission documentation
- [ ] Favorite webcams saved to profile
- [ ] "Open in Safari" for each webcam link

**Success Metrics**:
- 10+ verified webcams in directory
- 40%+ of users access webcam links

**Technical Notes**:
- No embedded streaming in P2
- Link validation: Check URL returns 200 status
- Update verification dates quarterly

---

#### P2-4: Direct Messaging & Follower System

**Description**: Allow users to follow veteran watchers and receive direct messages for mentorship.

**User Story**:
> As a newcomer, I want to follow experienced watchers and ask them questions privately, so I can learn without cluttering public discussions.

**Acceptance Criteria**:
- [ ] "Follow" button on user profiles
- [ ] Follower/following counts visible
- [ ] Following feed showing recent reports from followed users
- [ ] Direct messaging:
  - Text only
  - 1000 character limit
  - Block user functionality
  - Report abuse button
- [ ] Notification preferences for DMs
- [ ] Message history stored for 30 days

**Success Metrics**:
- Average user follows 5+ other users
- 20% of users send/receive at least 1 DM

---

### P3: Future Features (2027+)

#### P3-1: Comprehensive Educational Library

**Description**: Multimedia educational content about jubilee science, culture, history, and responsible fishing.

**Acceptance Criteria**:
- [ ] "What is a Jubilee?" interactive guide with:
  - Video explainer (3-5 minutes)
  - Animated science visualization (oxygen depletion, stratification)
  - Historical timeline (1867 to present)
  - Cultural significance stories
  - Interviews with veteran watchers
- [ ] Species identification guide:
  - Photos of flounder, blue crabs, shrimp, eels
  - Size measurement tutorials
  - Distinguishing similar species
- [ ] Regulations guide:
  - Alabama fishing license requirements
  - Size and creel limits
  - Seasonal restrictions
  - Penalties for violations
  - How to measure fish properly
- [ ] Jubilee etiquette handbook:
  - Unwritten rules
  - Respecting others
  - Environmental stewardship
  - Safety tips
- [ ] Historical archive:
  - Notable jubilees through decades
  - Newspaper clippings (1867 article)
  - Family stories and oral histories

**Success Metrics**:
- 80% of new users complete "What is a Jubilee?" guide
- Educational content accessed 10,000+ times in first year

---

#### P3-2: Advanced Analytics & Data Export

**Description**: Personal jubilee logs, pattern recognition, and researcher data export tools.

**Acceptance Criteria**:
- [ ] Personal jubilee log:
  - Record jubilees attended
  - Catch notes (species, quantity)
  - Photos
  - Conditions at time of event
  - Exportable to PDF/CSV
- [ ] Pattern recognition suggestions:
  - "You typically report jubilees when score >78"
  - "Your area sees most jubilees in August"
  - "Full moon correlation: 60% of your reports"
- [ ] Historical data browser:
  - Chart jubilee frequency by year
  - Seasonal patterns
  - Correlation with environmental factors
- [ ] Researcher data export:
  - API access for verified researchers
  - Anonymized aggregate data
  - CSV/JSON export options
  - Timestamped, geolocated reports

**Success Metrics**:
- 30% of regular users maintain personal logs
- 5+ research institutions use exported data

---

#### P3-3: Carefully Designed Gamification

**Description**: Recognition system that celebrates community contributions without trivializing the cultural tradition.

**Rationale**: Gamification must enhance, not replace, intrinsic motivation and respect for tradition.

**Acceptance Criteria**:
- [ ] Achievement badges:
  - "First Jubilee" (attended 1 event)
  - "Early Riser" (submitted report before 3 AM)
  - "Veteran Watcher" (reputation >70)
  - "Community Champion" (50+ verified reports)
  - "Educator" (completed all educational content)
  - "Season Veteran" (active for 3+ consecutive seasons)
- [ ] Annual "Jubilee Yearbook":
  - Community highlights
  - Most active reporters
  - Best photos
  - Biggest catches (self-reported)
  - Milestone celebrations
- [ ] **NO competitive leaderboards** (avoid gaming the system)
- [ ] **NO point systems** (keep focus on contribution quality)
- [ ] **NO virtual rewards** (keep focus on real jubilee experience)

**Success Metrics**:
- 70% of users earn at least one badge
- Positive community sentiment (survey: 8/10)

---

## 📱 User Flows

### Primary User Flow: Veteran Watcher Detects & Reports Jubilee

**Trigger**: Veteran watcher walks to beach after midnight and sees early warning signs

**Steps**:
1. User notices eels swimming on water surface at dock (11:47 PM)
2. Opens JubileeHub app → Dashboard loads showing Condition Score: 68 (Favorable)
3. Taps "Submit Report" button
4. App auto-fills GPS location (Point Clear)
5. User selects "Early Warning Signs" report type
6. User selects species: "Eels"
7. User rates intensity: 3/5
8. User adds description: "Eels on surface at dock, more than usual"
9. User taps "Submit" → Report posted immediately
10. Backend receives report → evaluates against Community Alert logic
11. Reporter has reputation 85 (verified watcher) → triggers WATCH alert
12. Backend sends push notifications to users within 5 miles: "Early warning signs reported at Point Clear"
13. 3 nearby users receive notification and drive to area (12:15 AM)
14. 2 users verify report with thumbs up → Community Alert escalates to CONFIRMED
15. Event-based chat room automatically created
16. Full jubilee manifests at 1:34 AM
17. Users in chat room coordinate and share excitement
18. Original reporter's reputation increases by +5 points

**Success Outcome**: Community mobilized efficiently, veteran watcher recognized for accuracy, newcomers guided to correct location

**Error Handling**: 
- If GPS fails → user manually places pin on map
- If report submission fails → queued locally and retries
- If backend doesn't respond within 5 seconds → show "Submitted (pending confirmation)" message

---

### Secondary User Flow: Newcomer Learns & Experiences First Jubilee

**Trigger**: Tourist downloads app after hearing about jubilees

**Steps**:
1. User downloads JubileeHub from App Store
2. Opens app → sees onboarding screens:
   - Screen 1: "Welcome to JubileeHub - Experience Mobile Bay's Natural Wonder"
   - Screen 2: "What is a Jubilee?" (brief explainer with video link)
   - Screen 3: "We don't predict jubilees, but we help you understand conditions"
   - Screen 4: "Set your notification preferences"
   - Screen 5: Legal disclaimer acceptance
3. User creates account with email
4. User taps "Learn More About Jubilees" → opens educational content
5. Watches 3-minute explainer video
6. Reads regulations guide (fishing license requirements, size limits)
7. Returns to Dashboard → explores Condition Score breakdown
8. Taps Map view → sees Point Clear and Fairhope areas highlighted
9. Saves "Fairhope Pier" as favorite location
10. Sets notification preference: Score >75, Community Alert: Confirmed only
11. Browses Discussion Board → asks question: "What size dip net?"
12. Receives helpful replies from community members
13. Three days later (2:14 AM) → receives push notification: "JUBILEE CONFIRMED - Fairhope Pier (0.3 mi away)"
14. Rushes to beach with family, gig, and bucket
15. Joins event chat room → asks "Where exactly? First timer!"
16. Veteran watcher in chat directs user to specific area
17. User successfully gigs 3 flounder, fills bucket with crabs
18. After event, submits verification report with photos
19. Reputation increases from 0 to +7
20. Shares photos in Discussion Board "Photos & Stories" thread
21. Receives congratulations from community

**Success Outcome**: Newcomer educated, successfully participated, integrated into community, excited to return

---

### Tertiary User Flow: Researcher Exports Historical Data

**Trigger**: Marine biology PhD student studying hypoxia patterns

**Steps**:
1. Researcher discovers JubileeHub through marine science forum
2. Downloads app and creates account
3. Marks account type as "Researcher" during registration
4. Accesses "Advanced Analytics" (P3 feature)
5. Selects "Historical Data Browser"
6. Filters data: June 2026 - September 2027, All locations, All report types
7. Views charts showing:
   - Jubilee frequency by month
   - Correlation with Condition Score
   - Geographic clustering patterns
8. Taps "Export Data" → enters institutional email for verification
9. Receives download link via email (24-hour expiration)
10. Downloads CSV file with anonymized data:
   - Timestamps
   - GPS coordinates (rounded to 0.01° for privacy)
   - Environmental conditions at time of report
   - Report verification status
11. Uses data for PhD thesis analyzing relationship between salinity stratification and jubilee frequency
12. Cites JubileeHub as data source in publication
13. Shares findings with community via Discussion Board post

**Success Outcome**: Researcher gains valuable citizen science data, app gets academic credibility, community learns from research findings

---

## 🎨 Design & User Experience

### Design Principles

1. **Clarity Over Cleverness**: Information must be instantly comprehensible at 2 AM by tired users. No ambiguous icons, no hidden navigation.

2. **Respect for Tradition**: Modern design should enhance, not replace, the cultural heritage. Include nods to history through color palette inspired by dawn waters, fishing heritage imagery, and generational knowledge preservation.

3. **Dark Mode First**: Optimize for nighttime use when jubilees occur. Dark backgrounds reduce eye strain and battery consumption. Light mode available but secondary.

4. **Trust Through Transparency**: Never hide how the app works. Condition Score methodology, data sources, update times, and limitations must be clearly visible.

5. **Accessible to All Ages**: Veterans in their 70s and teenagers should both find the app intuitive. Large touch targets, high contrast, adjustable text size.

### Platform-Specific Guidelines

**iOS**:
- Follow iOS Human Interface Guidelines
- Use native SwiftUI components for familiar interactions
- Support iOS 17+ (required for SwiftData)
- Dark mode: Default ON with auto-switching disabled
- Light mode: Available via Settings, uses soft blues/whites
- Haptic feedback for critical actions (report submission, verification)
- Support for:
  - Dynamic Type (text scaling)
  - VoiceOver (screen reader)
  - Voice Control
  - Reduce Motion
  - High Contrast mode

### Color Palette

**Dark Mode (Default)**:
- Background: `#0A1628` (Deep midnight blue)
- Cards/Surfaces: `#1A2B42` (Slate blue)
- Primary Accent: `#FF6B35` (Jubilee orange - represents dawn)
- Secondary Accent: `#4ECDC4` (Teal - represents water)
- Success: `#2ECC71` (Green)
- Warning: `#F39C12` (Amber)
- Danger: `#E74C3C` (Red)
- Text Primary: `#FFFFFF`
- Text Secondary: `#B0BEC5`

**Light Mode (Optional)**:
- Background: `#F5F7FA` (Soft white)
- Cards/Surfaces: `#FFFFFF`
- Primary Accent: `#FF6B35`
- Secondary Accent: `#2C7A7B`
- Text Primary: `#1A202C`
- Text Secondary: `#4A5568`

### Typography

- **Primary Font**: SF Pro (iOS system font)
- **Headings**: Bold, 28-34pt
- **Body**: Regular, 17pt (iOS default for accessibility)
- **Captions**: Medium, 13pt
- **Minimum Interactive Size**: 44x44pt (Apple HIG)

### Accessibility Requirements

- [x] VoiceOver descriptions for all interactive elements
- [x] Semantic HTML equivalents in SwiftUI (accessibility labels)
- [x] Keyboard navigation support (for external keyboard users)
- [x] Color contrast ratios:
  - Normal text: 4.5:1 minimum (WCAG AA)
  - Large text (18pt+): 3:1 minimum
  - Interactive elements: 3:1 minimum
- [x] Text scaling support up to 200%
- [x] Alternative text for all images, icons, and map markers
- [x] Audio descriptions for educational videos (P3)
- [x] Captions for all video content
- [x] No reliance on color alone to convey information
  - Condition Score uses color + number + text label
  - Map markers use color + icon shape
- [x] Reduce Motion alternatives:
  - Static arrows instead of animated wind visualization
  - Crossfade instead of sliding transitions

---

## 🔧 Technical Requirements

### Platform & Technology

**Primary Platform**: iOS (iPhone and iPad)

**Minimum Version**: iOS 17.0

**Technology Stack**:

**Frontend (iOS App)**:
- SwiftUI (declarative UI framework)
- SwiftData (data persistence, iOS 17+)
- CloudKit (user preferences sync across devices)
- Combine (reactive programming for real-time updates)
- MapKit (native mapping)
- CoreLocation (GPS and geofencing)
- AVFoundation (future video playback for educational content)
- UserNotifications (push notifications)

**Backend (Serverless)**:
- AWS Lambda OR Google Cloud Functions (data aggregation, scoring)
- Node.js runtime for functions
- Firestore OR DynamoDB (NoSQL database)
  - Collections: Users, Reports, Conditions, Locations, ChatMessages
- Firebase Realtime Database (event-based chat)
- AWS S3 OR Google Cloud Storage (user photos)
- APNs (Apple Push Notification service)

**Third-Party Services**:
- NOAA Tides & Currents API
- NOAA Weather Service API
- OpenWeather API (backup)
- Sentry (crash reporting & error tracking)
- Google Analytics for Firebase (usage analytics)
- Mapbox (future enhanced maps, P2)

---

### Performance Requirements

**App Launch**:
- Cold start: <3 seconds to Dashboard
- Warm start: <1 second to Dashboard
- Background fetch: Every 15 minutes during season

**Screen Load Times**:
- Dashboard: <2 seconds (including API call)
- Map: <3 seconds (including marker rendering)
- Chat: <2 seconds (real-time connection)

**API Response Times**:
- Unified backend API: <1 second average, <2 seconds 95th percentile
- External APIs: <5 seconds (with local caching on timeout)

**Offline Capability**:
- Dashboard: Show last cached Condition Score (up to 2 hours stale)
- Map: Display offline base map tiles for Eastern Shore
- Reports: Queue submissions locally, sync when online
- Chat: Show "Connecting..." message, queue messages

**Battery Efficiency**:
- Background fetch: <2% battery drain per hour
- Active use: <10% battery drain per hour
- Location services: "When In Use" only (not "Always")

**Data Usage**:
- Initial app download: <50 MB
- Typical session: <5 MB
- Offline map cache: <20 MB
- Photo uploads: Auto-compress to <500 KB per image

---

### Data Requirements

**Data Models** (Core structures using SwiftData):

```swift
// User Model
@Model class User {
    @Attribute(.unique) var id: UUID
    var username: String
    var email: String
    var profileImageURL: String?
    var reputationScore: Int = 0
    var isVerifiedWatcher: Bool = false
    var notificationPreferences: NotificationPreferences
    @Relationship var favoriteLocations: [Location]
    var joinedDate: Date
    var totalReports: Int = 0
    var verifiedReports: Int = 0
    var totalVerifications: Int = 0
}

// Report Model
@Model class JubileeReport {
    @Attribute(.unique) var id: UUID
    var reporterID: UUID
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    var reportType: ReportType
    var species: [String]
    var intensity: Int // 1-5
    var description: String
    @Relationship var photos: [Photo]
    @Relationship var verifications: [Verification]
    var flagCount: Int = 0
    var status: ReportStatus
}

// Condition Model  
@Model class ConditionData {
    @Attribute(.unique) var id: UUID
    var timestamp: Date
    var conditionScore: Int
    var scoreBreakdown: ScoreBreakdown
    var weatherData: WeatherData
    var tideData: TideData
    var waterQualityData: WaterQualityData?
    var communityAlertLevel: AlertLevel
}
```

**Data Storage**:
- Local: SwiftData SQLite database (encrypted at rest)
- Cloud Sync: CloudKit for user preferences only
- Backend: Firestore/DynamoDB for all reports, conditions, chat
- Photos: Cloud storage with CDN (CloudFront/Cloud CDN)

**Data Retention**:
- User accounts: Indefinite (until user deletion)
- Reports: 3 years rolling window
- Condition history: 3 years rolling window
- Chat messages: 30 days, then archived/deleted
- Deleted user data: Permanently removed within 30 days

**Data Privacy**:
- GPS coordinates: Never shared publicly (rounded to 0.01° for researchers)
- User email: Never displayed to other users
- User photos: Uploaded with explicit consent
- Chat logs: Encrypted in transit and at rest
- Analytics: Anonymized, no PII
- Compliance: GDPR (right to deletion, data export), CCPA

---

### Security Requirements

**Authentication**:
- Email + password (Firebase Authentication)
- Password requirements: 8+ characters, mix of letters/numbers
- Password reset via email verification
- Session tokens: 30-day expiration
- Biometric authentication (Face ID/Touch ID) for app unlock

**Authorization**:
- Role-based access:
  - User: Can submit reports, chat, view data
  - Verified Watcher: Higher weight in alert escalation
  - Moderator: Can review flagged content, adjust reputation
  - Admin: Can access admin dashboard, export data
- Report editing: Only reporter can edit within 15 minutes
- Report deletion: Only admins (for violations)
- Chat room access: Geographic + notification opt-in based

**Data Encryption**:
- At rest: AES-256 encryption for local database
- In transit: TLS 1.3 for all API calls
- Photos: Encrypted in cloud storage
- Passwords: bcrypt hashing (never stored plaintext)

**API Security**:
- Rate limiting: 100 requests per user per hour
- API key rotation: Every 90 days
- Webhook signature verification for push notifications
- Input validation and sanitization (prevent injection attacks)

**Abuse Prevention**:
- CAPTCHA for account creation (prevent bots)
- Report spam detection (>5 reports in 1 hour triggers review)
- Chat message rate limiting (1 per 10 seconds)
- Photo upload scanning (NSFW content detection)
- IP-based blocking for abuse
- Account suspension workflow for violations

---

### Integration Requirements

**Required Integrations**:
- [x] NOAA Tides & Currents API (tide predictions, water levels)
- [x] NOAA Weather Service API (wind, temperature, precipitation)
- [x] OpenWeather API (backup weather data)
- [x] Firebase Authentication (user accounts)
- [x] Firebase Realtime Database (chat)
- [x] Cloud Storage (user photos)
- [x] APNs (push notifications)
- [x] Sentry (crash reporting)
- [x] Google Analytics (usage tracking)

**Optional Integrations (if available)**:
- [ ] NOAA CO-OPS water quality sensors (salinity, dissolved oxygen)
- [ ] Mobile Bay National Estuary Program data feeds
- [ ] USGS Water Data Services (river discharge)
- [ ] Alabama Marine Resources Division public APIs

**Integration Health Monitoring**:
- Uptime checks every 5 minutes for critical APIs
- Alert to admin if API down >15 minutes
- Automatic failover to backup weather API
- User-facing error messages: "Weather data temporarily unavailable"

---

## 📊 Success Metrics & KPIs

### Launch Metrics (First Summer Season: June-Sept 2026)

| Metric | Target | Measurement |
|--------|--------|-------------|
| App Downloads | 1,000 | App Store Connect |
| Active Users (MAU) | 500 | Firebase Analytics |
| Daily Active Users (Peak) | 150 | Firebase Analytics |
| Avg Session Duration | 8 minutes | Firebase Analytics |
| Day 7 Retention | 50% | Firebase Analytics |
| Day 30 Retention | 35% | Firebase Analytics |
| Notification Opt-in Rate | 85% | Backend database |
| Profile Completion Rate | 60% | Backend database |

### Product Metrics (Ongoing)

| Metric | Target | Measurement |
|--------|--------|-------------|
| Jubilee Report Accuracy | 80% verified | Backend: verifications/reports |
| Alert Response Time | <5 min to first verification | Timestamp analysis |
| Community Engagement | 40% users in chat/discussion | Firebase Analytics |
| Map Usage | 70% of sessions access map | Firebase Analytics |
| Condition Score Reliability | 75% correlation with actual jubilees | Manual validation |
| Educational Content Completion | 80% of new users | Firebase Analytics |
| False Positive Rate | <15% | Manual review |
| User-Reported Bugs | <10 per month | Sentry |

### Quality Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| App Crash Rate | <0.5% | Sentry |
| API Error Rate | <2% | Backend logs |
| Push Notification Delivery | >95% | APNs delivery reports |
| Average API Response Time | <1 second | Backend monitoring |
| Bug Resolution Time (P0) | <24 hours | Issue tracker |
| Bug Resolution Time (P1) | <1 week | Issue tracker |
| Test Coverage | ≥70% | XCTest reports |
| Lighthouse Performance Score | ≥90 | N/A (iOS only) |
| Accessibility Audit Score | 100% compliance | Manual audit |

### Community Health Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Content Moderation Rate | <5% messages flagged | Backend: flags/total messages |
| User Block Rate | <3% | Backend: blocks/total users |
| Toxic Behavior Reports | <10 per month | Moderation dashboard |
| Average Reputation Score | 60 | Backend: avg(user.reputation) |
| Verified Watcher Growth | 20% of active users | Backend: verified badges |
| Positive Sentiment | >80% | In-app surveys (quarterly) |

---

## 🗓️ Timeline & Milestones

### Phase 0: Foundation (Nov 2025 - Jan 2026) - 3 months

**Goal**: Validate data sources, finalize architecture, and prepare infrastructure.

- [x] PRD finalized and approved
- [ ] **CRITICAL**: Validate NOAA water quality sensor availability for Mobile Bay
  - If unavailable: Document alternative approach or Phase 2 sensor deployment plan
- [ ] Architecture design document complete
- [ ] Technology stack confirmed (iOS 17, SwiftUI, Firebase, AWS/GCP)
- [ ] Project repository initialized
- [ ] Backend serverless functions scaffolded
- [ ] Database schema designed
- [ ] API integrations tested (NOAA Weather, Tides, etc.)
- [ ] Legal review: Terms of Service, Privacy Policy, disclaimers
- [ ] App Store Developer account setup
- [ ] Design system & style guide created (Figma)
- [ ] High-fidelity mockups approved
- [ ] User testing plan defined

**Deliverables**:
- Architecture Design Document
- API Integration Test Report
- Legal Documentation (TOS, Privacy Policy)
- Design System & Mockups
- Backend Scaffolding

---

### Phase 1: MVP Development (Feb 2026 - May 2026) - 4 months

**Goal**: Build and launch core features for Summer 2026 jubilee season.

**Month 1-2 (Feb-Mar): Core Infrastructure**
- [ ] SwiftUI app shell with tab navigation
- [ ] SwiftData models implemented (User, Report, Condition, Location)
- [ ] CloudKit integration for user sync
- [ ] Backend API endpoints built:
  - GET /conditions (current score + data)
  - POST /reports (submit report)
  - GET /reports (fetch nearby reports)
  - POST /verify (verify report)
- [ ] Serverless cron job for data aggregation (15-min interval)
- [ ] Condition Score algorithm v2.0 implemented (rule-based)
- [ ] Push notification infrastructure (APNs)

**Month 3 (April): Feature Development**
- [ ] P1-1: Conditions Dashboard UI complete
- [ ] P1-2: Community Alert System with escalation logic
- [ ] P1-3: Interactive Map with live markers
- [ ] P1-4: Community Architecture:
  - Event-based live chat (Firebase Realtime Database)
  - Discussion board system (Firestore)
  - 6 board categories with threading
  - Watch Party coordination structure
  - Photo upload and moderation
- [ ] P1-5: Smart push notifications with preferences
- [ ] P1-6: User profiles & reputation system
- [ ] Onboarding flow (5 screens)
- [ ] Settings screen
- [ ] Content moderation tools and admin dashboard

**Month 4 (May): Testing & Launch Prep**
- [ ] Internal alpha testing (team + 10 volunteers)
- [ ] Bug fixes and UI polish
- [ ] Accessibility audit (VoiceOver testing)
- [ ] Performance optimization (app launch <3s)
- [ ] TestFlight beta (50 Eastern Shore residents)
- [ ] Beta feedback incorporation
- [ ] App Store submission (2 weeks before launch)
- [ ] Marketing materials (website, social media)
- [ ] PR outreach (local news, Alabama tourism)

**Launch: June 1, 2026** (Start of jubilee season)

**Deliverables**:
- MVP iOS app (v1.0) on App Store
- Backend services running in production
- Marketing website live
- User documentation & FAQs

---

### Phase 2: Enhancement & Growth (Sept 2026 - Dec 2026) - 4 months

**Goal**: Gather user feedback from first season and add advanced features.

**Post-Season Analysis (Sept)**
- [ ] User feedback surveys
- [ ] Analytics review (engagement, retention, accuracy)
- [ ] Bug prioritization
- [ ] Feature request ranking

**Development (Oct-Nov)**
- [ ] P2-1: Advanced Map Features (heatmap, wind overlay, offline)
- [ ] P2-2: Discussion Boards & Watch Coordination
- [ ] P2-3: Curated Webcam Directory
- [ ] P2-4: Direct Messaging & Follower System
- [ ] Performance improvements based on Summer 2026 data
- [ ] Bug fixes and UX refinements

**Launch: December 2026** (v1.5 update)

**Deliverables**:
- App update (v1.5) with P2 features
- First season retrospective report
- Improved Condition Score algorithm (if needed)

---

### Phase 3: Long-term Vision (2027+)

**Goal**: Establish JubileeHub as definitive jubilee resource and research platform.

**2027 Roadmap**:
- [ ] P3-1: Comprehensive Educational Library
- [ ] P3-2: Advanced Analytics & Data Export
- [ ] P3-3: Carefully Designed Gamification
- [ ] Android version (if demand exists)
- [ ] Web dashboard for researchers
- [ ] Partnership with universities for sensor network deployment
- [ ] Integration with Alabama Marine Resources for fishing license verification
- [ ] Multi-language support (Spanish for coastal communities)

**Ongoing** (Every Summer Season):
- Algorithm improvements based on previous season data
- Community events (annual "Jubilee Fest" meetup)
- Educational partnerships with schools
- Research collaborations with marine science departments

---

## ⚠️ Risks & Constraints

### Technical Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| **Critical water quality sensors don't exist in Mobile Bay** | High | Critical | **P0 validation task**. If unavailable: (1) Partner with Mobile Bay NEP to deploy sensors in Phase 2, or (2) Launch with reduced score components and clearly communicate limitations. Mark water quality as "N/A" in Dashboard. |
| **External API downtime during peak jubilee** | Medium | High | (1) Implement circuit breakers and retries, (2) Cache last-known-good data for 2 hours, (3) Use backup weather APIs, (4) Graceful degradation: show "Data temporarily unavailable" without crashing |
| **Push notification delivery failures** | Medium | High | (1) Test APNs thoroughly in beta, (2) Implement delivery confirmation tracking, (3) Provide in-app alert history as backup, (4) Allow users to manually check Dashboard |
| **Database scalability issues** | Low | High | (1) Use managed database services (Firestore/DynamoDB) with auto-scaling, (2) Implement read replicas, (3) Optimize queries with indexing, (4) Load test before season |
| **MapKit performance with 100+ markers** | Medium | Medium | (1) Implement marker clustering, (2) Virtualize off-screen markers, (3) Limit visible markers to 50 (prioritize recent/nearby), (4) Provide list view alternative |
| **Community moderation workload overwhelming** | Medium | High | (1) Automated profanity filtering and NSFW image detection, (2) Community-powered flagging (3 flags = hidden), (3) Reputation system discourages bad actors, (4) Hire part-time moderator ($500/month) starting at launch, (5) Empower high-reputation users as volunteer moderators (P2), (6) Clear code of conduct with escalating consequences |
| **Photo storage costs exceeding budget** | Medium | Medium | (1) Aggressive image compression (<500 KB), (2) CDN caching, (3) Limit uploads (5 photos per report), (4) Monthly cost monitoring with alerts |

---

### Business Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| **Low user adoption (Facebook groups preferred)** | Medium | High | (1) Clear value proposition: data-driven + organized vs. fragmented FB, (2) Partner with influential veteran watchers for endorsements, (3) Cross-post in FB groups initially to drive downloads, (4) Offer features FB lacks (maps, condition monitoring) |
| **Liability lawsuit from jubilee-related accident** | Low | Critical | (1) Comprehensive legal disclaimers (no predictions guaranteed), (2) Prominent safety warnings (check tides, wear life jackets), (3) Business liability insurance, (4) Terms of Service with arbitration clause |
| **Negative PR from inaccurate Condition Scores** | Medium | High | (1) Always use "Conditions Score" not "Prediction", (2) Educational content explaining limitations, (3) User testimonials showing it's a tool, not oracle, (4) Track accuracy and improve algorithm iteratively |
| **Community toxicity/harassment** | Medium | Medium | (1) Clear code of conduct, (2) Zero-tolerance policy for harassment, (3) Active moderation, (4) Easy block/report tools, (5) Positive community role models (verified watchers) |
| **Regulatory pushback from Alabama Marine Resources** | Low | Medium | (1) Proactive outreach to AL Marine Resources before launch, (2) Prominent display of regulations, (3) Offer to share data for enforcement, (4) Position app as education tool |
| **Insufficient funding for ongoing operations** | Medium | High | (1) Lean serverless architecture (minimize fixed costs), (2) Explore sponsorships (local businesses, conservation groups), (3) Optional premium features (offline maps, ad-free), (4) Grant applications (environmental education, citizen science) |

---

### Constraints

**Budget**:
- Development: $60,000 (contract developers + design, increased for community features)
- Infrastructure: $3,000/year (AWS/GCP, Firebase, storage - increased for chat/discussion boards)
- Legal: $3,000 (TOS, privacy policy, incorporation)
- Marketing: $2,000 (website, social media ads)
- Moderation: $6,000/year (part-time community moderator)
- **Total Year 1**: ~$74,000

**Timeline**:
- **Hard Deadline**: June 1, 2026 (start of jubilee season)
- No flexibility - missing season means waiting entire year
- Requires 7 months (Nov 2025 - May 2026)

**Resources**:
- 1 Product Manager (part-time)
- 2 iOS Developers (full-time, 6 months)
- 1 Backend Developer (full-time, 5 months) - *increased from 4 months due to discussion board infrastructure*
- 1 UI/UX Designer (contract, 2 months)
- 1 QA Tester (contract, 1.5 months) - *increased for community feature testing*
- 1 Community Moderator (part-time, ongoing post-launch)
- Legal counsel (contract)

**Technical**:
- iOS only (no Android budget in Phase 1)
- iOS 17+ minimum (limits audience to newer devices, but required for SwiftData)
- Serverless-only backend (no dedicated servers due to cost)
- No embedded video streaming for webcams (bandwidth cost)
- No real-time video calls (complexity + cost)

---

## 📄 Dependencies & Integrations

### External Dependencies

**Critical (Launch Blockers)**:
- [x] **NOAA Tides & Currents API**: Tide predictions for Mobile Bay
  - Required for: Condition Score (tide phase component)
  - SLA: 99% uptime (NOAA reliability)
  - Cost: Free (government API)
  - Backup: None (manual tide tables as last resort)
  
- [x] **NOAA Weather Service API**: Wind speed/direction, temperature
  - Required for: Condition Score (wind, temperature components)
  - SLA: 99% uptime
  - Cost: Free
  - Backup: OpenWeather API (paid tier)

- [x] **Apple Push Notification Service (APNs)**: Notifications
  - Required for: Alert system
  - SLA: 99.9% (Apple guarantee)
  - Cost: Free
  - Backup: In-app alert history

**Important (Enhanced Features)**:
- [ ] **NOAA CO-OPS Water Quality**: Salinity, water temperature, dissolved oxygen
  - Required for: Enhanced Condition Score
  - **Status: PENDING VALIDATION (P0 task)**
  - If unavailable: Launch without this component, deploy sensors in Phase 2

- [x] **Firebase Authentication**: User accounts
  - Required for: Login, user management
  - SLA: 99.95%
  - Cost: Free tier (up to 10k MAU), then $0.0055/MAU

- [x] **Firebase Realtime Database**: Chat infrastructure
  - Required for: Event-based chat
  - SLA: 99.95%
  - Cost: $5/GB stored, $1/GB downloaded

- [x] **Cloud Storage (AWS S3 or Google Cloud)**: User photos
  - Required for: Report photos
  - SLA: 99.99%
  - Cost: $0.023/GB stored, $0.09/GB transferred

**Optional (Nice-to-Have)**:
- [ ] **Mobile Bay National Estuary Program**: Water quality data
  - Status: Investigate availability
  - Use case: Supplement NOAA data
  
- [ ] **USGS Water Data Services**: River discharge
  - Use case: Advanced algorithm (freshwater input affects stratification)

### Internal Dependencies

**Team Dependencies**:
- Product Manager must finalize PRD before design begins
- Design mockups must be approved before development starts
- Backend API must be ready before iOS app can integrate
- Legal review must complete before App Store submission
- Beta testing must complete 2 weeks before launch

**Infrastructure Dependencies**:
- AWS/GCP account setup → Backend deployment
- Apple Developer account ($99/year) → App Store submission
- Firebase project creation → Authentication, database, analytics
- Domain registration → Marketing website
- App Store Connect setup → TestFlight distribution

---

## 📝 Open Questions & Decisions

| Question | Status | Owner | Decision | Date |
|----------|--------|-------|----------|------|
| Do real-time salinity/temp sensors exist in Mobile Bay Eastern Shore? | **OPEN** | Tech Lead | **CRITICAL P0 VALIDATION** - Must confirm by Dec 1, 2025 | TBD |
| Should we use Firebase or AWS for backend? | Open | Tech Lead | Recommend Firebase (faster setup, real-time DB) vs AWS (more control, lower long-term cost) | TBD |
| What is our moderation policy for community content? | Open | Product Manager | Draft code of conduct by Jan 15, 2026 | TBD |
| Should we charge for premium features (e.g., offline maps, ad-free)? | Open | Product Manager | Decide by Feb 2026 based on budget needs | TBD |
| How do we verify webcam permissions before listing? | Open | Legal | Require written permission documentation from cam owners | TBD |
| What happens to user data if app shuts down? | Open | Legal | 30-day deletion notice + data export option in TOS | TBD |
| Should we build Android version simultaneously? | **RESOLVED** | Product Manager | No - iOS only for Phase 1, Android in Phase 3+ if demand exists | Oct 18, 2025 |
| Can we partner with Alabama Marine Resources for in-app license sales? | Open | Business Development | Explore partnership by Jan 2026 | TBD |
| Should Condition Score use machine learning? | **RESOLVED** | Tech Lead | No - rule-based algorithm for transparency and liability. ML in Phase 3+ only. | Oct 18, 2025 |
| How do we handle multi-day jubilees (rare but possible)? | Open | Product Manager | Event chat auto-archives after 6 hours of inactivity, not calendar day | TBD |

---

## 📚 Appendix

### References

**Research & Background**:
- "Jubilee-Report.md" - Comprehensive research document on Mobile Bay Jubilees (150+ years history, science, culture)
- Loesch, Harold (1960). "Sporadic Mass Shoreward Migrations of Demersal Fish and Crustaceans in Mobile Bay, Alabama." *Ecology* 41(2): 292-298.
- May, Edwin B. (1973). "Extensive Oxygen Depletion in Mobile Bay, Alabama." *Limnology and Oceanography* 18(3): 353-366.
- Turner et al. (1987). "Relationship of salinity stratification to oxygen depletion in Mobile Bay."

**Competitive Analysis**:
- Existing Facebook Groups:
  - "Jubilee Alert for Eastern Shore" (~2,500 members)
  - "Jubilee Watch Baldwin County" (~1,800 members)
  - "Jubilee Report Mobile Bay" (~3,200 members)
  - **Gaps**: Fragmented, no data aggregation, no mapping, search difficulty, algorithm-driven feed misses posts
  
**Similar Apps (Other Domains)**:
- Surfline (surf forecasting) - Inspiration for condition scoring
- eBird (bird watching citizen science) - Inspiration for community reporting
- Waze (crowdsourced traffic) - Inspiration for real-time alerts
- OnX Hunt (hunting/fishing maps) - Inspiration for offline maps

**User Research**:
- Interview transcripts from 5 veteran watchers (conducted Oct 2025)
- Survey of 50 Facebook group members (Oct 2025)
- Key insights: 
  - 82% want data-driven condition monitoring
  - 76% frustrated with Facebook algorithm hiding posts
  - 68% would pay <$5/year for premium features
  - 91% value educational content for teaching next generation

---

### Glossary

| Term | Definition |
|------|------------|
| **Jubilee** | Rare natural phenomenon where oxygen-depleted water drives marine life (flounder, crabs, shrimp, eels) to shore, creating impromptu community gathering and fishing opportunity. Occurs regularly only in Mobile Bay, Alabama and Tokyo Bay, Japan. |
| **Condition Score** | JubileeHub's 0-100 metric showing alignment of current environmental factors with historical jubilee patterns. NOT a prediction - jubilees remain unpredictable. |
| **Community Alert Level** | User-report-driven status (QUIET, WATCH, CONFIRMED) indicating current jubilee activity based on verified sightings, independent from Condition Score. |
| **Hypoxia** | Low dissolved oxygen in water (<30% saturation). Drives jubilees by forcing bottom-dwelling species to surface. |
| **Stratification** | Layering of water due to salinity/temperature differences. Strong stratification (>8 PSU gradient) prevents oxygen mixing and enables hypoxia. |
| **Eastern Shore** | Eastern coastline of Mobile Bay, including Point Clear, Fairhope, and Daphne. Primary jubilee zone (15-mile stretch). |
| **Verified Watcher** | User with reputation score >70, indicating consistent accurate reporting. Reports from verified watchers trigger faster alert escalation. |
| **Early Warning Signs** | Observable indicators preceding full jubilees: eels swimming on surface, baby flounder visible, blue crabs climbing pilings. Typically occur 1-2 hours before main event. |
| **Event-Based Chat** | Temporary chat room created when jubilee confirmed, scoped to geographic area and automatically archived 6 hours after last activity. Used for urgent real-time coordination during active jubilees. |
| **Discussion Boards** | Persistent forums organized by topic (Watch Coordination, Photos & Stories, Questions, etc.) for long-form community engagement, planning, and knowledge preservation. Unlike event chat, threads remain accessible indefinitely. |
| **Watch Party** | Structured discussion thread where users coordinate overnight beach watches by claiming time slots (e.g., "I'll check 2-4 AM"). Includes RSVP system and automated reminders. |
| **SwiftData** | Apple's modern data persistence framework for iOS 17+, replacing Core Data. Used for local database. |
| **Serverless** | Backend architecture using cloud functions (AWS Lambda/GCP Functions) that run on-demand, eliminating need for always-on servers. Cost-efficient for seasonal app. |
| **APNs** | Apple Push Notification service. iOS notification delivery system. |

---

### Mockups & Wireframes

**Figma Design Files**: [Link to be added in Phase 0]

**Key Screens** (High-fidelity mockups to be created):
1. Dashboard (Condition Score + Environmental Data)
2. Report Submission Flow (5 steps)
3. Map View (with markers and bottom sheet)
4. Event-Based Chat Room
5. User Profile
6. Notification Preferences
7. Onboarding Flow (5 screens)
8. Educational Content Library (Phase 3)
9. Discussion Board (Phase 2)
10. Watch Party Coordination (Phase 2)

**Design Principles Applied**:
- Dark mode first (optimized for 1-4 AM usage)
- Large touch targets (44x44pt minimum)
- High contrast (WCAG AA minimum)
- Minimal navigation depth (max 3 taps to any feature)
- Consistent iconography (SF Symbols where possible)
- Clear visual hierarchy (score most prominent)

---

## ✅ Approval & Sign-off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| Product Owner | [TBD] | | |
| iOS Engineering Lead | [TBD] | | |
| Backend Engineering Lead | [TBD] | | |
| Design Lead | [TBD] | | |
| Legal Counsel | [TBD] | | |
| Mobile Bay Community Stakeholder | [TBD] | | |

---

## 🔄 Revision History

### Planned Revisions
- **v1.1** (January 2026): After P0 validation - update with confirmed data sources, finalize backend architecture choice
- **v1.2** (May 2026): Post-beta testing - incorporate feedback, adjust feature priorities
- **v2.0** (September 2026): Post-first-season retrospective - algorithm improvements, Phase 2 roadmap

---

## 📎 Related Documentation

**To Be Created in Phase 0**:
- Architecture Design Document
- API Integration Specification
- Database Schema Documentation  
- Legal Documentation (TOS, Privacy Policy)
- Design System & Component Library
- User Testing Plan
- Marketing & Launch Plan
- Moderation Policy & Code of Conduct

---

## 📋 Instructions for Use

1. ✅ **Review this PRD** with all stakeholders (Product, Engineering, Design, Legal)
2. ⏳ **Execute Phase 0 validation tasks** (especially NOAA sensor confirmation)
3. ⏳ **Make technology stack decisions** (Firebase vs AWS, final approval)
4. ⏳ **Create supporting documentation** (architecture, legal, design)
5. ⏳ **Get formal approval** from all sign-off parties
6. ⏳ **Begin Phase 1 development** (February 2026 target)
7. 🔄 **Update PRD regularly** as requirements evolve or decisions are made
8. 📊 **Track against success metrics** throughout development and post-launch

---

## 🎯 Remember

**JubileeHub Mission**: Preserve and enhance Mobile Bay's 150-year jubilee tradition by combining modern technology with generational wisdom, creating a community intelligence platform that respects the unpredictable magic of nature while making jubilee experiences more accessible, safe, and educational for all.

**Core Values**:
- **Transparency Over Prediction**: Never promise what nature can't guarantee
- **Community Over Competition**: Foster collaboration, not gamification
- **Education Over Exploitation**: Teach responsible fishing and cultural heritage
- **Tradition Over Technology**: Enhance, don't replace, generational knowledge
- **Accessibility Over Exclusivity**: Welcome newcomers while honoring veterans

**Success Looks Like**:
- Veteran watchers saying "This helps me share what I know"
- Families saying "My kids finally understand what jubilees mean"
- Newcomers saying "I felt welcomed, not intimidated"
- Researchers saying "This data is invaluable"
- Community saying "This brings us together"

---

**Let's build something that honors the past, serves the present, and preserves the future of Mobile Bay's most extraordinary natural and cultural phenomenon.** 🌊

---

*End of Product Requirements Document*
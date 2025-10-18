# Mock Data Registry

**Last Updated**: 2025-10-18 (Initial Setup)
**Current Phase**: Phase 0 - Foundation & Planning
**Project**: JubileeHub iOS Application

---

## Overview

This registry tracks all mock data usage throughout the JubileeHub project, enabling systematic migration to real APIs. During Phase 1 development, iOS team will work with mock data while backend APIs are being built, then incrementally integrate real APIs on monthly milestones.

**Mock Data Strategy**:
- Month 1 (Feb 2026): iOS uses mocks, integrates Dashboard at month-end
- Month 2 (Mar 2026): iOS uses mocks for new features, integrates Reports/Map at month-end
- Month 3 (Apr 2026): Final integrations complete
- Month 4 (May 2026): All production code uses real APIs

---

## Active Mock Data Usage

### Component: Dashboard View
- **Location**: MobileBayJubilee/Views/DashboardView.swift
- **Mock Data**: `mockConditionData`
- **Mock Data Location**: MobileBayJubilee/Models/MockData/ConditionDataMock.swift
- **Real API Endpoint**: GET /api/conditions
- **Migration Priority**: P1 - High (Month 1 integration)
- **Migration Target**: End of February 2026
- **Migration Status**: Not Started
- **Notes**: Dashboard is first feature to integrate (Month 1 milestone)

### Component: Map View
- **Location**: MobileBayJubilee/Views/MapView.swift
- **Mock Data**: `mockReports`, `mockLocations`
- **Mock Data Location**: MobileBayJubilee/Models/MockData/ReportMocks.swift
- **Real API Endpoint**: GET /api/reports, GET /api/locations
- **Migration Priority**: P1 - High (Month 2 integration)
- **Migration Target**: End of March 2026
- **Migration Status**: Not Started
- **Notes**: Requires geospatial indexing on backend

### Component: Report Submission
- **Location**: MobileBayJubilee/Views/ReportSubmissionView.swift
- **Mock Data**: `mockReportSubmission` (simulated success)
- **Mock Data Location**: MobileBayJubilee/Services/MockReportService.swift
- **Real API Endpoint**: POST /api/reports
- **Migration Priority**: P1 - High (Month 2 integration)
- **Migration Target**: End of March 2026
- **Migration Status**: Not Started
- **Notes**: Photo upload to Cloud Storage required

### Component: Chat Room
- **Location**: MobileBayJubilee/Views/ChatView.swift
- **Mock Data**: `mockMessages`, `mockChatRoom`
- **Mock Data Location**: MobileBayJubilee/Models/MockData/ChatMocks.swift
- **Real API Endpoint**: Firebase Realtime Database
- **Migration Priority**: P1 - High (Month 2 integration)
- **Migration Target**: End of March 2026
- **Migration Status**: Not Started
- **Notes**: Real-time sync via Firebase Realtime Database

### Component: User Profile
- **Location**: MobileBayJubilee/Views/ProfileView.swift
- **Mock Data**: `mockUser`, `mockReputationHistory`
- **Mock Data Location**: MobileBayJubilee/Models/MockData/UserMocks.swift
- **Real API Endpoint**: GET /api/users/:id, PUT /api/users/:id
- **Migration Priority**: P1 - Medium (Month 3 integration)
- **Migration Target**: End of April 2026
- **Migration Status**: Not Started
- **Notes**: Includes profile photo upload

### Component: Discussion Boards
- **Location**: MobileBayJubilee/Views/DiscussionBoardView.swift
- **Mock Data**: `mockThreads`, `mockPosts`, `mockBoards`
- **Mock Data Location**: MobileBayJubilee/Models/MockData/DiscussionMocks.swift
- **Real API Endpoint**: GET/POST /api/boards, /api/threads, /api/posts
- **Migration Priority**: P1 - Medium (Month 3 integration)
- **Migration Target**: End of April 2026
- **Migration Status**: Not Started
- **Notes**: Watch Party posts have structured fields

### Component: Notifications
- **Location**: MobileBayJubilee/Services/NotificationService.swift
- **Mock Data**: `mockNotifications` (local notifications only)
- **Mock Data Location**: MobileBayJubilee/Services/MockNotificationService.swift
- **Real API Endpoint**: APNs push notification service
- **Migration Priority**: P1 - High (Month 3 integration)
- **Migration Target**: End of April 2026
- **Migration Status**: Not Started
- **Notes**: Device token registration required

### Component: Authentication
- **Location**: MobileBayJubilee/Services/AuthService.swift
- **Mock Data**: `mockUser`, `mockAuthToken`
- **Mock Data Location**: MobileBayJubilee/Services/MockAuthService.swift
- **Real API Endpoint**: Firebase Authentication
- **Migration Priority**: P1 - High (Month 1 integration)
- **Migration Target**: End of February 2026
- **Migration Status**: Not Started
- **Notes**: JWT token management

---

## Completed Migrations

(None yet - migrations begin end of Month 1)

---

## Mock Data Inventory

### ConditionDataMock.swift
**Location**: MobileBayJubilee/Models/MockData/ConditionDataMock.swift (to be created)

**Contains**:
- `mockConditionData`: Sample ConditionData with score 78, favorable conditions
- `mockScoreBreakdown`: Component scores (seasonal, time window, wind, tide, etc.)
- `mockWeatherData`: Wind 4.2 m/s East, temperature 27C
- `mockTideData`: Rising tide, high at 3:47 AM
- `mockAlertLevel`: Community alert level (WATCH/CONFIRMED)

### ReportMocks.swift
**Location**: MobileBayJubilee/Models/MockData/ReportMocks.swift (to be created)

**Contains**:
- `mockReports`: Array of 5-10 sample jubilee reports
- `mockVerifications`: Sample verification data (thumbs up/down)
- `mockReportTypes`: Full jubilee, early warning signs, all clear
- `mockSpecies`: Flounder, crabs, shrimp, eels

### LocationMocks.swift
**Location**: MobileBayJubilee/Models/MockData/LocationMocks.swift (to be created)

**Contains**:
- `mockLocations`: Point Clear, Fairhope, Daphne beach locations
- `mockWebcams`: Sample webcam locations with URLs
- `mockStations`: Environmental monitoring station locations

### UserMocks.swift
**Location**: MobileBayJubilee/Models/MockData/UserMocks.swift (to be created)

**Contains**:
- `mockUser`: Sample user profile (reputation 85, verified watcher)
- `mockUsers`: Array of sample users for testing
- `mockFavoriteLocations`: User's saved beach locations
- `mockNotificationPreferences`: Sample notification settings

### ChatMocks.swift
**Location**: MobileBayJubilee/Models/MockData/ChatMocks.swift (to be created)

**Contains**:
- `mockChatRoom`: Sample event-based chat room
- `mockMessages`: Array of sample chat messages
- `mockParticipants`: Users in chat room

### DiscussionMocks.swift
**Location**: MobileBayJubilee/Models/MockData/DiscussionMocks.swift (to be created)

**Contains**:
- `mockBoards`: 6 discussion board categories
- `mockThreads`: Sample threads (watch coordination, photos, questions)
- `mockPosts`: Sample post content with replies
- `mockWatchParty`: Structured watch party post

---

## Migration Schedule

### Month 1 End (February 2026)
- [ ] Migrate Dashboard to real Conditions API
- [ ] Migrate Authentication to Firebase Auth
- [ ] Test: Dashboard displays live data from backend
- [ ] Milestone: First working feature end-to-end

### Month 2 End (March 2026)
- [ ] Migrate Map to real Reports API
- [ ] Migrate Report Submission to real API
- [ ] Migrate Chat to Firebase Realtime Database
- [ ] Test: Submit report, see on map, verify, trigger chat
- [ ] Milestone: Core jubilee flow working

### Month 3 End (April 2026)
- [ ] Migrate User Profile to real API
- [ ] Migrate Discussion Boards to real API
- [ ] Migrate Notifications to APNs
- [ ] Test: Complete user journey end-to-end
- [ ] Milestone: All P1 features integrated

### Month 4 (May 2026)
- [ ] Remove all mock data from production code
- [ ] Verify no mock data in release builds
- [ ] Keep mock data in test targets only
- [ ] Code review confirms clean state
- [ ] Milestone: Production ready

---

## Quality Gates

### Before Month 1 Integration
- [ ] All mock data files created and documented
- [ ] Backend Conditions API deployed and tested
- [ ] Firebase Authentication configured
- [ ] Integration test plan created

### Before Month 2 Integration
- [ ] Month 1 integrations complete and stable
- [ ] Backend Reports API deployed and tested
- [ ] Firebase Realtime Database configured
- [ ] Geospatial indexing working

### Before Month 3 Integration
- [ ] Month 2 integrations complete and stable
- [ ] Backend Profiles, Boards, Notifications APIs deployed
- [ ] APNs configured and tested
- [ ] Photo upload to Cloud Storage working

### Before Production (June 2026)
- [ ] Zero mock data in production code
- [ ] All tests still pass with test mocks
- [ ] Build verification confirms no mocks in release
- [ ] Code review confirms clean state
- [ ] Screenshot evidence of all features with real data

---

## Statistics

**Total Components Using Mocks**: 8
**Migrations Complete**: 0
**Migrations In Progress**: 0
**Migrations Pending**: 8
**Completion Percentage**: 0%

**Target Completion**:
- End of Month 1: 25% (2/8 complete)
- End of Month 2: 62.5% (5/8 complete)
- End of Month 3: 100% (8/8 complete)

---

## Notes

### Phase 1 Approach (Parallel Development Strategy)

**Rationale**: Backend developer is on critical path. iOS team cannot wait for all APIs to be ready.

**Strategy**:
1. iOS team builds UI and logic using mock data
2. Backend team builds APIs in parallel
3. Monthly integration points prevent end-loaded integration risk
4. Continuous testing ensures mock-to-real transitions are smooth

**Mock Data Quality**:
- Mocks must match exact API response shape
- Use realistic data (actual Mobile Bay coordinates, species names, etc.)
- Include edge cases (empty states, error states)
- Keep mocks in sync with API schema changes

### Phase 2 Migration Strategy (Incremental Integration)

**Month 1 Priority**: Dashboard + Auth (simplest, establishes patterns)
**Month 2 Priority**: Reports + Map + Chat (core jubilee flow)
**Month 3 Priority**: Profiles + Boards + Notifications (remaining features)

**Integration Process**:
1. Backend API deployed and tested with Postman/curl
2. iOS developer updates network layer with real endpoint
3. Remove mock data service, use real API service
4. Test happy path and error cases
5. Code review to verify no mock code remains
6. Integration test added to test suite
7. Screenshot evidence provided

**Rollback Plan**: If integration fails, temporarily revert to mocks and investigate

### Phase 3 Verification (Production Readiness)

**Mock Data Removal Checklist**:
- [ ] Search codebase for "mock" keyword (case-insensitive)
- [ ] Verify all mock files only in test targets
- [ ] Build release configuration and verify no mock imports
- [ ] Run static analyzer to detect dead code
- [ ] Code review by second developer
- [ ] QA testing with real backend in staging environment

**Test Data Strategy**:
- Keep all mock files in test targets
- Use for unit tests, UI tests, SwiftUI previews
- Never import test mocks into production code
- Use compiler flags to prevent accidental inclusion

---

**Mock Data Philosophy**: "Mock data is a temporary scaffold, not permanent architecture. Plan the removal from day one."

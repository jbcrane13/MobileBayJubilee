# Phase 1 Month 1 Kickoff

**Month**: February 2026 (Month 1 of Phase 1)
**Goal**: Core Infrastructure - Backend + iOS Foundation
**Team**: Backend Lead, iOS Lead 1, iOS Lead 2, Product Manager
**Status**: ACTIVE - Development In Progress

---

## Week 1 Priorities (Feb 1-7)

### Backend Lead - Firebase Setup
- [x] Review Firebase setup guide (docs/P0-002b-Firebase-Setup-Guide.md)
- [ ] Create Firebase project: `jubileehub-prod`
- [ ] Configure Firebase Authentication (Email/Password + Apple)
- [ ] Set up Firestore database with schema
- [ ] Set up Realtime Database for chat
- [ ] Configure Cloud Storage bucket
- [ ] **CRITICAL**: Contact Dauphin Island Sea Lab for ARCOS API access

### iOS Lead 1 - Dashboard Screen
- [ ] Review design specs (docs/P0-PHASE-0-COMPLETION-PACKAGE.md Section 3.1)
- [ ] Integrate Firebase iOS SDK
- [ ] Create ConditionScoreGaugeView (circular gauge)
- [ ] Create DashboardView layout
- [ ] Implement pull-to-refresh
- [ ] Connect to mock data initially

### iOS Lead 2 - Map Screen
- [ ] Review design specs (docs/P0-PHASE-0-COMPLETION-PACKAGE.md Section 3.2)
- [ ] Integrate MapKit
- [ ] Create MapView with Mobile Bay center
- [ ] Create custom map pin annotations
- [ ] Implement report detail bottom sheet
- [ ] Connect to mock data

### Product Manager
- [ ] Schedule legal counsel review (legal/LEGAL-DOCUMENTS-DRAFT.md)
- [ ] Begin entity formation process
- [ ] Set up weekly team meetings (Monday 10am)
- [ ] Create sprint tracking (2-week sprints)
- [ ] Review Phase 0 deliverables with team

### All
- [ ] Daily standup (async via Slack): What done? What today? Blockers?
- [ ] End of Week 1: Demo working features
- [ ] Commit code daily with descriptive messages

---

## Month 1 Milestones

**End of Week 2** (Feb 14):
- Backend: NOAA/ARCOS integration complete, data ingesting
- iOS: Dashboard + Map screens functional with mock data
- Product: Legal review initiated

**End of Week 4** (Feb 28):
- Backend: Condition Score algorithm live, Cloud Run deployed
- iOS: Report submission flow complete, Firebase integrated
- Integration: Replace mock data with real Firebase data
- Milestone: **Core screens working end-to-end**

---

## Development Environment Setup

### Backend
```bash
# Clone repo
git clone [REPO_URL]
cd MobileBayJubilee

# Install Firebase CLI
npm install -g firebase-tools

# Login and init
firebase login
firebase init
```

### iOS
```bash
# Open Xcode project
open MobileBayJubilee.xcodeproj

# Install Firebase SDK via SPM
# File > Add Package Dependencies
# https://github.com/firebase/firebase-ios-sdk
# Select: FirebaseAuth, FirebaseFirestore, FirebaseStorage, FirebaseMessaging
```

---

## Communication Channels

**Daily Standup**: Slack #jubileehub-daily (async, post by 10am)
**Questions**: Slack #jubileehub-dev
**Demos**: Zoom (Mondays 2pm)
**Code Reviews**: GitHub Pull Requests
**Docs**: This repo /docs and /tracking

---

## Sprint 1 (Feb 1-14) - Core Infrastructure

### Sprint Goal
"Backend ingesting data every 30 minutes, iOS showing Condition Score and reports"

### User Stories

**Backend**:
1. As a system, I fetch NOAA tide data every 30 minutes
2. As a system, I fetch NOAA weather data every 30 minutes
3. As a system, I fetch ARCOS water quality data every 30 minutes
4. As a system, I calculate Condition Score (0-100) from environmental data
5. As a system, I store condition snapshots in Firestore

**iOS**:
6. As a user, I see the current Condition Score on the Dashboard
7. As a user, I see recent jubilee reports on the Dashboard
8. As a user, I see jubilee reports on a map
9. As a user, I can tap a map pin to see report details
10. As a user, I can pull-to-refresh to update the Condition Score

---

## Definition of Done

**For Each Feature**:
- [ ] Code written and follows style guide
- [ ] Unit tests written (if applicable)
- [ ] Code reviewed by peer
- [ ] Builds successfully
- [ ] Tested on simulator
- [ ] Screenshot provided (for UI features)
- [ ] Committed to git with descriptive message
- [ ] Demo-able to team

**For Sprint**:
- [ ] All sprint user stories complete
- [ ] Sprint demo completed
- [ ] Retrospective held
- [ ] Next sprint planned

---

## Risks & Mitigation

**Risk 1**: ARCOS API access delayed
- **Mitigation**: Implement without water quality data, add later
- **Owner**: Backend Lead
- **Status**: Monitoring

**Risk 2**: Firebase learning curve
- **Mitigation**: Pair programming, Firebase documentation
- **Owner**: iOS Leads
- **Status**: Monitoring

**Risk 3**: Scope creep
- **Mitigation**: Ruthless prioritization, focus on P1 only
- **Owner**: Product Manager
- **Status**: Active

---

## Next Steps

**This Week** (Feb 1-7):
1. Backend: Create Firebase project, contact ARCOS
2. iOS: Integrate Firebase SDK, build Dashboard gauge
3. Product: Legal review, entity formation

**Next Week** (Feb 8-14):
1. Backend: NOAA integration complete
2. iOS: Map screen complete
3. Integration: Test end-to-end data flow

---

**Created**: 2025-10-18 (simulation of Feb 2026 kickoff)
**Status**: ACTIVE
**Team**: Ready to execute Phase 1

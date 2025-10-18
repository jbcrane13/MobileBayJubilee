# Architecture Decision Document (ADD): Backend Platform Selection

**Project**: JubileeHub iOS Application
**Decision Date**: 2025-10-18
**Decision**: Choose Firebase for backend infrastructure
**Status**: APPROVED
**Deciders**: Product Owner, Backend Lead (via AI consensus analysis)

---

## Executive Summary

After comprehensive multi-model AI consensus analysis, **Firebase has been selected** as the backend platform for JubileeHub. This decision prioritizes speed-to-market, operational simplicity, and cost-effectiveness while maintaining sufficient scalability for projected growth.

**Consensus**: 2 of 3 AI models recommended Firebase, citing timeline constraints and team composition as decisive factors.

---

## Decision

### Platform: Firebase (Google Cloud Platform)

**Architecture Stack**:
- **Database**: Cloud Firestore (core data) + Realtime Database (chat)
- **Authentication**: Firebase Auth (Email/Password + Sign in with Apple)
- **File Storage**: Cloud Storage for Firebase
- **Serverless Functions**: Cloud Functions + Cloud Run
- **Scheduling**: Cloud Scheduler
- **Push Notifications**: Firebase Cloud Messaging (FCM) + APNs
- **Analytics**: Firebase Analytics

**Estimated Cost**: $2,000-$3,000/year (well within $3,000 budget)

---

## Context

### Project Constraints
- **Timeline**: 7 months to June 1, 2026 launch (hard deadline - jubilee season)
- **Team**: 1 backend developer (full-time, 6 months), not a DevOps specialist
- **Budget**: $3,000/year for backend infrastructure
- **Scale**: 200-500 users Year 1, target 5,000+ by Year 3

### Technical Requirements
1. **Real-time chat** during active jubilee events (CRITICAL)
2. **Cron job**: Fetch NOAA/ARCOS data every 30 minutes
3. **Condition Score algorithm**: Calculate 0-100 score from environmental data
4. **User authentication**: Email/password and Apple Sign-In
5. **Photo uploads**: User-submitted jubilee event photos
6. **Push notifications**: Alert users when Condition Score hits threshold (70+)
7. **RESTful API**: For iOS app integration

---

## Decision Drivers

### Critical Factors (in priority order)

1. **Timeline Risk** 🚨
   - June 1, 2026 is non-negotiable (jubilee season start)
   - 7-month timeline has zero slack
   - Firebase: 6-10 weeks to MVP backend
   - AWS: 1-month+ ramp-up even with Amplify

2. **Team Composition** 👥
   - Single backend developer (not DevOps expert)
   - Firebase: Managed services, minimal ops burden
   - AWS: More configuration, IAM complexity

3. **Real-time Chat** 💬
   - Core feature for community coordination
   - Firebase: Native Firestore listeners or RTDB
   - AWS: AppSync GraphQL subscriptions (more complex setup)

4. **Cost** 💰
   - Budget: $3,000/year infrastructure
   - Firebase: ~$2,500/year projected (Firestore $5-40/mo, RTDB <$10/mo)
   - AWS: ~$2,300/year with Free Tier Year 1

5. **Scalability** 📈
   - Need to handle 5,000+ users by Year 3
   - Both platforms scale sufficiently
   - Firebase proven at this scale for mobile apps

---

## Options Considered

### Option 1: Firebase (SELECTED ✅)

**Pros**:
- ✅ **Fastest setup**: 6-10 weeks to MVP backend
- ✅ **Lowest operational burden**: Managed scaling, HA, patching
- ✅ **Native real-time**: Firestore listeners, RTDB for chat
- ✅ **iOS SDK integration**: Direct Firebase SDKs reduce API layer work
- ✅ **Cost-effective**: Well under $3k/year at projected scale
- ✅ **Proven for mobile apps**: Industry standard for small-team mobile backends
- ✅ **Offline support**: Firestore offline cache for spotty connectivity

**Cons**:
- ⚠️ **Vendor lock-in**: Migration to AWS later would be complex
- ⚠️ **Limited server-side control**: Proprietary query model
- ⚠️ **Cost unpredictability at scale**: Document read/write pricing can surprise

**Mitigation Strategies**:
- Use Cloud Run (containers) for NOAA/ARCOS ingest logic (portable)
- Abstract data access layer in iOS app for future migration
- Design portable data models (avoid Firebase-specific features where possible)
- Monitor Firestore usage closely, optimize queries early

---

### Option 2: AWS with Amplify (NOT SELECTED)

**Pros**:
- ✅ **Better long-term flexibility**: Easier to add advanced features
- ✅ **More cost control at scale**: Granular pay-per-use pricing
- ✅ **Less vendor lock-in**: Modular services, easier migration
- ✅ **Enterprise-ready**: AWS services designed for hyperscale
- ✅ **Amplify CLI**: Comparable DX to Firebase

**Cons**:
- ❌ **Steeper learning curve**: 1-month ramp-up minimum
- ❌ **Timeline risk**: Adds 2-4 weeks to Phase 0 setup
- ❌ **More complex real-time**: AppSync GraphQL subscriptions vs native Firestore
- ❌ **Higher DevOps burden**: IAM, VPC, CloudFormation complexity
- ❌ **Integration overhead**: More assembly required vs Firebase's integrated stack

**Why Not Selected**:
- Timeline is critical (June 1, 2026 hard deadline)
- Single backend developer not DevOps specialist
- AWS benefits (flexibility, advanced features) are future-hypothetical
- Near-term costs (time, complexity) outweigh long-term benefits

---

## Detailed Architecture

### Firebase Backend Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                       iOS App (Swift/SwiftUI)                │
└────┬──────────────────────────────────────────────┬─────────┘
     │                                               │
     │ Firebase SDKs                                 │ REST API
     │                                               │
┌────▼──────────────────────┐              ┌────────▼──────────┐
│   Firebase Services       │              │   Cloud Run       │
│                           │              │   (Containers)    │
│  • Auth                   │              │                   │
│  • Firestore (core data)  │              │  NOAA/ARCOS       │
│  • RTDB (chat)            │              │  Ingestion        │
│  • Cloud Storage (photos) │              │  + Score Calc     │
│  • FCM (push)             │              │                   │
└─────────────┬─────────────┘              └─────────┬─────────┘
              │                                       │
              │                              ┌────────▼─────────┐
              │                              │  Cloud Scheduler │
              │                              │  (30 min cron)   │
              │                              └──────────────────┘
              │
     ┌────────▼────────┐
     │  Cloud Functions │
     │  (Triggers)      │
     │                  │
     │  • On user       │
     │    create        │
     │  • On report     │
     │    submit        │
     │  • Score         │
     │    threshold     │
     └──────────────────┘
```

### Component Breakdown

**1. Cloud Firestore (Core Database)**
- Collections: `users`, `reports`, `locations`, `condition_snapshots`
- Real-time listeners for live updates
- Offline support for mobile app
- Composite indexes for complex queries
- Estimated cost: $5-40/month

**2. Realtime Database (Chat)**
- Separate RTDB instance for event chat
- Lower cost than Firestore for high-frequency writes
- Fan-out messaging for active jubilee events
- TTL on old messages (7-day retention)
- Estimated cost: <$10/month

**3. Cloud Storage (Photos)**
- User-uploaded jubilee photos
- Firebase Extension for automatic image resizing (thumbnail, medium, full)
- Security rules tied to Firebase Auth
- CDN distribution via Google Cloud
- Estimated cost: ~$1/month (10GB storage)

**4. Firebase Auth**
- Email/password authentication
- Sign in with Apple integration
- JWT tokens for secure API calls
- Custom claims for user roles (verified watcher, moderator)
- Cost: Free tier (under 10k MAU)

**5. Cloud Functions (Event-driven)**
- Triggers:
  - `onCreate('users/{userId}')`: Initialize user profile
  - `onCreate('reports/{reportId}')`: Process new jubilee report, check verification
  - `onUpdate('condition_snapshots/{snapshotId}')`: Check score threshold, send push
- Runtime: Node.js 20
- Estimated cost: ~$5/month

**6. Cloud Run (Scheduled Data Ingestion)**
- Container: NOAA/ARCOS API client
- Triggered by Cloud Scheduler every 30 minutes
- Fetches tide, weather, water quality data
- Calculates Condition Score (0-100)
- Writes to Firestore `condition_snapshots` collection
- **Portability**: Containerized for future migration
- Estimated cost: ~$5/month

**7. Cloud Scheduler (Cron)**
- Schedule: `*/30 * * * *` (every 30 minutes)
- Triggers Cloud Run HTTP endpoint
- Estimated cost: Free tier

**8. Firebase Cloud Messaging (Push Notifications)**
- Topic-based notifications (by location or global)
- Device targeting for user preferences
- APNs integration for iOS
- Cost: Free

---

## Cost Breakdown

### Year 1 Projected Costs (500 MAU)

| Service | Monthly | Yearly | Notes |
|---------|---------|--------|-------|
| Firestore | $20 | $240 | 500 users, moderate read/write |
| Realtime Database | $8 | $96 | Chat only, optimized |
| Cloud Storage | $1 | $12 | 10GB photos |
| Cloud Functions | $5 | $60 | Low-moderate triggers |
| Cloud Run | $5 | $60 | 1,440 runs/month (30 min) |
| Cloud Scheduler | $0 | $0 | Free tier |
| Firebase Auth | $0 | $0 | Free tier (<10k MAU) |
| FCM | $0 | $0 | Free |
| **TOTAL** | **~$39** | **~$468** | Well under $3k budget |

### Year 3 Projected Costs (5,000 MAU)

| Service | Monthly | Yearly | Notes |
|---------|---------|--------|-------|
| Firestore | $150 | $1,800 | 10x users, optimized queries |
| Realtime Database | $50 | $600 | Active chat usage |
| Cloud Storage | $10 | $120 | 100GB photos |
| Cloud Functions | $20 | $240 | Moderate scaling |
| Cloud Run | $10 | $120 | Same schedule |
| **TOTAL** | **~$240** | **~$2,880** | Still under $3k |

**Cost Mitigation Strategies**:
- Use RTDB for chat (cheaper than Firestore)
- Implement pagination for large queries
- Add TTL on old chat messages (7 days)
- Optimize Firestore indexes
- Batch writes where possible
- Monitor usage via Firebase console

---

## Implementation Timeline

### Phase 0 Backend Setup (Weeks 1-4)

**Week 1-2: Firebase Project Setup**
- ✅ Create Firebase project
- ✅ Configure Firebase Auth (Email/Password, Apple Sign-In)
- ✅ Set up Firestore database with security rules
- ✅ Set up Realtime Database for chat
- ✅ Configure Cloud Storage with security rules
- ✅ iOS app Firebase SDK integration

**Week 3-4: NOAA/ARCOS Integration**
- ✅ Build Cloud Run container for data ingestion
- ✅ Implement NOAA Tides & Currents API client
- ✅ Implement NOAA Weather Service API client
- ✅ Contact Dauphin Island Sea Lab for ARCOS API access
- ✅ Implement ARCOS water quality API client
- ✅ Implement Condition Score algorithm
- ✅ Configure Cloud Scheduler (30-min cron)
- ✅ Test end-to-end data flow

**Week 4: Cloud Functions**
- ✅ Deploy user onCreate trigger
- ✅ Deploy report onCreate trigger
- ✅ Deploy score threshold check function
- ✅ Configure FCM for push notifications

---

## Risk Analysis

### High Risks

**1. Vendor Lock-in** ⚠️
- **Severity**: Medium
- **Probability**: High (inevitable with Firebase)
- **Impact**: Future migration would be complex and expensive
- **Mitigation**:
  - Use Cloud Run containers for business logic (portable)
  - Abstract data access in iOS app
  - Design portable data models
  - Document migration strategy in Phase 1

**2. Cost Escalation at Scale** ⚠️
- **Severity**: Medium
- **Probability**: Medium (if app succeeds beyond 5k users)
- **Impact**: Could exceed budget by Year 3-4
- **Mitigation**:
  - Monitor Firestore usage closely
  - Optimize queries and indexes
  - Use RTDB for high-frequency writes
  - Implement cost alerts in Firebase console
  - Plan AWS migration if costs exceed $5k/year

### Medium Risks

**3. Real-time Chat Costs** ⚠️
- **Severity**: Low
- **Probability**: Medium (depends on chat usage)
- **Impact**: Could add $100-200/month if very active
- **Mitigation**:
  - Use RTDB instead of Firestore for chat
  - Implement message TTL (7 days)
  - Paginate chat history
  - Monitor chat bandwidth

**4. Firebase Service Limits** ⚠️
- **Severity**: Low
- **Probability**: Low (at our scale)
- **Impact**: Could hit write limits during viral events
- **Mitigation**:
  - Design for batch writes
  - Implement rate limiting in iOS app
  - Monitor quotas in Firebase console

### Low Risks

**5. ARCOS API Availability** ⚠️
- **Severity**: Medium (affects core feature)
- **Probability**: Very Low (system operational since 2003)
- **Impact**: Reduced Condition Score accuracy
- **Mitigation**:
  - Implement fallback algorithm without water quality
  - Cache last-known water quality data (6-hour TTL)
  - Alert monitoring for ARCOS API failures

---

## Success Metrics

### Phase 0 (Backend Setup)
- ✅ Firebase project configured within 2 weeks
- ✅ NOAA/ARCOS integration complete within 4 weeks
- ✅ iOS app successfully integrates with Firebase Auth
- ✅ Cloud Scheduler running reliably (30-min intervals)
- ✅ Push notifications working end-to-end

### Phase 1 (MVP Launch)
- ✅ Cost stays under $100/month
- ✅ Real-time chat latency < 1 second
- ✅ Condition Score updated every 30 minutes
- ✅ 99% uptime for Firebase services
- ✅ No critical security issues

### Year 1 (Production)
- ✅ Cost stays under $3,000/year
- ✅ Scales to 500+ MAU without performance degradation
- ✅ Real-time features remain responsive
- ✅ User satisfaction with chat feature > 80%

---

## Migration Strategy (Future)

### If AWS Migration Becomes Necessary

**Triggers for Migration**:
1. Firebase costs exceed $5,000/year
2. Advanced analytics/ML features needed
3. Enterprise compliance requirements emerge
4. Multi-cloud strategy required

**Migration Approach**:
1. **Phase 1**: Migrate NOAA/ARCOS ingest to AWS Lambda (already containerized)
2. **Phase 2**: Migrate file storage to S3
3. **Phase 3**: Migrate Firestore to DynamoDB (most complex)
4. **Phase 4**: Migrate auth to Cognito
5. **Phase 5**: Migrate real-time chat to AppSync

**Estimated Migration Cost**: $20k-30k (3-4 months engineering)

**When to Start Planning**: When Firebase costs approach $4k/year or user base exceeds 3,000 MAU

---

## Consensus Analysis Summary

### AI Models Consulted
1. **gpt-5-pro** (for Firebase): 8/10 confidence
2. **gemini-2.5-pro** (for AWS): 8/10 confidence
3. **gpt-5-codex** (neutral, leaning Firebase): 7/10 confidence

### Areas of Agreement
✅ Both platforms are technically feasible
✅ Firebase is faster to set up (all models agree)
✅ AWS has better long-term flexibility (all models agree)
✅ Real-time chat is easier with Firebase (2 of 3 models)
✅ Timeline is critical constraint (all models)
✅ Single backend developer favors simpler platform (all models)

### Areas of Disagreement
⚠️ **Long-term value**: AWS advocates say "start where you finish", Firebase advocates say "ship fast, migrate later if needed"
⚠️ **AWS Amplify viability**: Gemini says it's comparable to Firebase, others say it's still more complex
⚠️ **Migration risk**: AWS advocates prioritize avoiding future migration, Firebase advocates say it's acceptable risk

### Consensus Decision Rationale
**Firebase wins 2-1** because:
1. Timeline constraint is **hard** (June 1, 2026 - jubilee season)
2. Team constraint is **real** (single backend dev, not DevOps)
3. AWS long-term benefits are **hypothetical** (may never need advanced features)
4. Firebase migration risk is **acceptable** (can migrate if app succeeds beyond 5k users)
5. Real-time chat is **core feature** (Firebase's native strength)

---

## Action Items

### Immediate (This Week)
- [x] Document decision in ADD (this file)
- [ ] Create Firebase project (`jubileehub-prod`)
- [ ] Set up Firebase Auth (Email/Password + Apple)
- [ ] Configure Firestore database
- [ ] Configure Realtime Database (chat)
- [ ] Set up Cloud Storage bucket

### Week 1-2 of Phase 0
- [ ] Contact Dauphin Island Sea Lab for ARCOS API access
- [ ] Build NOAA API clients (Tides, Weather)
- [ ] Build ARCOS API client
- [ ] Implement Condition Score algorithm
- [ ] Deploy Cloud Run container

### Week 3-4 of Phase 0
- [ ] Configure Cloud Scheduler
- [ ] Deploy Cloud Functions (user onCreate, report onCreate, score threshold)
- [ ] Integrate FCM with APNs
- [ ] iOS app Firebase SDK integration
- [ ] End-to-end testing

---

## References

### Technical Documentation
- Firebase Documentation: https://firebase.google.com/docs
- Cloud Run Documentation: https://cloud.google.com/run/docs
- Cloud Scheduler: https://cloud.google.com/scheduler/docs
- Firestore Best Practices: https://firebase.google.com/docs/firestore/best-practices

### Project Documents
- `tracking/P0-001-API-Research-Report.md` - NOAA/ARCOS API details
- `tracking/CRITICAL-DECISIONS.md` - Decision context
- `docs/PRD.md` - Product requirements

### Related Decisions
- Decision 1: Budget approved at $162k (includes $3k/year infrastructure)
- Decision 2: NOAA sensors validated via ARCOS system

---

## Appendix: Rejected Alternatives

### Supabase
- **Pros**: Open-source Firebase alternative, PostgreSQL backend
- **Cons**: Less mature real-time features, smaller ecosystem
- **Why rejected**: Firebase more proven for mobile real-time apps

### Backend-as-a-Service (Parse, Back4App)
- **Pros**: Quick setup, mobile-first design
- **Cons**: Smaller ecosystems, uncertain long-term viability
- **Why rejected**: Firebase more stable and feature-rich

### Custom Node.js + MongoDB/PostgreSQL
- **Pros**: Full control, no vendor lock-in
- **Cons**: Requires DevOps expertise, server management, higher cost
- **Why rejected**: Timeline and team constraints

### Hybrid (Firebase + AWS)
- **Example**: Firebase for real-time, AWS for cron
- **Pros**: "Best of both worlds"
- **Cons**: Integration overhead, more complexity, dual billing
- **Why rejected**: Adds complexity without clear benefit

---

**Document Control**:
- **Version**: 1.0
- **Created**: 2025-10-18
- **Last Updated**: 2025-10-18
- **Next Review**: End of Phase 0 (3 months)
- **Owner**: Backend Lead
- **Approvers**: Product Owner, Backend Lead
- **Status**: APPROVED ✅

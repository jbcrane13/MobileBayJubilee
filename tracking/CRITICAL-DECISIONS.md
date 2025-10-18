# Critical Decisions Required

**Project**: JubileeHub iOS Application
**Created**: 2025-10-18
**Last Updated**: 2025-10-18
**Status**: ALL DECISIONS RESOLVED ✅✅✅
**Priority**: ZERO BLOCKERS - Full Phase 0 execution cleared

---

## Executive Summary

Comprehensive project planning revealed **3 critical decisions** required before development could proceed. **ALL 3 DECISIONS ARE NOW RESOLVED** ✅, fully clearing the path for Phase 0 execution.

**Resolved Decisions**:
- ✅ Budget Alignment: $162k approved (2025-10-18)
- ✅ NOAA Sensor Availability: Sensors exist via ARCOS system (2025-10-18)
- ✅ Backend Platform Choice: Firebase selected (2025-10-18)

**Timeline Impact**: ZERO BLOCKERS - Phase 0 execution can proceed at full speed

---

## DECISION 1: BUDGET ALIGNMENT ~~(URGENT - BLOCKING)~~ - **RESOLVED** ✅

### DECISION OUTCOME: BUDGET APPROVED AT $162,000

**Status**: RESOLVED (2025-10-18)
**Decision**: Option A - Increase budget to $162,000
**Impact**: All P1 features proceed as specified, June 1, 2026 launch on track

### Original Situation
**Planned Project Budget**: $162,000 total for Year 1
**PRD Estimated Budget**: $74,000 total for Year 1
**Gap**: $88,000 (119% over budget)

### Root Cause
The PRD budget estimate significantly underestimated actual development costs:
- PRD assumed $60k for "development" but realistic cost is $127k
- 2 full-time iOS developers for 4 months: $76.8k
- 1 full-time backend developer for 6 months: $50.4k
- Plus design ($12.8k), legal ($9k), QA ($6k), infrastructure ($3.6k)

### Detailed Budget Breakdown

**Development Costs**: $127,200
- Backend Developer: $60/hr x 840 hrs (6 months full-time) = $50,400
- iOS Developer 1: $60/hr x 640 hrs (4 months full-time) = $38,400
- iOS Developer 2: $60/hr x 640 hrs (4 months full-time) = $38,400

**Design & Legal**: $21,800
- UI/UX Designer: $80/hr x 160 hrs (contract) = $12,800
- Legal Counsel: $150/hr x 60 hrs (contract) = $9,000

**Infrastructure**: $3,600/year
- Firebase/AWS: $3,000/year
- Apple Developer: $99/year
- Domain & hosting: $200/year
- Sentry (error tracking): $300/year

**Other**: $9,000
- QA Tester: $50/hr x 120 hrs (Month 4) = $6,000
- Community Moderator: $500/month x 2 months = $1,000
- Marketing: $2,000

**Total Year 1**: $162,000

### Options for Stakeholder Decision

#### Option A: Increase Budget to $162,000 (RECOMMENDED)
**Pros**:
- Delivers all P1 features as specified in PRD
- Maintains June 1, 2026 launch date
- Proper team sizing for timeline
- Realistic market rates for talent

**Cons**:
- Requires additional $88k funding
- May require fundraising or budget reallocation

**Timeline**: No delay, proceed with Phase 0 in November 2025

**Recommendation**: Seek additional funding through grants, sponsors, or investor capital

---

#### Option B: Reduce Scope - Move Discussion Boards to Phase 2
**Budget Savings**: ~$12,000
**New Total**: ~$150,000

**What Changes**:
- Remove Discussion Boards from P1 MVP
- Remove Watch Party coordination feature from P1
- Launch with: Dashboard, Reports, Map, Event Chat, Profiles, Notifications
- Add Discussion Boards in Fall 2026 update (Phase 2)

**Impact**:
- Reduces backend development by ~6 days
- Reduces iOS development by ~12 days
- Slightly reduces scope but maintains core jubilee functionality
- Users can still coordinate via Event Chat during active jubilees

**Timeline**: No delay, proceed with Phase 0

**Recommendation**: Acceptable compromise if full budget unavailable

---

#### Option C: Reduce Team - Use 1.5 iOS Developers
**Budget Savings**: ~$19,000
**New Total**: ~$143,000

**What Changes**:
- 1 full-time iOS developer (40 hrs/week)
- 1 part-time iOS developer (20 hrs/week)
- Extends Phase 1 development by ~2-3 weeks

**Impact**:
- Launch date shifts from June 1 to June 15-22, 2026
- Still hits jubilee season but with less buffer
- Increased risk of delays cascading
- Less parallel development capacity

**Timeline**: 2-3 week delay to launch

**Recommendation**: Risky due to tight timeline, not recommended

---

#### Option D: Offshore Backend Development
**Budget Savings**: ~$17,000 (reduce rate from $60/hr to $40/hr)
**New Total**: ~$145,000

**What Changes**:
- Hire offshore backend developer at lower rate
- Same scope and timeline

**Impact**:
- Potential communication challenges (timezone, language)
- May require more oversight from Product Manager
- Code quality risk (depends on developer skill)
- Could introduce delays if not properly managed

**Timeline**: No delay if developer is skilled, potential delays if issues arise

**Recommendation**: Only if stakeholders have existing offshore relationships with proven quality

---

#### Option E: Delay Launch to July 2026
**Budget Impact**: Allows 1 additional month for fundraising
**New Total**: Still need ~$162k but more time to secure it

**What Changes**:
- Phase 0 starts December 2025 instead of November
- Phase 1 runs March-June 2026
- Launch July 1, 2026 (misses peak jubilee season start)

**Impact**:
- Misses optimal launch timing (jubilees start in June)
- Smaller user base for first season
- Less word-of-mouth marketing opportunity
- May impact year 1 success metrics

**Timeline**: 1 month delay

**Recommendation**: Avoid if possible - timing is critical for product-market fit

---

### Decision Required By

**Deadline**: Within 2 weeks (by early November 2025)

**Why Urgent**:
- Phase 0 cannot begin without budget approval
- Team hiring/contracting requires lead time
- 7-month timeline has zero slack time
- Any delay in decision cascades to launch date

**Decision Makers**: Product Owner, Finance/Budget Authority, Investors (if applicable)

**Required Action**: Schedule stakeholder meeting to review options and commit to budget

---

## DECISION 2: NOAA SENSOR AVAILABILITY ~~(BLOCKING)~~ - **RESOLVED** ✅

### DECISION OUTCOME: SENSORS EXIST - PROCEED WITH FULL ALGORITHM

**Status**: RESOLVED (2025-10-18)
**Finding**: Water quality sensors DO EXIST in Mobile Bay via ARCOS system
**Impact**: NO fallback algorithm needed, proceed with full Condition Score as designed

### Research Summary
Comprehensive API research revealed that the **ARCOS (Alabama Real-time Coastal Observing System)** operated by Dauphin Island Sea Lab provides real-time water quality data for Mobile Bay.

**ARCOS System Details**:
- 7 water quality sampling stations around Mobile Bay + 1 outside Bay entrance
- Provides: Water temperature, salinity, dissolved oxygen
- Update frequency: Every 30 minutes
- Data portal: https://arcos.disl.org
- Operating since 2003 with continuous data archive

### Original Concern
The Condition Score algorithm is designed to include water quality data (salinity, water temperature). The PRD flagged uncertainty about whether these sensors exist in Mobile Bay Eastern Shore.

### Why This Mattered
- Water quality data (salinity stratification, temperature) are key indicators of jubilee conditions
- Without this data, Condition Score would be less accurate
- Affected core product value proposition

### Validation Completed
**Date**: 2025-10-18 (Phase 0 Week 0 - Early research)
**Method**: Web research and API documentation review
**Result**: SENSORS CONFIRMED via ARCOS system
**Report**: See tracking/P0-001-API-Research-Report.md for full details

### Action Taken
**DECISION**: Proceed with full Condition Score algorithm as designed
**Impact**: No scope reduction, no fallback needed
**Algorithm**: Full 100-point scoring with all components including water quality

### Next Steps for Backend Team
1. **Contact Dauphin Island Sea Lab** (ARCOS operator)
   - Email: likely arcos@disl.org
   - Request API access or data sharing agreement
   - Confirm real-time data feed options
   - Timeline: Week 1-2 of Phase 0

2. **Integrate ARCOS Data into Cron Job**
   - Fetch water temperature and salinity every 30 minutes
   - Store in database alongside NOAA tide and weather data
   - Use in Condition Score calculation

3. **No Fallback Development Needed**
   - Original concern resolved
   - Full algorithm implementation proceeds

### Impact on Project
- ✅ NO algorithm reduction needed
- ✅ NO user-facing limitation warnings
- ✅ Full Condition Score accuracy as designed (0-100 scale)
- ✅ PRD water quality components remain in scope
- ✅ No budget impact for sensor deployment

### Documentation Updated
- tracking/CRITICAL-DECISIONS.md (this file) - RESOLVED status
- tracking/P0-001-API-Research-Report.md - Full API documentation
- docs/PRD.md - Needs update to confirm ARCOS availability

---

## DECISION 3: BACKEND PLATFORM CHOICE ~~(Week 2-3 of Phase 0)~~ - **RESOLVED** ✅

### DECISION OUTCOME: FIREBASE SELECTED

**Status**: RESOLVED (2025-10-18)
**Decision**: Firebase (Google Cloud Platform)
**Impact**: Faster setup, lower ops burden, within budget, strong real-time capabilities

### Original Situation
Need to choose between Firebase and AWS for backend infrastructure.

### Options Comparison

#### Option 3A: Firebase (SELECTED ✅)

**Pros**:
- Faster setup (saves 1-2 weeks in Phase 0)
- Real-time database built-in (perfect for chat feature)
- Authentication included (Firebase Auth)
- Simpler for MVP development
- Lower complexity for small team
- Good documentation and community support

**Cons**:
- Potentially higher costs at scale (but not relevant for Year 1)
- Less control over infrastructure
- Vendor lock-in

**Cost Estimate (Year 1)**:
- Firebase Auth: Free tier (under 10k MAU)
- Firestore: ~$1,500/year (estimated based on 500 users)
- Realtime Database: ~$500/year
- Cloud Storage: ~$500/year
- Cloud Functions: ~$500/year
- **Total**: ~$3,000/year (within budget)

**Timeline Impact**: Faster setup, proceed as planned

**Recommendation**: Choose Firebase for Phase 1 MVP

---

#### Option 3B: AWS (Alternative)

**Pros**:
- More control and flexibility
- Potentially lower long-term costs
- More robust at enterprise scale
- Easier migration path if needed

**Cons**:
- Steeper learning curve
- More complex setup (adds 1-2 weeks to Phase 0)
- Requires more DevOps expertise
- Real-time features require additional work (WebSockets, etc.)

**Cost Estimate (Year 1)**:
- Lambda: ~$500/year
- DynamoDB: ~$1,000/year
- S3: ~$300/year
- API Gateway: ~$500/year
- **Total**: ~$2,300/year

**Timeline Impact**: Adds 1-2 weeks to Phase 0 setup

**Recommendation**: Consider for Phase 2 if Firebase costs become issue

---

### Decision Criteria

**Choose Firebase if**:
- Timeline is critical (June 1, 2026 deadline)
- Team prefers simpler setup
- Real-time features are important (chat)
- Want to minimize DevOps complexity

**Choose AWS if**:
- Team has strong AWS expertise
- Long-term cost optimization is priority
- Want maximum control and flexibility
- Can absorb 1-2 week delay in Phase 0

### Recommended Decision
**Choose Firebase** for the following reasons:
1. Faster setup critical for tight timeline
2. Real-time database perfect for chat feature
3. Simpler for small team (1 backend developer)
4. Lower risk for MVP launch

Can re-evaluate and migrate to AWS in Phase 2 or Phase 3 if needed.

### Decision Required By
**Deadline**: End of Week 3 of Phase 0 (late November 2025)
**Decision Makers**: Backend Lead + Product Manager
**Required Action**: Evaluate both platforms, create Architecture Decision Document (ADD), commit to choice

---

## Decision Summary Table

| Decision | Priority | Deadline | Owner | Status | Blocking? |
|----------|----------|----------|-------|--------|-----------|
| Budget Alignment | ~~CRITICAL~~ | ~~2 weeks~~ | Product Owner | **RESOLVED** ✅ | ~~YES~~ NO |
| NOAA Sensor Availability | ~~HIGH~~ | ~~Week 2 Phase 0~~ | Backend Lead | **RESOLVED** ✅ | ~~YES~~ NO |
| Backend Platform Choice | ~~MEDIUM~~ | ~~Week 3 Phase 0~~ | Backend Lead + PM | **RESOLVED** ✅ | NO |

---

## Next Steps

### Immediate (This Week)
1. **Product Owner**: Review this document
2. **Product Owner**: Schedule stakeholder budget meeting (within 2 weeks)
3. **Product Owner**: Prepare budget justification presentation
4. **Project Team**: Await budget decision before proceeding

### When Phase 0 Begins (November 2025)
1. ~~**Backend Lead**: Start NOAA sensor validation (Day 1 of Phase 0)~~ **COMPLETE** ✅
   - Sensors confirmed via ARCOS system
   - See tracking/P0-001-API-Research-Report.md
2. **Backend Lead**: Contact Dauphin Island Sea Lab for ARCOS API access (Week 1-2)
3. **Backend Lead + PM**: Evaluate Firebase vs AWS (Week 2-3)
4. **Backend Lead**: Test all API integrations (Week 1-2)
5. **All**: Document decisions and update tracking files

### Communication Plan
- **Budget Decision**: Email to all stakeholders within 48 hours of meeting
- **NOAA Sensor Findings**: ✅ **COMPLETE** - See P0-001-API-Research-Report.md (2025-10-18)
- **ARCOS Integration**: Contact Dauphin Island Sea Lab by Week 2 of Phase 0
- **Platform Choice**: Architecture Decision Document by end of Week 3
- **All Decisions**: Update tracking/session-state.md and tracking/phase-status.md

---

## Risk Assessment

### If Budget Decision Delayed Beyond 2 Weeks
- **Impact**: Phase 0 cannot start on time
- **Cascade**: Launch date shifts or requires scope reduction
- **Mitigation**: Make interim decision with contingency for adjustments

### If NOAA Sensors Don't Exist and No Mitigation Plan
- **Impact**: Core product value proposition weakened
- **Cascade**: User trust issues if algorithm is inaccurate
- **Mitigation**: Proactive communication about limitations, deploy sensors in Phase 2

### If Platform Choice Wrong
- **Impact**: May need to migrate infrastructure later
- **Cascade**: Additional costs and engineering time in future
- **Mitigation**: Design with abstraction layers for easier migration if needed

---

## Appendix: Budget Justification Talking Points

**For Stakeholder Presentation**:

1. **Market Rate Reality**: $60/hr for mid-senior developers is competitive for US market
2. **Timeline Constraint**: 7-month timeline requires proper staffing (cannot cut corners)
3. **Seasonal Deadline**: June 1, 2026 is non-negotiable (jubilee season), missing it means 1-year wait
4. **Risk Mitigation**: Proper budget reduces technical debt and quality issues
5. **ROI**: Well-built MVP has better retention and user satisfaction
6. **Comparison**: Similar apps cost $150-250k for MVP (we're efficient at $162k)

**Cost-Cutting Would Result In**:
- Reduced features (lower user value)
- Longer timeline (missed season)
- Technical debt (higher maintenance costs)
- Quality issues (poor user experience)
- Higher risk of project failure

**Investment Value**:
- Proprietary platform for unique phenomenon
- Potential for Phase 2 revenue (premium features, partnerships)
- Community value (preserves cultural tradition)
- Research value (citizen science data)

---

**Document Control**:
- **Version**: 1.0
- **Created**: 2025-10-18
- **Last Updated**: 2025-10-18
- **Next Review**: After stakeholder budget meeting
- **Owner**: Product Manager
- **Distribution**: All stakeholders, project team

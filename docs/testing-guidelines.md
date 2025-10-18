# Testing Guidelines

**Version**: 1.0  
**Last Updated**: 2025-01-20

---

## Overview

This document defines testing standards and practices for ensuring code quality. All production code must have appropriate test coverage before being marked complete.

---

## Testing Strategy

### Test Pyramid

```
        /\
       /UI\         Few, focused on critical flows
      /----\
     /Integ.\       Moderate, test component interaction
    /--------\
   /   Unit   \     Many, test business logic thoroughly
  /____________\
```

---

## Unit Testing

### iOS Unit Tests (XCTest)

**What to Test**:
- Business logic in stores
- Data transformations
- Validation logic
- SwiftData models (basic functionality)
- Utility functions
- Error handling

**Example**:
```swift
import XCTest
@testable import MyApp

final class TaskStoreTests: XCTestCase {
    var store: TaskStore!
    var mockContext: ModelContext!
    
    override func setUp() {
        super.setUp()
        // Setup in-memory SwiftData for testing
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(
            for: Task.self,
            configurations: config
        )
        mockContext = ModelContext(container)
        store = TaskStore(context: mockContext)
    }
    
    override func tearDown() {
        store = nil
        mockContext = nil
        super.tearDown()
    }
    
    func testAddTask() {
        // Given
        let taskTitle = "Test Task"
        
        // When
        store.addTask(title: taskTitle)
        
        // Then
        XCTAssertEqual(store.tasks.count, 1)
        XCTAssertEqual(store.tasks.first?.title, taskTitle)
        XCTAssertFalse(store.tasks.first?.isCompleted ?? true)
    }
    
    func testDeleteTask() {
        // Given
        store.addTask(title: "Task to Delete")
        let task = store.tasks.first!
        
        // When
        store.deleteTask(task)
        
        // Then
        XCTAssertEqual(store.tasks.count, 0)
    }
    
    func testToggleTaskCompletion() {
        // Given
        store.addTask(title: "Task")
        let task = store.tasks.first!
        let initialState = task.isCompleted
        
        // When
        store.toggleCompletion(for: task)
        
        // Then
        XCTAssertNotEqual(task.isCompleted, initialState)
    }
    
    func testAddEmptyTask_ShouldFail() {
        // Given/When
        let result = store.addTask(title: "")
        
        // Then
        XCTAssertFalse(result)
        XCTAssertEqual(store.tasks.count, 0)
    }
}
```

**Best Practices**:
- One test per behavior
- Use Given-When-Then structure
- Descriptive test names
- Test edge cases
- Test error conditions
- Clean up in tearDown
- Use in-memory SwiftData for tests

---

### Web Unit Tests (Jest/Vitest)

**What to Test**:
- Component logic
- State management
- API clients
- Utility functions
- Validation
- Error handling

**Example (React)**:
```typescript
import { describe, it, expect, beforeEach } from 'vitest';
import { renderHook, act } from '@testing-library/react';
import { useTaskStore } from './useTaskStore';

describe('useTaskStore', () => {
  let result: any;

  beforeEach(() => {
    const { result: hookResult } = renderHook(() => useTaskStore());
    result = hookResult;
  });

  it('should add a task', () => {
    act(() => {
      result.current.addTask('New Task');
    });

    expect(result.current.tasks).toHaveLength(1);
    expect(result.current.tasks[0].title).toBe('New Task');
  });

  it('should not add empty task', () => {
    act(() => {
      result.current.addTask('');
    });

    expect(result.current.tasks).toHaveLength(0);
  });

  it('should toggle task completion', () => {
    act(() => {
      result.current.addTask('Task');
    });

    const taskId = result.current.tasks[0].id;
    const initialState = result.current.tasks[0].completed;

    act(() => {
      result.current.toggleTask(taskId);
    });

    expect(result.current.tasks[0].completed).toBe(!initialState);
  });
});
```

---

## Integration Testing

### When to Write Integration Tests

**Phase 2+**: Test component interaction
- Data layer ↔ Business logic
- Business logic ↔ UI
- Multiple services together
- API integration

**iOS Example**:
```swift
final class TaskIntegrationTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()
    }
    
    func testCompleteTaskFlow() {
        // Test adding, completing, and deleting task
        
        // Add task
        app.buttons["Add"].tap()
        let titleField = app.textFields["Task Title"]
        titleField.tap()
        titleField.typeText("Integration Test Task")
        app.buttons["Save"].tap()
        
        // Verify task appears
        XCTAssertTrue(app.staticTexts["Integration Test Task"].exists)
        
        // Complete task
        app.buttons["Integration Test Task"].tap()
        XCTAssertTrue(app.images["checkmark.circle.fill"].exists)
        
        // Delete task
        app.buttons["Integration Test Task"].swipeLeft()
        app.buttons["Delete"].tap()
        XCTAssertFalse(app.staticTexts["Integration Test Task"].exists)
    }
}
```

---

## UI/E2E Testing

### When to Write UI Tests

**Phase 3+**: Critical user flows only
- User registration/login
- Core transactions
- Critical business flows

**Keep UI tests minimal**:
- Slow to run
- Brittle
- Expensive to maintain
- Focus on happy paths

**iOS UI Tests**:
```swift
final class TaskUITests: XCTestCase {
    func testCriticalUserFlow() {
        let app = XCUIApplication()
        app.launch()
        
        // Test complete user journey
        // Only for P1 critical flows
    }
}
```

**Web E2E (Playwright)**:
```typescript
import { test, expect } from '@playwright/test';

test('user can manage tasks', async ({ page }) => {
  await page.goto('http://localhost:3000');
  
  // Add task
  await page.fill('[data-testid="task-input"]', 'E2E Test Task');
  await page.click('[data-testid="add-button"]');
  
  // Verify
  await expect(page.locator('text=E2E Test Task')).toBeVisible();
  
  // Complete task
  await page.click('[data-testid="task-0"]');
  await expect(page.locator('[data-testid="task-0"]')).toHaveClass(/completed/);
  
  // Delete task
  await page.click('[data-testid="delete-0"]');
  await expect(page.locator('text=E2E Test Task')).not.toBeVisible();
});
```

---

## Test Coverage Requirements

### Minimum Coverage by Phase

**Phase 1**:
- Unit tests: ≥ 70% coverage
- Business logic: 100% coverage
- Integration tests: Optional
- UI tests: None required

**Phase 2**:
- Unit tests: ≥ 75% coverage
- Integration tests: Critical paths
- UI tests: Optional

**Phase 3+**:
- Unit tests: ≥ 80% coverage
- Integration tests: All integration points
- UI tests: P1 critical flows

---

## Testing Best Practices

### General

1. **Test Behavior, Not Implementation**
   ```swift
   // ❌ Bad: Testing implementation
   func testTaskArrayHasOneElement() { }
   
   // ✅ Good: Testing behavior
   func testAddingTaskIncreasesTaskCount() { }
   ```

2. **Use Descriptive Names**
   ```swift
   // ❌ Bad
   func testTask1() { }
   
   // ✅ Good
   func testAddingTaskWithEmptyTitleShowsError() { }
   ```

3. **One Assertion Per Concept**
   ```swift
   func testTaskCreation() {
       // Test one thing well
       XCTAssertEqual(task.title, "Test")
   }
   ```

4. **Arrange-Act-Assert (AAA)**
   ```swift
   func testExample() {
       // Arrange (Given)
       let store = TaskStore()
       
       // Act (When)
       store.addTask(title: "Task")
       
       // Assert (Then)
       XCTAssertEqual(store.tasks.count, 1)
   }
   ```

---

### iOS Specific

1. **Use In-Memory SwiftData**
   ```swift
   let config = ModelConfiguration(isStoredInMemoryOnly: true)
   ```

2. **Clean State Between Tests**
   ```swift
   override func tearDown() {
       // Reset all state
       super.tearDown()
   }
   ```

3. **Test Async Code Properly**
   ```swift
   func testAsyncFetch() async throws {
       let result = try await store.fetchTasks()
       XCTAssertNotNil(result)
   }
   ```

4. **Mock Network Calls**
   ```swift
   protocol TaskAPI {
       func fetchTasks() async throws -> [Task]
   }
   
   class MockTaskAPI: TaskAPI {
       func fetchTasks() async throws -> [Task] {
           // Return mock data
       }
   }
   ```

---

### Web Specific

1. **Mock API Calls**
   ```typescript
   vi.mock('./api/tasks', () => ({
       fetchTasks: vi.fn(() => Promise.resolve([]))
   }));
   ```

2. **Test Hooks**
   ```typescript
   const { result } = renderHook(() => useTaskStore());
   ```

3. **Test Components**
   ```typescript
   render(<TaskList tasks={mockTasks} />);
   ```

---

## Test Organization

### iOS Project Structure

```
Tests/
├── UnitTests/
│   ├── Models/
│   │   └── TaskTests.swift
│   ├── Stores/
│   │   └── TaskStoreTests.swift
│   └── Services/
│       └── NetworkServiceTests.swift
├── IntegrationTests/
│   └── TaskFlowTests.swift
└── UITests/
    └── CriticalFlowTests.swift
```

### Web Project Structure

```
tests/
├── unit/
│   ├── components/
│   ├── hooks/
│   └── utils/
├── integration/
│   └── api/
└── e2e/
    └── critical-flows/
```

---

## Running Tests

### iOS

```bash
# Run all tests
xcodebuild test \
  -project MyApp.xcodeproj \
  -scheme MyApp \
  -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test
xcodebuild test \
  -project MyApp.xcodeproj \
  -scheme MyApp \
  -only-testing:MyAppTests/TaskStoreTests/testAddTask

# Generate coverage
xcodebuild test \
  -project MyApp.xcodeproj \
  -scheme MyApp \
  -enableCodeCoverage YES
```

### Web

```bash
# Run all tests
npm test

# Watch mode
npm test -- --watch

# Coverage
npm test -- --coverage

# Specific test
npm test TaskStore.test.ts
```

---

## Mock Data in Tests

### Use Realistic Mock Data

```swift
// ✅ Good: Realistic test data
let mockTask = Task(
    title: "Review pull request",
    isCompleted: false,
    dueDate: Date().addingTimeInterval(86400)
)

// ❌ Bad: Meaningless test data
let mockTask = Task(title: "Test", isCompleted: false)
```

### Create Test Fixtures

```swift
struct TaskFixtures {
    static let singleTask = Task(title: "Single Task")
    
    static let multipleTasks = [
        Task(title: "Task 1"),
        Task(title: "Task 2"),
        Task(title: "Task 3")
    ]
    
    static let completedTask = Task(
        title: "Completed",
        isCompleted: true
    )
}
```

---

## Test-Driven Development (TDD)

### Recommended for Phase 2+

**TDD Cycle**:
1. Write failing test
2. Write minimal code to pass
3. Refactor
4. Repeat

**Benefits**:
- Better design
- Higher confidence
- Living documentation
- Fewer bugs

**Example**:
```swift
// 1. Write test first (fails)
func testFilterCompletedTasks() {
    let tasks = [
        Task(title: "Task 1", isCompleted: true),
        Task(title: "Task 2", isCompleted: false)
    ]
    let filtered = TaskStore.filterCompleted(tasks)
    XCTAssertEqual(filtered.count, 1)
}

// 2. Implement feature
extension TaskStore {
    static func filterCompleted(_ tasks: [Task]) -> [Task] {
        tasks.filter { $0.isCompleted }
    }
}

// 3. Test passes ✅
```

---

## Continuous Integration

### Running Tests in CI

**Every commit should**:
- Run all unit tests
- Run integration tests
- Generate coverage report
- Fail build if tests fail

**GitHub Actions Example**:
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run tests
        run: xcodebuild test \
          -project MyApp.xcodeproj \
          -scheme MyApp \
          -destination 'platform=iOS Simulator,name=iPhone 15'
```

---

## Troubleshooting Tests

### Flaky Tests

**Causes**:
- Race conditions
- Time dependencies
- External dependencies
- Shared state

**Solutions**:
- Use async/await properly
- Mock time
- Mock external services
- Isolate test state

### Slow Tests

**Solutions**:
- Use in-memory databases
- Mock network calls
- Parallel test execution
- Focus on unit tests

---

## Quality Gates for Tests

**Before marking complete**:
- [ ] All tests passing
- [ ] Coverage ≥ target
- [ ] No flaky tests
- [ ] No skipped tests
- [ ] Tests run in CI
- [ ] Fast execution (< 30s for unit tests)

---

## Related Documentation

- [Quality Gates](./quality-gates.md) - Completion criteria
- [iOS Development](./ios-development.md) - iOS standards
- [Project Management](./project-management.md) - Phase planning
- [Main Index](../claude.md) - Complete workflow

---

**Last Updated**: 2025-01-20  
**Version**: 1.0
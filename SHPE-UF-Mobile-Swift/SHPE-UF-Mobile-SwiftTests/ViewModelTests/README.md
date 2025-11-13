# ViewModel Unit Tests

This directory contains unit tests for ViewModels and other non-UI business logic in the SHPE UF Mobile app.

## Overview

These tests focus on testing the **logic** of ViewModels, not the UI itself. They verify that:
- Events are loaded correctly (both dummy and fetched)
- Event types are properly classified
- Events are sorted correctly
- Core Data operations work as expected
- Edge cases are handled properly

## Running Tests

### Option 1: Using Xcode UI
1. Open `SHPE-UF-Mobile-Swift.xcodeproj` in Xcode
2. Press `Cmd + U` to run all tests
3. Or click the diamond icon next to any test class/method to run specific tests
4. View results in the Test Navigator (Cmd + 6)

### Option 2: Using Xcode Test Navigator
1. Open Xcode
2. Press `Cmd + 6` to open Test Navigator
3. Click the play button next to:
   - The entire test target (run all tests)
   - A specific test file (run all tests in that file)
   - A specific test method (run just that test)

### Option 3: Using Command Line
```bash
# Navigate to project directory
cd /Users/matthewsegura/Documents/dev/repos/SHPE-UF-Mobile-Swift

# Run all tests
xcodebuild test -project SHPE-UF-Mobile-Swift/SHPE-UF-Mobile-Swift.xcodeproj \
  -scheme SHPE-UF-Mobile-Swift -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test class
xcodebuild test -project SHPE-UF-Mobile-Swift/SHPE-UF-Mobile-Swift.xcodeproj \
  -scheme SHPE-UF-Mobile-Swift -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:SHPE-UF-Mobile-SwiftTests/HomeViewModelTests

# Run specific test method
xcodebuild test -project SHPE-UF-Mobile-Swift/SHPE-UF-Mobile-Swift.xcodeproj \
  -scheme SHPE-UF-Mobile-Swift -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:SHPE-UF-Mobile-SwiftTests/HomeViewModelTests/testCreateDummyEvents
```

## Test Structure

### HomeViewModelTests.swift
Tests for the HomeViewModel including:
- **Dummy Event Creation**: Verifies that dummy events are created correctly for testing
- **Event Type Classification**: Tests that events are categorized correctly (GBM, Workshop, Social, etc.)
- **Upcoming Events Filter**: Tests the `getUpcomingEvents()` method
- **Event Sorting**: Verifies events are sorted by start date
- **Core Data Integration**: Tests saving events to Core Data
- **Load Modes**: Tests different initialization modes (dummyOnly, fetchedOnly, combined)
- **Performance Tests**: Measures performance of key operations

### TestHelpers.swift
Contains utilities to make testing easier:
- **MockCoreDataStack**: In-memory Core Data for testing
- **EventFactory**: Helper methods to create test events quickly
- **Date Extensions**: Convenient date manipulation for tests
- **XCTest Extensions**: Common async waiting utilities

## Adding New Tests

### 1. Create a New Test File
```swift
import XCTest
import CoreData
@testable import SHPE_UF_Mobile_Swift

final class YourViewModelTests: XCTestCase {
    var viewModel: YourViewModel!
    var mockContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockContext = MockCoreDataStack.shared.viewContext
        // Initialize your ViewModel
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try MockCoreDataStack.shared.clearAllData()
        try super.tearDownWithError()
    }

    func testYourFeature() throws {
        // Given (setup)

        // When (execute)

        // Then (verify)
        XCTAssertTrue(condition, "message")
    }
}
```

### 2. Add the File to the Test Target
1. In Xcode, right-click on `ViewModelTests` folder
2. Select "New File..."
3. Choose "Unit Test Case Class"
4. Make sure the test target is selected
5. Write your tests!

## Test Naming Conventions

Follow this pattern for test method names:
```swift
func test{FeatureName}_{ExpectedBehavior}() throws {
    // test code
}
```

Examples:
- `testCreateDummyEvents_CreatesThreeEvents()`
- `testGetUpcomingEvents_FiltersCorrectly()`
- `testUpdateEventTypes_ClassifiesGBMCorrectly()`

## Common Test Patterns

### Testing Async Code
```swift
func testAsyncOperation() throws {
    let expectation = expectation(description: "Async call")

    viewModel.performAsyncOperation { result in
        // Verify result
        XCTAssertNotNil(result)
        expectation.fulfill()
    }

    waitForExpectations(timeout: 2.0)
}
```

### Testing Core Data
```swift
func testSavingToCoreData() throws {
    // Save data
    viewModel.saveData()

    // Fetch and verify
    let fetchRequest = YourEntity.fetchRequest()
    let results = try mockContext.fetch(fetchRequest)
    XCTAssertEqual(results.count, expectedCount)
}
```

### Testing Published Properties
```swift
func testPublishedProperty() throws {
    let expectation = expectation(description: "Published property changes")

    let cancellable = viewModel.$events.sink { events in
        if !events.isEmpty {
            expectation.fulfill()
        }
    }

    viewModel.loadEvents()
    waitForExpectations(timeout: 1.0)
    cancellable.cancel()
}
```

## Best Practices

1. **Test One Thing**: Each test should verify one specific behavior
2. **Use Given-When-Then**: Structure tests clearly
   - Given: Setup the test conditions
   - When: Execute the code being tested
   - Then: Verify the results
3. **Descriptive Names**: Test names should describe what they test
4. **Independent Tests**: Tests should not depend on each other
5. **Clean Up**: Use `tearDownWithError()` to clean up after tests
6. **Use Mocks**: Use in-memory Core Data, not the production database
7. **Test Edge Cases**: Test empty lists, nil values, invalid inputs
8. **Performance Tests**: Add performance tests for critical operations

## Continuous Integration

To run tests automatically on every commit, add this to your CI/CD pipeline:

### GitHub Actions Example
```yaml
- name: Run Tests
  run: |
    xcodebuild test \
      -project SHPE-UF-Mobile-Swift/SHPE-UF-Mobile-Swift.xcodeproj \
      -scheme SHPE-UF-Mobile-Swift \
      -destination 'platform=iOS Simulator,name=iPhone 15' \
      -enableCodeCoverage YES
```

## Code Coverage

To view code coverage:
1. Run tests with `Cmd + U`
2. Open the Report Navigator (Cmd + 9)
3. Click on the latest test run
4. Select the "Coverage" tab
5. Review which lines are covered by tests

## Troubleshooting

### Tests Not Found
- Make sure the test file is added to the test target
- Check that the test class inherits from `XCTestCase`
- Verify test methods start with `test`

### Core Data Errors
- Make sure you're using `MockCoreDataStack` for testing
- Clear data in `tearDownWithError()`
- Check that the Core Data model name matches

### Async Tests Timing Out
- Increase timeout: `waitForExpectations(timeout: 5.0)`
- Verify `expectation.fulfill()` is actually called
- Check for race conditions

### Import Errors
- Use `@testable import SHPE_UF_Mobile_Swift` to access internal types
- Ensure the main target is building successfully

## Future Improvements

Consider adding tests for:
- [ ] ProfileViewModel
- [ ] PointsViewModel
- [ ] NotificationViewModel
- [ ] EventCreatorViewModel
- [ ] SignInViewModel
- [ ] RegisterViewModel
- [ ] Network layer (RequestHandler)
- [ ] Core Data models
- [ ] Utility functions
- [ ] Integration tests

## Resources

- [Apple XCTest Documentation](https://developer.apple.com/documentation/xctest)
- [Testing in Xcode](https://developer.apple.com/documentation/xcode/testing-your-apps-in-xcode)
- [Unit Testing Best Practices](https://developer.apple.com/videos/play/wwdc2019/413/)

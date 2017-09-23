//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Vincent on 8/13/17.
//
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {

    /* override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    } */
    
    // MARK: - Meal Class Tests
    // Confirm meal intiailizer returns Meal object when passed valid parameters
    func testMealInitializationSucceeds() {
        // Zero rating
        let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        // Highest rating
        let positiveRatingMeal = Meal.init(name: "Highest", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }
    
    // Confirm meal initializer returns nil when passed invalid parameters
    func testMealInitializationFails() {
        // Negative rating
        let negativeRatingMeal = Meal.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        // No name
        let noNameMeal = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(noNameMeal)
        
        // Rating exceeds maximum
        let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
    }
    
}

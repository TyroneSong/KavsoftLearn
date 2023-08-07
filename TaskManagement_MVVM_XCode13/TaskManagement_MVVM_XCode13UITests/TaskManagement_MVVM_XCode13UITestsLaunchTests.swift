//
//  TaskManagement_MVVM_XCode13UITestsLaunchTests.swift
//  TaskManagement_MVVM_XCode13UITests
//
//  Created by 宋璞 on 2023/8/4.
//

import XCTest

final class TaskManagement_MVVM_XCode13UITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

//
//  TemperatureFormatterTests.swift
//  TemperatureFormatterTests
//
//  Created by Anton Chebotov on 23/12/2024.
//

import XCTest
@testable import WeatherChallenge

final class TemperatureFormatterTests: XCTestCase {

    let sut = TemperatureFormatter()

    func test_WhenConvertingIntTempToString_ThenCorrectValueReturned() {
        let result = sut.temperatureDescription(temp: 100)

        XCTAssertEqual(result, "+100°")
    }

    func test_WhenConvertingPositiveFloatTempToString_ThenCorrectValueReturned() {
        let result = sut.temperatureDescription(temp: 1.078354)

        XCTAssertEqual(result, "+1°")
    }

    func test_WhenConvertingSmallPositiveFloatTempToString_ThenCorrectValueReturned() {
        let result = sut.temperatureDescription(temp: 0.078354)

        XCTAssertEqual(result, "0°")
    }

    func test_WhenConvertingZeroTempToString_ThenCorrectValueReturned() {
        let result = sut.temperatureDescription(temp: 0)

        XCTAssertEqual(result, "0°")
    }

    func test_WhenConvertingNegativeTempToString_ThenCorrectValueReturned() {
        let result = sut.temperatureDescription(temp: -9.3)

        XCTAssertEqual(result, "-9°")
    }
}

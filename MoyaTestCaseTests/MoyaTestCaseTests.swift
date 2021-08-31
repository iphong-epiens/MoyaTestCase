//
//  MoyaTestCaseTests.swift
//  MoyaTestCaseTests
//
//  Created by Inpyo Hong on 2021/08/30.
//

import XCTest
import RxMoya
import RxSwift
import Combine
import Moya

@testable import MoyaTestCase

class MoyaTestCaseTests: XCTestCase {
    var sut: JokesAPIProvider!
    var cancellable = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
     sut = JokesAPIProvider(isStub: true)
    }
    
    func test_fetchRandomJokes_success() {
        let expectation = XCTestExpectation()

//        let expectedJoke = sut
//            .fetchRandomJoke("Gro", "Hong", ["nerdy"])
//            .sampleData
//          //  .sampleDecodable(JokeReponse.self)?.value

//        print(expectedJoke)
        
        //RxSwift
//        sut.fetchRandomJoke(firstName: "Gro", lastName: "Hong", categories: ["nerdy"])
//            .subscribe(onSuccess: { joke in
//                XCTAssertEqual("Gro Hong can retrieve anything from /dev/null.", joke.joke)
//                expectation.fulfill()
//            })
//            .dispose()
        
        //Combine
        sut.fetchRandomJoke(firstName: "Inpyo", lastName: "Hong", categories: ["nerdy"])
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { joke in
                print(joke)
                XCTAssertEqual("Inpyo Hong can retrieve anything from /dev/null.", joke.joke)
                expectation.fulfill()
            })
            .store(in: &cancellable)
        
        wait(for: [expectation], timeout: 2.0)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

//
//  MoyaTestCaseApp.swift
//  MoyaTestCase
//
//  Created by Inpyo Hong on 2021/08/30.
//

import SwiftUI
import RxSwift
import Combine
import Moya
@main
struct MoyaTestCaseApp: App {
    var disposeBag = DisposeBag()
    
    init() {
        //apiTest()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func apiTest() {
        let provider = JokesAPIProvider()
        var cancellables = Set<AnyCancellable>()

        provider.fetchRandomJoke(firstName: "Gildong", lastName: "Hong", categories: ["nerdy"])
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { result in
                print(result.joke)
            })
            .store(in: &cancellables)

    }
}

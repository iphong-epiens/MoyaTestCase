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
    var cancellables = Set<AnyCancellable>()
    
    init() {
        let provider = JokesAPIProvider(isStub: false)
        
        provider.fetchRandomJoke(firstName: "Gildong", lastName: "Hong", categories: ["nerdy"])
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { result in
                print(result.joke)
            })
            .store(in: &cancellables)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

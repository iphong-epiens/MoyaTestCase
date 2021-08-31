//
//  MoyaTestCaseApp.swift
//  MoyaTestCase
//
//  Created by Inpyo Hong on 2021/08/30.
//

import SwiftUI
import Combine
import Moya

/*
 iOS Networking and Testing Demo
: https://techblog.woowahan.com/2704/
 */

@main
struct MoyaTestCaseApp: App {
    let provider = JokesAPIProvider()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        provider.fetchRandomJoke(firstName: "Inpyo", lastName: "Hong", categories: ["nerdy"])
            .sink(receiveCompletion: { completion in
                print(completion)
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

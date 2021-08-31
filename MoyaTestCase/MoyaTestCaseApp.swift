//
//  MoyaTestCaseApp.swift
//  MoyaTestCase
//
//  Created by Inpyo Hong on 2021/08/30.
//

import SwiftUI
import RxSwift

@main
struct MoyaTestCaseApp: App {
    var disposeBag = DisposeBag()
    
    init() {
        JokesAPI
            .randomJokes("Inpyo", "Hong", ["nerdy"])
            
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

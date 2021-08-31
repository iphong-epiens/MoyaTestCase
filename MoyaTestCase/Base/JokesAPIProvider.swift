//
//  JokesAPIProvider.swift
//  MoyaTestCase
//
//  Created by Inpyo Hong on 2021/08/31.
//

import Foundation
import Moya
import RxSwift

class JokesAPIProvider: ProviderProtocol {

    typealias T = JokesAPI
    var provider: MoyaProvider<JokesAPI>

    required init(isStub: Bool = false, sampleStatusCode: Int = 200, customEndpointClosure: ((T) -> Endpoint)? = nil) {
        provider = Self.consProvider(isStub, sampleStatusCode, customEndpointClosure)
    }

    func fetchRandomJoke(firstName: String? = nil, lastName: String? = nil, categories: [String] = []) -> Single<Joke> {
        return request(type: Joke.self, atKeyPath: "value", target: .randomJokes(firstName, lastName, categories))
    }
}

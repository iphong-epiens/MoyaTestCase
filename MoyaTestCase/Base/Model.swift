//
//  Model.swift
//  MoyaTestCase
//
//  Created by Inpyo Hong on 2021/08/30.
//

import Foundation
import Moya
import RxMoya
import Alamofire
import RxSwift

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

struct JokeReponse: Decodable {
    let type: String
    let value: Joke
}

struct Joke: Decodable {
    let id: Int
    let joke: String
    let categories: [String]
}

enum JokesAPI {
    case randomJokes(_ firstName: String? = nil,
                     _ lastName: String? = nil,
                     _ categories: [String] = [])
}

extension JokesAPI: TargetType {
    var baseURL: URL {
        URL(string: "http://api.icndb.com")!
    }
    
    var path: String {
       "/jokes/random"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var headers: [String : String]? {
        nil
    }

    var sampleData: Data {
        switch self {
        
        case .randomJokes(let firstName, let lastName, let categoris):
            let firstName = firstName ?? "Chuck"
            let lastName = lastName ?? "Norris"

            return Data(
                """
                {
                   "type": "success",
                       "value": {
                       "id": 107,
                       "joke": "\(firstName) \(lastName) can retrieve anything from /dev/null.",
                       "categories": \(categoris)
                   }
                }
                """.utf8
            )
        }
    }

    var task: Task {
        switch self {
        case .randomJokes(let firstName, let lastName, let categories):
            var params: [String: Any?] = [
                "firstName": firstName,
                "lastName": lastName
            ]

            if categories.isEmpty == false {
                params["limitTo"] = "(categories)"
            }

            return .requestParameters(parameters: params as [String : Any], encoding: URLEncoding.queryString)
        }
    }
}

public protocol ProviderProtocol: AnyObject {
    associatedtype T: TargetType

    var provider: MoyaProvider<T> { get }
    init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((T) -> Endpoint)?)
}

public extension ProviderProtocol {

    static func consProvider(
        _ isStub: Bool = false,
        _ sampleStatusCode: Int = 200,
        _ customEndpointClosure: ((T) -> Endpoint)? = nil) -> MoyaProvider<T> {

        if isStub == false {
            return MoyaProvider<T>(
                endpointClosure: {
                    MoyaProvider<T>.defaultEndpointMapping(for: $0).adding(newHTTPHeaderFields: [:])
                },
                session: Session.default,
                plugins: []// ex - logging, network activity indicator
            )
        } else {
            // 테스트 시에 호출되는 stub 클로져
            let endPointClosure = { (target: T) -> Endpoint in
                let sampleResponseClosure: () -> EndpointSampleResponse = {
                    EndpointSampleResponse.networkResponse(sampleStatusCode, target.sampleData)
                }

                return Endpoint(
                    url: URL(target: target).absoluteString,
                    sampleResponseClosure: sampleResponseClosure,
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
            }
            return MoyaProvider<T>(
                endpointClosure: customEndpointClosure ?? endPointClosure,
                stubClosure: MoyaProvider.immediatelyStub
            )
        }
    }
}

extension ProviderProtocol {
    func request<D: Decodable>(type: D.Type, atKeyPath keyPath: String? = nil, target: T) -> Single<D> {
        provider.rx.request(target)
            .map(type, atKeyPath: keyPath)
            // some operators
    }
}

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

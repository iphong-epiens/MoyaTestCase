//
//  JokerAPI.swift
//  MoyaTestCase
//
//  Created by Inpyo Hong on 2021/08/31.
//

import Foundation
import Moya
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

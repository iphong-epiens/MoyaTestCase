//
//  JokerAPI.swift
//  MoyaTestCase
//
//  Created by Inpyo Hong on 2021/08/31.
//

import Foundation
import Moya


enum JokeAPI {
    case randomJokes(_ firstName: String? = nil, _ lastName: String? = nil)
}

extension JokeAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://api.icndb.com")!
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
        
        case .randomJokes(let firstName, let lastName):
            let firstName = firstName ?? "Chuck"
            let lastName = lastName ?? "Norris"

            return Data(
                """
                {
                   "type": "success",
                       "value": {
                       "id": 107,
                       "joke": "\(firstName) \(lastName) can retrieve anything from /dev/null."
                   }
                }
                """.utf8
            )
        }
    }
  
    var task: Moya.Task {
        switch self {
        case .randomJokes(let firstName, let lastName):
            let params: [String: Any] = [
                "firstName": firstName!,
                "lastName": lastName!
            ]

            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
}

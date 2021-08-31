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

struct JokeReponse: Decodable {
    let type: String
    let value: Joke
}

struct Joke: Decodable {
    let id: Int
    let joke: String
    let categories: [String]
}




//
//  JSONService.swift
//  PryanikMVVM
//
//  Created by Владимир on 03.02.2021.
//

import Foundation
import Moya

enum NetworkMenager: TargetType {
    
    case getData
    case getImage(url: String)
    
    var baseURL: URL {
        switch self {
        case .getData:
            return URL(string: "https://pryaniky.com/static/json/sample.json")!
        case .getImage(let url):
            return URL(string: url)!
        }
    }
    
    var path: String {
        switch self {
        case .getData:
            return ""
        case .getImage(_):
            return ""
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var task: Task {
        switch self {
        case .getData:
            return .requestPlain
        case .getImage(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}


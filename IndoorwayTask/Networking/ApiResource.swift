//
//  ApiResource.swift
//  IndoorwayTask
//
//  Created by Jakub Matuła on 16/09/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation

typealias Serialization = [String: Any]

protocol ApiResource {
    associatedtype Model
    var endpointPath: String { get }
    var baseURL: String { get }
    var index: Int? { get }
    func createModel(jsonDict: Serialization) -> Model?
}

extension ApiResource {
    var url: URL {
        var url: String
        if let index = index {
            url = baseURL + "/" + endpointPath + "/\(index)"
        } else {
            url = baseURL + "/" + endpointPath
        }
        return URL(string: url)!
    }
    
    func createModel(data: Data) -> Model? {
        guard let json = try? JSONSerialization.jsonObject(with: data),
            let jsonDict = json as? Serialization else {
                return nil
        }
        return createModel(jsonDict: jsonDict)
    }
}

struct PhotoResource: ApiResource {
    func createModel(jsonDict: Serialization) -> TypicodePhoto? {
        return TypicodePhoto(json: jsonDict)
    }
    
    var endpointPath = "/photo"
    var baseURL = "https://jsonplaceholder.typicode.com"
    var index: Int?
    typealias Model = TypicodePhoto
}

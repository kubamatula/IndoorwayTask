//
//  NetworkRequest.swift
//  IndoorwayTask
//
//  Created by Jakub Matuła on 16/09/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation
import UIKit

class WebSerivce {
    func load<A>(resource: Resource<A>, completion: @escaping (A?) -> Void) {
        URLSession.shared.dataTask(with: resource.url) { data, _, _ in
            let objects = data.flatMap(resource.parse)
            completion(objects)
            }.resume()
    }
}

struct Resource<A>{
    let url: URL
    let parse: (Data) -> A?
}

extension Resource where A: Decodable {
    init(url: URL, decoder: JSONDecoder = JSONDecoder()) {
        let parse: (Data) -> A? = { data in
            let decoder = JSONDecoder()
            return try? decoder.decode(A.self, from: data)
        }
        self.init(url: url, parse: parse)
    }
}

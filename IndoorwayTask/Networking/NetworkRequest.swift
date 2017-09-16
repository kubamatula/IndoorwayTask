//
//  NetworkRequest.swift
//  IndoorwayTask
//
//  Created by Jakub Matuła on 16/09/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkRequest: class {
    associatedtype Model
    func load(withCompletion completion: @escaping (Model?) -> Void)
    func decode(_ data: Data) -> Model?
}

extension NetworkRequest {
    fileprivate func load(_ url: URL, withCompletion completion: @escaping (Model?) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let data = data else {
                completion(nil)
                return
            }
            completion(self.decode(data))
        }
        task.resume()
    }
}

class ImageRequest {
    let url: URL
    init(url: URL) {
        self.url = url
    }
    
    init?(url: String){
        guard let url = URL(string: url) else {
            return nil
        }
        self.url = url
    }
}

extension ImageRequest: NetworkRequest {
    
    typealias Model = UIImage
    
    func decode(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    func load(withCompletion completion: @escaping (UIImage?) -> Void) {
        load(url, withCompletion: completion)
    }
}

class ApiRequest<Resource: ApiResource> {
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
}

extension ApiRequest: NetworkRequest {
    func decode(_ data: Data) -> Resource.Model? {
        return resource.createModel(data: data)
    }
    
    func load(withCompletion completion: @escaping (Resource.Model?) -> Void) {
        load(resource.url, withCompletion: completion)
    }
}


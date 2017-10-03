//
//  TypicodeEndpoints.swift
//  IndoorwayTask
//
//  Created by Jakub Matuła on 03/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation

enum TypicodeEndpoints: String {
    case posts = "posts"
    case comments = "comments"
    case albums = "albums"
    case photos = "photos"
    case todos = "todos"
    case users = "users"
    
    var url: URL {
        let baseURL: String = "https://jsonplaceholder.typicode.com/"
        return URL(string: baseURL + rawValue)!
    }
}

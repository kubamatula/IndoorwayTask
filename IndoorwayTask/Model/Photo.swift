//
//  TypicodePhotoItem.swift
//  IndoorwayTask
//
//  Created by Jakub Matuła on 16/09/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation
import UIKit

struct Photo: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: URL
    let thumbnailUrl: URL
    
    var thumbnail: Resource<UIImage> {
        return Resource(url: thumbnailUrl, parse: { return UIImage(data: $0) })
    }
}

extension Photo {
    static var all: Resource<[Photo]> {
        return Resource(url: TypicodeEndpoints.photos.url)
    }
    
    static func resource(id: Int) -> Resource<Photo> {
        let url = TypicodeEndpoints.photos.url.appendingPathComponent("/\(id)")
        return Resource(url: url)
    }
}

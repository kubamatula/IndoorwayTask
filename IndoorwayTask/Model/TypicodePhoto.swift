//
//  TypicodePhoto.swift
//  IndoorwayTask
//
//  Created by Jakub Matuła on 16/09/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation

public struct TypicodePhoto {
    let id: Int
    let albumId: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    
    struct PropertyKey {
        static let id = "id"
        static let albumId = "albumId"
        static let title = "title"
        static let url = "url"
        static let thumbnailUrl = "thumbnailUrl"
        
    }
}


extension TypicodePhoto {
    init?(json: [String: Any]) {
        guard let id = json[PropertyKey.id] as? Int,
            let albumId = json[PropertyKey.albumId] as? Int,
            let title = json[PropertyKey.title] as? String,
            let url = json[PropertyKey.url] as? String,
            let thumbnailUrl = json[PropertyKey.thumbnailUrl] as? String
            else {
                return nil
        }
        self.init(id: id, albumId: albumId, title: title, url: url, thumbnailUrl: thumbnailUrl)
    }
}

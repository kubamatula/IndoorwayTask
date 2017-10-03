//
//  PhotoCache.swift
//  IndoorwayTask
//
//  Created by Jakub Matuła on 03/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    private let cache: NSCache<NSNumber,UIImage> = NSCache()
    static let sharedInstance = ImageCache()
    
    func image(forKey key: Int) -> UIImage? {
        return cache.object(forKey: key as NSNumber)
    }
    
    func setImage(_ image: UIImage, forKey key: Int) {
        let photoSize = UIImagePNGRepresentation(image)?.count
        cache.setObject(image, forKey: key as NSNumber, cost: photoSize ?? 1)
    }
}

//
//  PhotoCollectionViewDataSource.swift
//  IndoorwayTask
//
//  Created by Jakub Matuła on 03/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import UIKit

class PhotoCollectionViewDataSource: NSObject {
    var photos: [Photo] {
        didSet {
            if photos.count == 0 {
                collectionView.backgroundView?.isHidden = false
            } else {
                collectionView.backgroundView?.isHidden = true
            }
        }
    }
    
    private var photoIndex = 0
    private let thumbnailCache = ImageCache.sharedInstance
    private let webService: WebSerivce
    weak private(set) var collectionView: UICollectionView!
    
    init(collectionView: UICollectionView, photos: [Photo] = [], webService: WebSerivce = WebSerivce()) {
        self.photos = photos
        self.webService = webService
        self.collectionView = collectionView
        
        super.init()
        
        let noItemsLabel = self.noItemsLabel(text: "Brak miniaturek do wyświetlenia")
        noItemsLabel.center = collectionView.center
        collectionView.backgroundView = noItemsLabel
    }
    
    //MARK:- Photo manipulation methods
    func addNextPhoto() {
        photoIndex += 1
        let photoResource = Photo.resource(id: photoIndex)
        
        webService.load(resource: photoResource){ [weak self] photo in
            guard let photo = photo else { return }
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                strongSelf.photos.append(photo)
                strongSelf.collectionView.reloadData()
                
                //scrolling to the newly added item
                let lastItemIndex = strongSelf.photos.count - 1
                strongSelf.collectionView.scrollToItem(at: IndexPath(item: lastItemIndex, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    func clear() {
        photoIndex = 0
        photos = []
        collectionView.reloadData()
    }
    
    private func noItemsLabel(text: String) -> UILabel {
        let noItemsLabel = UILabel(frame: .zero)
        noItemsLabel.text = text
        noItemsLabel.font = UIFont(name: noItemsLabel.font.fontName, size: 25)
        noItemsLabel.numberOfLines = 0
        noItemsLabel.sizeToFit()
        noItemsLabel.textAlignment = .center
        return noItemsLabel
    }
    
    
}


//MARK:- UICollectionViewDataSource
extension PhotoCollectionViewDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoThumbnailCollectionViewCell.identifier, for: indexPath) as! PhotoThumbnailCollectionViewCell
        let photo = photos[indexPath.row]
        cell.title = photo.title
        if let image = thumbnailCache.image(forKey: photo.id) {
            cell.image = image
        } else {
            cell.startSpinner()
            webService.load(resource: photo.thumbnail) { [weak cell, weak self] image in
                DispatchQueue.main.async {
                    guard let image = image else { return }
                    self?.thumbnailCache.setImage(image, forKey: photo.id)
                    cell?.image = image
                }
            }
        }
        return cell
    }
}

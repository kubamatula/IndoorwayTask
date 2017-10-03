//
//  PhotoCollectionViewController.swift
//  IndoorwayTask
//
//  Created by Jakub Matuła on 16/09/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import UIKit

private let thumbnailCellId = "ThumbnailCell"
private let initialPhotoIndex = 0

class PhotoCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noPhotoItemsLabel: UILabel!
    
    private let webService = WebSerivce()
    
    fileprivate var photoItems = [Photo]() {
        didSet {
            if photoItems.isEmpty {
                noPhotoItemsLabel.isHidden = false
            } else {
                noPhotoItemsLabel.isHidden = true
            }
        }
    }
    
    fileprivate var thumbnailCache: NSCache<NSNumber,UIImage> = NSCache()
    private var photoIndex = initialPhotoIndex
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewHorizontallySeperatedLayout()
    }
    
    // MARK: - UIInteraction
    @IBAction func resetCollection(_ sender: UIButton) {
        photoItems.removeAll()
        photoIndex = initialPhotoIndex
        collectionView.reloadData()
    }
    
    @IBAction func addNextPhoto(_ sender: UIButton) {
        photoIndex += 1
        let photoResource = Photo.resource(id: photoIndex)
        
        webService.load(resource: photoResource){ [weak self] photo in
            guard let photo = photo else { return }
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                strongSelf.photoItems.append(photo)
                strongSelf.collectionView.reloadData()
                
                //scrolling to the newly added item
                let lastItemIndex = strongSelf.photoItems.count - 1
                strongSelf.collectionView.scrollToItem(at: IndexPath(item: lastItemIndex, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension PhotoCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: thumbnailCellId, for: indexPath) as! PhotoThumbnailCollectionViewCell
        let photo = photoItems[indexPath.row]
        cell.title = photo.title
        if let photo = thumbnailCache.object(forKey: photo.id as NSNumber) {
            cell.photo = photo
        } else {
            cell.startSpinner()
            webService.load(resource: photo.thumbnail) { [weak cell, weak self] image in
                DispatchQueue.main.async {
                    if let image = image {
                        let photoSize = UIImagePNGRepresentation(image)!.count
                        self?.thumbnailCache.setObject(image, forKey: photo.id as NSNumber, cost: photoSize)
                        cell?.photo = image
                    }
                }
            }
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: IndoorwayDimensions.thumbnailCellHeight)
    }
}

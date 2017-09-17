//
//  PhotoCollectionViewController.swift
//  IndoorwayTask
//
//  Created by Jakub Matuła on 16/09/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import UIKit

private let thumbnailCellId = "ThumbnailCell"
private let cellHeight: CGFloat = 150

class PhotoCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var photoItems = [TypicodePhoto]() {
        didSet {
            if photoItems.isEmpty {
                
            }
        }
    }
    
    fileprivate var photoCache: NSCache<NSNumber,UIImage> = NSCache()
    private var photoIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewHorizontallySeperatedLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        photoCache.removeAllObjects()
    }
    
    @IBAction func resetCollection(_ sender: UIButton) {
        photoItems.removeAll()
        photoIndex = 0
        collectionView.reloadData()
    }
    
    @IBAction func addNextPhoto(_ sender: UIButton) {
        photoIndex += 1
        let photoResource = PhotoResource(index: photoIndex)
        let photoRequest = ApiRequest(resource: photoResource)
        photoRequest.load() { [weak self] typicodePhoto in
            guard let photoData = typicodePhoto else { return }
            self?.photoItems.append(photoData)
            DispatchQueue.main.async {
//                    self?.collectionView.insertItems(at: [IndexPath(item: self!.photoItems.count - 1, section: 0)])
                self?.collectionView.reloadData()
            }
        }
    }
    
}

extension PhotoCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: thumbnailCellId, for: indexPath) as! PhotoThumbnailCollectionViewCell
        let photoItem = photoItems[indexPath.row]
        cell.title = photoItem.title
        if let photo = photoCache.object(forKey: photoItem.id as NSNumber) {
            cell.photo = photo
        } else {
            cell.startSpinner()
            guard let imageRequest = ImageRequest(url: photoItem.thumbnailUrl) else { return cell }
            imageRequest.load() { [weak cell, weak self] photo in
                DispatchQueue.main.async {
                    if let photo = photo {
                        let photoSize = UIImagePNGRepresentation(photo)!.count
                        self?.photoCache.setObject(photo, forKey: photoItem.id as NSNumber, cost: photoSize)
                        cell?.photo = photo
                    }
                }
            }
        }
        return cell
    }
}

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: cellHeight)
    }
}

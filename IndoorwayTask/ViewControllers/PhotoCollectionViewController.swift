//
//  PhotoCollectionViewController.swift
//  IndoorwayTask
//
//  Created by Jakub Matuła on 16/09/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import UIKit

class PhotoCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var photoItems = [TypicodePhoto]()
    fileprivate let thumbnailCellId = "ThumbnailCell"
    fileprivate var photoCache: NSCache<NSNumber,UIImage> = NSCache()
    
    private var photoIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //collectionView.collectionViewLayout = UICollectionViewHorizontallySeperatedLayout()
        
        
        photoItems.append(TypicodePhoto(id: 1, albumId: 2, title: "asd", url: "", thumbnailUrl: ""))
        photoItems.append(TypicodePhoto(id: 2, albumId: 2, title: "asd 2", url: "", thumbnailUrl: ""))
        photoItems.append(TypicodePhoto(id: 2, albumId: 2, title: "asd 2", url: "", thumbnailUrl: ""))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            if let photoData = typicodePhoto {
                self?.photoItems.append(photoData)
                DispatchQueue.main.async {
                    //self?.collectionView.insertItems(at: [IndexPath(item: self!.photoItems.count - 1, section: 0)])
                    self?.collectionView.reloadData()
                }
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
            print("using cached img")
            cell.photo = photo
        } else {
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
        return CGSize(width: collectionView.bounds.size.width, height: 150)
    }
}

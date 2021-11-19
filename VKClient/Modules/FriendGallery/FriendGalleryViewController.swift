//
//  FriendGalleryViewController.swift
//  VKClient
//
//  Created by Olya Ganeva on 08.07.2021.
//

import UIKit

class FriendGalleryViewController: UIViewController {

    private let apiService = APIService()
    var photos = [Photo]()
    var userId = 0

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(GalleryCell.self, forCellWithReuseIdentifier: "GalleryCell")
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white

        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])


        apiService.getPhotos(userId: "\(userId)") { photos in
            self.photos = photos
            self.collectionView.reloadData()
        }
    }
}

extension FriendGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell

        cell.photo = photos[indexPath.row]
        return cell
    }
}

extension FriendGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width - 6) / 3
        return CGSize(width: width, height: width)
    }
}

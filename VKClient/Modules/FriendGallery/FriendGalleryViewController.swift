//
//  FriendGalleryViewController.swift
//  VKClient
//
//  Created by Olya Ganeva on 08.07.2021.
//

import UIKit
import RealmSwift

class FriendGalleryViewController: UIViewController {

    private let apiService = APIService()
    var photos = [Photo]()
    var user: User?

    let realm = RealmManager.shared

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

//        Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)

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

        guard let userID = user?.id else {
            return
        }

        apiService.getPhotos(userId: userID) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let photos):
                self.photos = photos
                self.savePhotosData(photos)
            case .failure:
                self.photos = self.realm?.getObjects(type: Photo.self).filter("owner_id == \(userID)").toArray() ?? []
            }
            self.collectionView.reloadData()
        }
    }

    private func savePhotosData(_ photos: [Photo]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(photos, update: .modified)
            user?.photos.append(objectsIn: photos)
            try realm.commitWrite()
        } catch {
            print("Error")
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

//
//  PhotoFileService.swift
//  VKClient
//
//  Created by Olya Ganeva on 17.01.2022.
//

import UIKit
import Alamofire

final class PhotoFileService {

    enum Consts {
        static let directoryName = "images"
        static let cacheLifetime: TimeInterval = 30 * 24 * 60 * 60
    }

    private var directoryURL: URL? = {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        return cacheURL?.appendingPathComponent(Consts.directoryName, isDirectory: true)
    }()

    static var shared = PhotoFileService()

    private init() {
        createDirectoryIfNeeded()
    }

    func image(by url: URL) -> UIImage? {
        guard let path = filePath(by: url),
              let attributesOfItem = try? FileManager.default.attributesOfItem(atPath: path),
              let modificationDate = attributesOfItem[FileAttributeKey.modificationDate] as? Date
        else {
            return nil
        }

        let lifetime = Date().timeIntervalSince(modificationDate)

        guard lifetime <= Consts.cacheLifetime,
              let image = UIImage(contentsOfFile: path)
        else {
            return nil
        }

        return image
    }

    func save(image: UIImage, with url: URL) {
        guard
            let path = filePath(by: url),
            let data = image.pngData() else {
            return
        }
        FileManager.default.createFile(atPath: path, contents: data)
    }

    private func createDirectoryIfNeeded() {
        guard let directoryURL = directoryURL else {
            return
        }

        if !FileManager.default.fileExists(atPath: directoryURL.path) {
            do {
                try FileManager.default.createDirectory(
                    at: directoryURL,
                    withIntermediateDirectories: true,
                    attributes: nil)
            } catch {
                assertionFailure(error.localizedDescription)
                return
            }
        }
    }

    private func filePath(by url: URL) -> String? {
        guard let directoryURL = directoryURL else {
            return nil
        }

        let imageName = url.lastPathComponent
        return directoryURL.appendingPathComponent(imageName).path
    }
}

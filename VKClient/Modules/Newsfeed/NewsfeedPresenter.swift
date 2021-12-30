//
//  NewsfeedPresenter.swift
//  VKClient
//
//  Created by Olya Ganeva on 24.12.2021.
//

import Foundation

protocol NewsfeedViewProtocol: AnyObject {
    func update()
}

final class NewsfeedPresenter {

    weak var view: NewsfeedViewProtocol?

    var news: [NewsItem] = []
    var groups: [Group] = []
    var profiles: [Profile] = []

    private let networkService = NewsfeedNetworkService()

    private(set) var sections: [NewsfeedSection] = []

    func loadData() {
        networkService.fetchNews() { [weak self] result in
            switch result {
            case .success(let result):

                guard let self = self else {
                    return
                }

                self.news = result.response.items
                self.groups = result.response.groups
                self.profiles = result.response.profiles

                self.sections = self.makeSections(using: self.news, using: self.groups, using: self.profiles)

                DispatchQueue.main.async {
                    self.view?.update()
                }
            case .failure:
                break
            }
        }
    }

    private func makeSections(using models: [NewsItem], using groups: [Group], using profiles: [Profile]) -> [NewsfeedSection] {
        models.compactMap { model in

            var id = model.sourceId
            let dataUnixTime = Double(model.date)

            let dateString = dateStringFromUnixTime(unixTime: dataUnixTime)
            let timeString = timeStringFromUnixTime(unixTime: dataUnixTime)

            let headerViewModel: NewsfeedHeaderCellViewModel

            if id < 0 {
                id *= -1
                guard let ownerGroup = groups.first(where: { $0.id == id }) else {
                    return nil
                }

                headerViewModel = NewsfeedHeaderCellViewModel(title: ownerGroup.name, photo: ownerGroup.photo100, date: "\(dateString) в \(timeString)")


            } else {
                guard let ownerProfile = profiles.first(where: { $0.id == id }) else {
                    return nil
                }

                headerViewModel = NewsfeedHeaderCellViewModel(title: "\(ownerProfile.firstName) \(ownerProfile.lastName)", photo: ownerProfile.photo100, date: "\(dateString) в \(timeString)")
            }

            var text: NewsfeedCellViewModel?
            if !model.text.isEmpty {
                text = NewsfeedCellViewModel.text(NewsfeedTextCellViewModel(text: model.text))
            }

            var photo: NewsfeedCellViewModel?
            if let imageURLString = model.attachments.first?.photo?.sizes.first?.url {
                photo = .photo(.init(imageURL: imageURLString))
            }

            let footer = NewsfeedCellViewModel.footer(NewsfeedFooterCellViewModel(
                                                        likesCount: String(model.likes.count),
                                                        commentsCount: String(model.comments.count),
                                                        sharesCount: String(model.reposts.count),
                                                        viewsCount: String(model.views.count)))

            let header = NewsfeedCellViewModel.header(headerViewModel)
            return NewsfeedSection(items: [header, text, photo, footer].compactMap { $0 })
        }
    }

    private func dateStringFromUnixTime(unixTime: Double) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"

        let date = NSDate(timeIntervalSince1970: unixTime)

        dateFormatter.locale = Locale(identifier: "ru_RU")
        var string = (dateFormatter.string(from: date as Date))
        string.removeLast()
        return string
    }

    private func timeStringFromUnixTime(unixTime: Double) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"

        let time = NSDate(timeIntervalSince1970: unixTime)
        return dateFormatter.string(from: time as Date)
    }
}

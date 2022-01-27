//
//  NewsfeedPresenter.swift
//  VKClient
//
//  Created by Olya Ganeva on 24.12.2021.
//

import Foundation

protocol NewsfeedViewProtocol: AnyObject {
    func update()
    func endRefreshing()
    func insertSections(_ indexSet: IndexSet)
}

final class NewsfeedPresenter {

    weak var view: NewsfeedViewProtocol?

    private var news: [NewsItem] = []
    private var groups: [Group] = []
    private var profiles: [Profile] = []

    private var latestLoadTime: TimeInterval?
    private var cursor: String?
    private var isLoading = false

    private let networkService = NewsfeedNetworkService()

    private(set) var sections: [NewsfeedSection] = []

    func loadData() {

        guard !isLoading else {
            return
        }

        isLoading = true
        networkService.fetchNews() { [weak self] result in

            self?.isLoading = false

            switch result {
            case .success(let result):

                guard let self = self else {
                    return
                }

                self.news = result.response.items
                self.groups = result.response.groups
                self.profiles = result.response.profiles

                self.cursor = result.response.nextFrom

                if let latestLoadTime = self.news.first?.date {
                    self.latestLoadTime = Double(latestLoadTime + 1)
                } else {
                    self.latestLoadTime = nil
                }

                DispatchQueue.global().async {
                    self.sections = self.makeSections(using: self.news, using: self.groups, using: self.profiles)
                    
                    DispatchQueue.main.async {
                        self.view?.update()
                    }
                }

            case .failure:
                break
            }
        }
    }

    private func loadData(from time: TimeInterval) {

        guard !isLoading else {
            return
        }

        isLoading = true
        networkService.fetchNews(from: time) { [weak self] result in

            self?.isLoading = false

            switch result {
            case .success(let result):

                guard let self = self else {
                    return
                }

                self.news.insert(contentsOf: result.response.items, at: 0)
                self.groups.insert(contentsOf: result.response.groups, at: 0)
                self.profiles.insert(contentsOf: result.response.profiles, at: 0)

                self.cursor = result.response.nextFrom

                if let latestLoadTime = self.news.first?.date {
                    self.latestLoadTime = Double(latestLoadTime + 1)
                } else {
                    self.latestLoadTime = nil
                }

                DispatchQueue.global().async {
                    self.sections = self.makeSections(using: self.news, using: self.groups, using: self.profiles)

                    DispatchQueue.main.async {
                        self.view?.endRefreshing()
                        self.view?.update()
                    }
                }

            case .failure:
                break
            }
        }
    }

    private func loadData(from cursor: String) {

        guard !isLoading else {
            return
        }

        isLoading = true
        networkService.fetchMoreNews(from: cursor) { [weak self] result in

            self?.isLoading = false

            switch result {
            case .success(let result):

                guard let self = self else {
                    return
                }

                self.news += result.response.items
                self.groups += result.response.groups
                self.profiles += result.response.profiles

                self.cursor = result.response.nextFrom


                DispatchQueue.global().async {
                    let newSections = self.makeSections(
                        using: result.response.items,
                        using: result.response.groups,
                        using: result.response.profiles)

                    let indexSet = IndexSet(integersIn: self.sections.count..<self.sections.count + newSections.count)
                    self.sections += newSections

                    DispatchQueue.main.async {
                        self.view?.insertSections(indexSet)
                    }
                }

            case .failure:
                break
            }
        }
    }

    func refreshNews() {
        if let latestLoadTime = latestLoadTime {
            loadData(from: latestLoadTime)
        } else {
            loadData()
        }
    }

    func loadMoreNews() {
        guard let cursor = cursor else {
            return
        }
        loadData(from: cursor)
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
            if let imageURLString = model.photo?.url,
               let imageAspectRatio = model.photo?.aspectRatio {
                photo = .photo(NewsfeedPhotoCellViewModel(imageURL: imageURLString, aspectRatio: imageAspectRatio))
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

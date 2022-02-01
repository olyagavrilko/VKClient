//
//  NewsfeedTextCell.swift
//  VKClient
//
//  Created by Olya Ganeva on 23.12.2021.
//

import UIKit

final class NewsfeedTextCell: UITableViewCell {

    enum Consts {
        static let horizontalInset: CGFloat = 8
        static let spacing: CGFloat = 4
        static let buttonHeight: CGFloat = 32
        static let defaultLinesCount = 5
        static let font = UIFont.systemFont(ofSize: 17)
    }

    var viewModel: NewsfeedTextCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            label.text = viewModel.text
            label.numberOfLines = viewModel.isOpen ? 0 : Consts.defaultLinesCount

            let width = UIScreen.main.bounds.width - 2 * Consts.horizontalInset

            button.isHidden = NewsfeedTextCell.isButtonHidden(width: width, text: viewModel.text)
            if viewModel.isOpen {
                button.setTitle("Скрыть...", for: .normal)
            } else {
                button.setTitle("Показать полностью...", for: .normal)
            }
        }
    }

    var indexPath: IndexPath?

    private let stackView = UIStackView()
    private let label = UILabel()
    private let button = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {

        stackView.axis = .vertical
        stackView.spacing = Consts.spacing
        stackView.alignment = .leading
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Consts.horizontalInset),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Consts.horizontalInset),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        label.backgroundColor = .white
        label.font = Consts.font
        stackView.addArrangedSubview(label)

        button.addTarget(self, action: #selector(showMoreButtonDidTap), for: .touchUpInside)
        button.setTitleColor(UIColor(red: 44/255, green: 89/255, blue: 132/255, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        stackView.addArrangedSubview(button)
    }

    @objc private func showMoreButtonDidTap() {
        guard let indexPath = indexPath else {
            return
        }
        viewModel?.openCloseAction(indexPath)
    }

    static func height(fitting width: CGFloat, viewModel: NewsfeedTextCellViewModel) -> CGFloat {

        let width = width - 2 * Consts.horizontalInset
        let maxNumberOfLines = viewModel.isOpen ? 0 : CGFloat(Consts.defaultLinesCount)

        let finishLabelHeight = calculateTextHeight(
            fitting: width,
            text: viewModel.text,
            maxNumberOfLines: Int(maxNumberOfLines))

        var height = finishLabelHeight
        if !isButtonHidden(width: width, text: viewModel.text) {
            height += Consts.spacing + Consts.buttonHeight
        }

        return height
    }

    private static func isButtonHidden(width: CGFloat, text: String) -> Bool {
        let maxTextHeight = calculateTextHeight(
            fitting: width,
            text: text,
            maxNumberOfLines: 0)

        let limitHeight = CGFloat(Consts.defaultLinesCount) * Consts.font.lineHeight

        return maxTextHeight <= limitHeight
    }

    private static func calculateTextHeight(fitting width: CGFloat, text: String, maxNumberOfLines: Int) -> CGFloat {

        let textHeight = maxNumberOfLines == 0
            ? .greatestFiniteMagnitude
            : CGFloat(maxNumberOfLines) * Consts.font.lineHeight

        let rect = CGSize(width: width, height: textHeight)
        let boundingBox = text.boundingRect(
            with: rect,
            options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine],
            attributes: [NSAttributedString.Key.font: Consts.font],
            context: nil)

        return ceil(boundingBox.height)
    }
}

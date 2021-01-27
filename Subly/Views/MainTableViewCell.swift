//
//  MainTableViewCell.swift
//  Subly
//
//  Created by Илья Кузнецов on 27.01.2021.
//

import UIKit
import Cards

class MainTableViewCell: UITableViewCell {
    
    static let identifier = "MainTableViewCell"
    private let mainVC = MainViewController()
    
    private let card: CardHighlight = {
        let card = CardHighlight(frame: .zero)
        //configure
        return card
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(card)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        card.frame = CGRect(x: 0,
                            y: mainVC.view.safeAreaInsets.top,
                            width: mainVC.view.frame.size.width,
                            height: mainVC.view.frame.size.width)
    }
    
    public func configure(with model: ContentModel) {
        card.backgroundColor = .link
        card.icon = UIImage(systemName: "pencil")
        card.title = model.title
        card.itemTitle = model.itemTitle
        card.itemSubtitle = model.itemSubtitle
        card.shadowBlur = 20
        card.buttonText = model.buttonText
        card.titleSize = 32
        card.textColor = .white
        card.itemTitleSize = 18
    }

}

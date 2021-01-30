//
//  CollectionViewCell.swift
//  Subly
//
//  Created by Илья Кузнецов on 28.01.2021.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let identifier = "TableViewCell"
    private let gradientLayer = CAGradientLayer()
    
    @IBOutlet weak var viewOutlet: UIView!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var subNameLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var typeOfSub: UILabel!
    
    
    public func configure(with model: ContentModel) {
        subNameLabel.text = model.subName
        subNameLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        //subNameLabel.font = .systemFont(ofSize: <#T##CGFloat#>, weight: <#T##UIFont.Weight#>)
        
        viewOutlet.layer.cornerRadius = 20.0
            viewOutlet.layer.shadowColor = UIColor.gray.cgColor
            viewOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            viewOutlet.layer.shadowRadius = 12.0
            viewOutlet.layer.shadowOpacity = 0.7
    }
    
}

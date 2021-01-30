//
//  NewSubCell.swift
//  Subly
//
//  Created by Илья Кузнецов on 30.01.2021.
//

import UIKit

class NewSubCell: UITableViewCell {
    
    @IBOutlet weak var viewOutlet: UIView!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textFieldOutlet: UITextField!
    
    
    static let identifier = "NewSubCell"
    
    let arrayOfFields = ["Цена", "Валюта", "Способ оплаты", "Дата оплаты", "Цикл", "Уведомить за", "Пробный период", "Тип"]
}


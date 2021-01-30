//
//  NewSubVC.swift
//  Subly
//
//  Created by Илья Кузнецов on 30.01.2021.
//

import UIKit

class NewSubVC: UIViewController {
    
    private let arrayOfField = AddNewSubFields()

    @IBOutlet weak var tableView: AddNewSubTableView!
    @IBOutlet weak var subNameLabel: UILabel!
    
    var productName = ""
    var indexesNeedPicker: [IndexPath]?
    let cell = NewSubCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subNameLabel.text = productName
        subNameLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        //tableView.delegate = self
        //tableView.dataSource = self
//        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.tintColor = .systemBackground
        navigationController?.navigationItem.rightBarButtonItem?.title = "Добавить"
    }
}

extension NewSubVC: UITableViewDelegate, UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return arrayOfField.arrayOfFields.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view:UIView = UIView.init(frame:
//                                        CGRect.init(x: 0,
//                                                    y: 0,
//                                                    width: self.view.bounds.size.width,
//                                                    height: 10))
//        view.backgroundColor = .clear
//        return view
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 5
//    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 5.0
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewSubCell.identifier) as! NewSubCell
        cell.titleLabel?.text = cell.arrayOfFields[indexPath.section]
        cell.titleLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            cell.textFieldOutlet.isHidden = true
        case 1:
            print("1")
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
}


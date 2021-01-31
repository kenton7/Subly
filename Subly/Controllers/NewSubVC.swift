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
    private var content: Content!
    
    public var amountToDouble: Double?
    public var currency: String?
    public var paymentType: String?
    public var paymentDate: Date?
    public var cycle: String?
    public var notifyMe: String?
    public var typeOfSub: String?
    
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
    
    func saveNewSub() {
        
        let table = AddNewTVC()
        
        print(table.amountToDoube)
        
        let newSub = Content(amount: table.amountToDoube ?? 0.0, currency: table.currency ?? "P", paymentType: table.paymentType ?? "card", paymentDate: table.dateFromStringToDate ?? Date(), cycle: table.cycle ?? "cycle", notifyMe: table.notifyMe ?? "1day" , trial: Data(), type: table.typeOfSub ?? "ind")

        if content != nil {
            try! realm.write {
                content.amount = newSub.amount
                content.currency = newSub.currency
                content.paymentType = newSub.paymentType
                content.paymentDate = newSub.paymentDate
                content.cycle = newSub.cycle
                content.notifyMe = newSub.notifyMe
                content.trial = newSub.trial
                content.type = newSub.type
            }
        } else {
            //сохраняем в базу
            StorageManager.saveObject(newSub)
            print("ok")
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let vc = segue.source as? AddNewTVC else {
            print("no")
            return
        }
        
        vc.saveValues()
        
        let amountDouble = vc.amountTextField.text
        amountToDouble = Double(amountDouble!)
        print(amountToDouble)
        currency = vc.currencyTextField.text
        paymentType = vc.paymentTypeOutlet.text
        paymentDate = vc.dateFromStringToDate
        cycle = vc.cycleOutlet.text
        notifyMe = vc.notifyMeOutlet.text
        typeOfSub = vc.typeOfSubOutlet.text
    }
    
    
}

extension NewSubVC: UITableViewDelegate, UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return arrayOfField.arrayOfFields.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewSubCell.identifier) as! NewSubCell
        cell.titleLabel?.text = cell.arrayOfFields[indexPath.section]
        cell.titleLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        return cell
    }
    
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



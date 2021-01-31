//
//  AddNewTVC.swift
//  Subly
//
//  Created by Илья Кузнецов on 30.01.2021.
//

import UIKit

class AddNewTVC: UITableViewController {
    
    private let arrayOfField = AddNewSubFields()
    
    public var amountToDoube: Double?
    public var currency: String?
    public var paymentType: String?
    public var paymentDate: Date?
    public var cycle: String?
    public var notifyMe: String?
    public var typeOfSub: String?
    
    public var dateFromStringToDate: Date?
    private let dateFormatter = DateFormatter()
    private var content: Content!
    
    @IBOutlet weak var trialButtonOutlet: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var paymentTypeOutlet: UITextField!
    @IBOutlet weak var paymentDateOutlet: UITextField!
    @IBOutlet weak var cycleOutlet: UITextField!
    @IBOutlet weak var notifyMeOutlet: UITextField!
    @IBOutlet weak var typeOfSubOutlet: UITextField!
    @IBOutlet weak var customSubButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        //trialButtonOutlet.setTitle("Да", for: .normal)
    }
    
    func saveValues() {
        dateFromStringToDate = dateFormatter.date(from: paymentDateOutlet.text ?? "no date")
        amountToDoube = Double(amountTextField.text ?? "")
        currency = currencyTextField.text
        paymentType = paymentTypeOutlet.text
        paymentDate = dateFromStringToDate
        cycle = cycleOutlet.text
        notifyMe = notifyMeOutlet.text
        typeOfSub = typeOfSubOutlet.text
    }
    
    func saveNewSub() {
        
        let table = AddNewTVC()
        
        amountToDoube = Double(amountTextField.text!)
        
        let test = Content(amount: amountToDoube!, currency: currencyTextField.text!, paymentType: paymentTypeOutlet.text!, paymentDate: Date(), cycle: cycleOutlet.text!, notifyMe: notifyMeOutlet.text!, trial: Data(), type: paymentTypeOutlet.text!)
        
//        let newSub = Content(amount: table.amountToDoube ?? 0.0, currency: table.currency ?? "P", paymentType: table.paymentType ?? "card", paymentDate: table.dateFromStringToDate ?? Date(), cycle: table.cycle ?? "cycle", notifyMe: table.notifyMe ?? "1day" , trial: Data(), type: table.typeOfSub ?? "ind")

        if content != nil {
            try! realm.write {
                content.amount = test.amount
                content.currency = test.currency
                content.paymentType = test.paymentType
                content.paymentDate = test.paymentDate
                content.cycle = test.cycle
                content.notifyMe = test.notifyMe
                content.trial = test.trial
                content.type = test.type
            }
        } else {
            //сохраняем в базу
            StorageManager.saveObject(test)
            print("ok")
        }
    }
    
    @IBAction func customSubPressed(_ sender: UIButton) {
        print("ok")
    }
    
    @IBAction func trialButtonPressed(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            self.trialButtonOutlet.setTitle("Нет", for: .normal)
        }
        
        if trialButtonOutlet.currentTitle == "Нет" {
            DispatchQueue.main.async {
                self.trialButtonOutlet.setTitle("Да", for: .normal)
            }
        }
    }
    
    
    
    
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view: UIView = UIView.init(frame:
                                        CGRect.init(x: 0,
                                                    y: 0,
                                                    width: self.view.bounds.size.width,
                                                    height: 10))
        view.backgroundColor = .clear
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO
    }
    
}

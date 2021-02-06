//
//  AddNewTVC.swift
//  Subly
//
//  Created by Илья Кузнецов on 30.01.2021.
//

import UIKit

class AddNewTVC: UITableViewController {
    
    public var amountToDoube: Double?
    public var currency: String?
    public var paymentType: String?
    public var paymentDate: Date?
    public var cycle: String?
    public var notifyMe: String?
    public var typeOfSub: String?
    public var name = ""
    public var imageName = ""
    private let formatter = DateFormatter()
    private var content: Content!
    private let datePicker = UIDatePicker()
    private let pickerView = UIPickerView()
    private let currencies = Currenices()
    
    @IBOutlet weak var trialButtonOutlet: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var paymentDateOutlet: UITextField!
    @IBOutlet weak var cycleOutlet: UITextField!
    @IBOutlet weak var notifyMeOutlet: UITextField!
    @IBOutlet weak var typeOfSubOutlet: UITextField!
    @IBOutlet weak var customSubButtonOutlet: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        imageViewOutlet.layer.cornerRadius = imageViewOutlet.frame.size.width / 2
        imageViewOutlet.image = UIImage(named: imageName)
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        amountTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        currencyTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        paymentDateOutlet.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        cycleOutlet.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        notifyMeOutlet.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        typeOfSubOutlet.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        saveButtonOutlet.isEnabled = false
        saveButtonOutlet.setTitle("Вы заполнили не все данные", for: .normal)
        saveButtonOutlet.alpha = 0.5
        nameTextField.text = name
        saveButtonOutlet.layer.cornerRadius = 20
        customSubButtonOutlet.layer.cornerRadius = 20
        createDatePicker()
        createPickerViewWithCurrencies()

        
        trialButtonOutlet.setTitle("Нет", for: .normal)
    }
    
    func saveNewSub() {
        amountToDoube = Double(amountTextField.text!)
        
        let newSub = Content(name: nameTextField.text!,
                             amount: amountToDoube!,
                             currency: currencyTextField.text!,
                             note: noteTextField.text!,
                             paymentDate: paymentDateOutlet.text!,
                             cycle: cycleOutlet.text!,
                             notifyMe: notifyMeOutlet.text!,
                             trial: Data(),
                             type: typeOfSubOutlet.text!,
                             imageName: imageName)
        
        
        if content != nil {
            try! realm.write {
                content.amount = newSub.amount
                content.currency = newSub.currency
                content.note = newSub.note
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
    
    private func createPickerViewWithCurrencies() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(currencyPressed))
        toolbar.setItems([done], animated: true)
        currencyTextField.inputAccessoryView = toolbar
        currencyTextField.inputView = pickerView
    }
    
    private func createDatePicker() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        let loc = Locale(identifier: "ru")
        datePicker.locale = loc
        
        //done button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        paymentDateOutlet.inputAccessoryView = toolbar
        paymentDateOutlet.inputView = datePicker
        
        
    }
    
    @objc private func donePressed() {
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        paymentDateOutlet.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc private func currencyPressed() {
        currencyTextField.text = currencies.currencies[pickerView.selectedRow(inComponent: 0)]
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
    
    @objc private func textFieldChanged() {
        if amountTextField.text?.isEmpty == false && currencyTextField.text?.isEmpty == false && paymentDateOutlet.text?.isEmpty == false && cycleOutlet.text?.isEmpty == false && notifyMeOutlet.text?.isEmpty == false && typeOfSubOutlet.text?.isEmpty == false && nameTextField.text?.isEmpty == false {
            saveButtonOutlet.isEnabled = true
            DispatchQueue.main.async {
                self.saveButtonOutlet.setTitle("Сохранить", for: .normal)
                self.saveButtonOutlet.alpha = 1
            }
        } else {
            saveButtonOutlet.isEnabled = false
            DispatchQueue.main.async {
                self.saveButtonOutlet.setTitle("Вы заполнили не все данные", for: .normal)
                self.saveButtonOutlet.alpha = 0.5
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension AddNewTVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.currencies.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies.currencies[row]
    }
    
}


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
    public var content: Content!
    private let datePicker = UIDatePicker()
    private let currencyPickerView = UIPickerView()
    private let cyclePicker = UIPickerView()
    private let currencies = Currenices()
    private let cyclesArray = Cycle()
    private let type = Type()
    private let notifyModel = NotifyMe()
    private var pickerView = UIPickerView()
    private let notifyMePicker = UIPickerView()
    
    @IBOutlet weak var trialButtonOutlet: UIButton!
    @IBOutlet weak var amountTextField: UITextField! {
        didSet { amountTextField?.addDoneCancelToolbar() }
    }
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePicker), name: UITextField.textDidBeginEditingNotification, object: nil)
        
        imageViewOutlet.image = UIImage(named: imageName)
        saveButtonOutlet.isEnabled = false
        saveButtonOutlet.setTitle("Вы заполнили не все данные", for: .normal)
        saveButtonOutlet.alpha = 0.5
        nameTextField.text = name
        saveButtonOutlet.layer.cornerRadius = 20
        customSubButtonOutlet.layer.cornerRadius = 20
        setupEditScreen()
        createDatePicker()
        createPickerViewWithCurrencies()
        cyclePickerView()
        notifyMePickerView()
        
        //следим пустой текс фиелд или нет
        amountTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        currencyTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        paymentDateOutlet.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        cycleOutlet.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        notifyMeOutlet.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        typeOfSubOutlet.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.dismissKeybord(_:)))
                tap.numberOfTapsRequired = 1
                self.view.addGestureRecognizer(tap)
        
        
        trialButtonOutlet.setTitle("Нет", for: .normal)
    }
    
    @objc private func updatePicker(){
        self.pickerView.reloadAllComponents()
    }
    
    @objc private func dismissKeybord(_ sender:UITapGestureRecognizer) {
        self.view.endEditing(true)
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
    
    private func setupEditScreen() {
        if content != nil {
            setupNavigationBar()
            guard let data = content?.imageName, let image = UIImage(named: data) else { return }
            imageViewOutlet.contentMode = .scaleAspectFit
            imageViewOutlet.image = image
            nameTextField.text = content?.name
            paymentDateOutlet.text = content.paymentDate
            currencyTextField.text = content.currency
            noteTextField.text = content.note ?? ""
            cycleOutlet.text = content.cycle
            notifyMeOutlet.text = content.notifyMe
            typeOfSubOutlet.text = content.type
            amountTextField.text = String(content.amount)
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = content?.name
        saveButtonOutlet.setTitle("Сохранить", for: .normal)
        saveButtonOutlet.alpha = 1.0
        saveButtonOutlet.isEnabled = true
    }
    
    private func notifyMePickerView() {
        notifyMePicker.delegate = self
        notifyMePicker.dataSource = self
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "Готово", style: .done, target: nil, action: #selector(notifyMePressed))
        //let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(notifyMePressed))
        toolbar.setItems([done], animated: true)
        notifyMeOutlet.inputAccessoryView = toolbar
        notifyMeOutlet.inputView = notifyMePicker
    }
    
    @objc private func notifyMePressed() {
        let notifyModel = NotifyMe()
        notifyMeOutlet.text = notifyModel.days[notifyMePicker.selectedRow(inComponent: 0)]
        self.view.endEditing(true)
    }
    
    private func cyclePickerView() {
        cyclePicker.delegate = self
        cyclePicker.dataSource = self
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "Готово", style: .done, target: nil, action: #selector(cyclePressed))
        toolbar.setItems([done], animated: true)
        cycleOutlet.inputAccessoryView = toolbar
        cycleOutlet.inputView = cyclePicker
    }
    
    private func createPickerViewWithCurrencies() {
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "Готово", style: .done, target: nil, action: #selector(currencyPressed))
        toolbar.setItems([done], animated: true)
        currencyTextField.inputAccessoryView = toolbar
        currencyTextField.inputView = currencyPickerView
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
        let done = UIBarButtonItem(title: "Готово", style: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: true)
        
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
        currencyTextField.text = currencies.currencies[currencyPickerView.selectedRow(inComponent: 0)]
        self.view.endEditing(true)
    }
    
    @objc private func cyclePressed() {
        let type = Type()
        cycleOutlet.text = cyclesArray.cycleDays[cyclePicker.selectedRow(inComponent: 0)] + " " + type.type[cyclePicker.selectedRow(inComponent: 1)]
        self.view.endEditing(true)
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
        
        if currencyTextField.isFirstResponder {
            return currencies.currencies.count
        } else if cycleOutlet.isFirstResponder {
            return cyclesArray.cycleDays.count
        } else if notifyMeOutlet.isFirstResponder {
            return notifyModel.days.count
        }
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if currencyTextField.isFirstResponder {
            return 1
        } else if cycleOutlet.isFirstResponder {
            return 2
        } else if notifyMeOutlet.isFirstResponder {
            return 1
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if currencyTextField.isFirstResponder {
            return currencies.currencies[row]
        } else if cycleOutlet.isFirstResponder {
            if component == 0 {
                return cyclesArray.cycleDays[row]
            } else if component == 1 {
                return (row < type.type.count ? type.type[row].description : nil)
            }
        } else if notifyMeOutlet.isFirstResponder {
            return notifyModel.days[row]
        }
        return ""
    }
}

// MARK: - UITextField
extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))

        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Отмена", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Готово", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()

        self.inputAccessoryView = toolbar
    }

    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}




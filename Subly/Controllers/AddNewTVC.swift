//
//  AddNewTVC.swift
//  Subly
//
//  Created by Илья Кузнецов on 30.01.2021.
//

import UIKit
import UserNotifications

class AddNewTVC: UITableViewController {
    
    public var currency: String?
    public var paymentType: String?
    public var paymentDate: Date?
    public var cycle: String?
    public var notifyMe: String?
    public var typeOfSub: String?
    public var name = ""
    public var imageName = ""
    private let formatter = DateFormatter()
    public var contentModel: Content!
    private let datePicker = UIDatePicker()
    private let currencyPickerView = UIPickerView()
    private let cyclePicker = UIPickerView()
    private let subsTypesPickerView = UIPickerView()
    private let currencies = Currenices()
    private let cyclesArray = Cycle()
    private let type = TypeOfDate()
    private let typesOfSubs = TypeOfSub()
    private let notifyModel = NotifyMe()
    private var pickerView = UIPickerView()
    private let notifyMePicker = UIPickerView()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private var secondsPerOneDay: Double = 86400
    private let userNotificationCenter = UNUserNotificationCenter.current()
    private let date = Date()
    
    private var userSelectedDailyCycle = 0.0
    public var daysLeft = Date()
    public var day: Int?
    public var dayMonthWeekYear: String?
    public var newDay: Date?
    
    var userDay = ""
    var newDateString: String?
    
    
    let progressBarView = ProgressBarView()
    var progressValue: Float = 0
    var timer: Timer?
    let currentDate = Date()
    var endDate: Date?
    var userSetDate: Date?
    var temp = [String]()
    
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
    @IBOutlet weak var productNameOutlet: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        userNotificationCenter.delegate = self
        tableView.tableFooterView = UIView()
        imageViewOutlet.layer.cornerRadius = imageViewOutlet.frame.size.width / 2
        NotificationCenter.default.addObserver(self, selector: #selector(updatePicker), name: UITextField.textDidBeginEditingNotification, object: nil)
        currencyTextField.text = UserDefaults.standard.string(forKey: "currencySelected")
        print("paymentDateOutlet.text \(String(describing: paymentDateOutlet.text))")
        
        if UserDefaults.standard.bool(forKey: "hapticOn") {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            UserDefaults.standard.set(true, forKey: "haptic")
            print("haptic is on")
        } else {
            UserDefaults.standard.set(false, forKey: "haptic")
            print("haptic is off")
        }
        
        
        //let timeInterval = currentDate.timeIntervalSince(userSetDate!)
        //timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        
        imageViewOutlet.image = UIImage(named: imageName)
        saveButtonOutlet.isEnabled = false
        saveButtonOutlet.setTitle("Вы заполнили не все данные", for: .normal)
        saveButtonOutlet.alpha = 0.5
        nameTextField.text = name
        print("name = \(String(describing: nameTextField.text))")
        productNameOutlet.text = nameTextField.text
        //        amountTextField.text = "0.0"
        //        typeOfSubOutlet.text = typesOfSubs.types[0]
        //        currencyTextField.text = currencies.currencies[0]
        
        //следим пустой текст фиелд или нет
        amountTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        currencyTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        paymentDateOutlet.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        cycleOutlet.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        notifyMeOutlet.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        typeOfSubOutlet.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        saveButtonOutlet.layer.cornerRadius = 20
        //customSubButtonOutlet.layer.cornerRadius = 20
        setupEditScreen()
        createDatePicker()
        createPickerViewWithCurrencies()
        cyclePickerView()
        createPickerWithSubsTypes()
        notifyMePickerView()
        
        
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
    
    public func updatingDatesWith() {
        let temp = (cycleOutlet.text?.components(separatedBy: " "))!
        //temp = (cycleOutlet.text?.components(separatedBy: " "))!
        //temp = ["1" , "День"]
        
        day = Int(temp[0])
        print(temp[1])
        print(day!)
        
        dayMonthWeekYear = temp[1]
        formatter.dateFormat = "dd-MM-yyyy"
        let date = datePicker.date
        let currentDate = Date()
        print("currentDate \(currentDate)")
        //let date = formatter.date(from: paymentDateOutlet.text!)
        var dateComponent = DateComponents()
        
        //var newStringDate = formatter.string(from: newDay ?? Date())
        
        if dayMonthWeekYear == "День" {
            UserDefaults.standard.setValue("День", forKey: "day")
            dateComponent.day = day
            newDay = Calendar.current.date(byAdding: dateComponent, to: date)
            
            if currentDate >= newDay! {
                newDay = currentDate
                //newDay = newDay!.adding(days: UserDefaults.standard.value(forKey: "day") as! Int)
                newDay = newDay!.adding(days: day!)
                print("newDay = \(newDay)")
                newDateString = formatter.string(from: date)
                print("new = \(String(describing: newDateString))")
            }
            
            userSetDate = newDay
        } else if dayMonthWeekYear == "Неделя" {
            UserDefaults.standard.setValue("Неделя", forKey: "week")
            let oneWeek = 7
            day! *= oneWeek
            dateComponent.day = day
            newDay = Calendar.current.date(byAdding: dateComponent, to: date)
            
            if currentDate >= newDay! {
                newDay = newDay!.adding(days: day!)
                newDateString = formatter.string(from: date)
                print("new = \(String(describing: newDateString))")
            }
            
            userSetDate = newDay
        } else if dayMonthWeekYear == "Месяц" {
            UserDefaults.standard.setValue("Месяц", forKey: "month")
            dateComponent.month = day
            newDay = Calendar.current.date(byAdding: dateComponent, to: date)
            
            
            if currentDate >= newDay! {
                print(currentDate)
                print(newDay!)
                newDay = newDay?.adding(months: day!)
                print(newDay!)
                newDateString = formatter.string(from: date)
            }
            
            userSetDate = newDay
        } else if dayMonthWeekYear == "Год" {
            UserDefaults.standard.setValue("Год", forKey: "year")
            dateComponent.year = day
            newDay = Calendar.current.date(byAdding: dateComponent, to: date)
            
            if currentDate >= newDay! {
                newDay = newDay?.adding(years: day!)
                newDateString = formatter.string(from: date)
            }
            
            userSetDate = newDay
        } else {
            newDateString = formatter.string(from: newDay ?? Date())
            print("Error")
        }
    }
    
    func saveNewSub() {
        
        updatingDatesWith()
        
        
        let newSub = Content(name: nameTextField.text!,
                             amount: amountTextField.text!,
                             currency: currencyTextField.text!,
                             note: noteTextField.text!,
                             paymentDate: paymentDateOutlet.text!,
                             cycle: cycleOutlet.text!,
                             notifyMe: notifyMeOutlet.text!,
                             trial: Data(),
                             type: typeOfSubOutlet.text!,
                             imageName: imageName,
                             nextPayment: newDay!,
                             cycleDayWeekMonthYear: dayMonthWeekYear!)
        print("newSub.nextPayment \(newSub.nextPayment!)")
        print("newSub.cycleDayWeekMonthYear \(String(describing: newSub.cycleDayWeekMonthYear))")
        print("imageName \(imageName)")
        
        
        if contentModel != nil {
            try! realm.write {
                contentModel.amount = newSub.amount
                contentModel.currency = newSub.currency
                contentModel.note = newSub.note
                contentModel.paymentDate = newSub.paymentDate
                //content.paymentDate = paymentDateOutlet.text
                contentModel.nextPayment = newSub.nextPayment
                print(contentModel.nextPayment!)
                contentModel.cycle = newSub.cycle
                contentModel.notifyMe = newSub.notifyMe
                contentModel.trial = newSub.trial
                contentModel.type = newSub.type
                contentModel.name = newSub.name
                contentModel.cycleDayWeekMonthYear = newSub.cycleDayWeekMonthYear
                //scheduleNotification()
            }
        } else {
            //сохраняем в базу
            //scheduleNotification()
            StorageManager.saveObject(newSub)
            print("ok")
        }
    }
    
    private func setupEditScreen() {
        if contentModel != nil {
            setupNavigationBar()
            guard let data = contentModel?.imageName, let image = UIImage(named: data) else { return }
            imageViewOutlet.contentMode = .scaleAspectFit
            imageViewOutlet.image = image
            nameTextField.text = contentModel?.name
            productNameOutlet.text = contentModel.name
            paymentDateOutlet.text = contentModel.paymentDate
            currencyTextField.text = contentModel.currency
            noteTextField.text = contentModel.note ?? ""
            cycleOutlet.text = contentModel.cycle
            notifyMeOutlet.text = contentModel.notifyMe
            typeOfSubOutlet.text = contentModel.type
            amountTextField.text = contentModel.amount
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = contentModel?.name
        paymentDateOutlet.text = contentModel.paymentDate
        cycleOutlet.text = contentModel.cycle
        newDay = contentModel.nextPayment
        //print(newDay!)
        let temp = (cycleOutlet.text?.components(separatedBy: " "))!
        day = Int(temp[0])
        print(temp[1])
        print(day!)
        
        print(paymentDateOutlet.text!)
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
        toolbar.setItems([done], animated: true)
        notifyMeOutlet.inputAccessoryView = toolbar
        notifyMeOutlet.inputView = notifyMePicker
    }
    
    @objc private func notifyMePressed() {
        notifyMeOutlet.text = notifyModel.days[notifyMePicker.selectedRow(inComponent: 0)]
        print(notifyMeOutlet.text!)
        if UserDefaults.standard.bool(forKey: "hapticOn") {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            UserDefaults.standard.set(true, forKey: "haptic")
            print("haptic is on")
        } else {
            UserDefaults.standard.set(false, forKey: "haptic")
            print("haptic is off")
        }
        self.view.endEditing(true)
    }
    
    private func createPickerWithSubsTypes() {
        subsTypesPickerView.delegate = self
        subsTypesPickerView.dataSource = self
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "Готово", style: .done, target: nil, action: #selector(typesSubsPressed))
        toolbar.setItems([done], animated: true)
        typeOfSubOutlet.inputAccessoryView = toolbar
        typeOfSubOutlet.inputView = subsTypesPickerView
    }
    
    @objc private func typesSubsPressed() {
        typeOfSubOutlet.text = typesOfSubs.types[subsTypesPickerView.selectedRow(inComponent: 0)]
        textFieldChanged()
        print(typeOfSubOutlet.text!)
        if UserDefaults.standard.bool(forKey: "hapticOn") {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            UserDefaults.standard.set(true, forKey: "haptic")
            print("haptic is on")
        } else {
            UserDefaults.standard.set(false, forKey: "haptic")
            print("haptic is off")
        }
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
        ///toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        datePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        let loc = Locale(identifier: "ru")
        datePicker.locale = loc
        
        ///done button
        let done = UIBarButtonItem(title: "Готово", style: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: true)
        
        paymentDateOutlet.inputAccessoryView = toolbar
        paymentDateOutlet.inputView = datePicker
    }
    
    @objc private func donePressed() {
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.dateFormat = "dd-MM-yyyy"
        paymentDateOutlet.text = formatter.string(from: datePicker.date)
        print(datePicker.date)
        daysLeft = datePicker.date.adding(days: day ?? 1)
        if UserDefaults.standard.bool(forKey: "hapticOn") {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            UserDefaults.standard.set(true, forKey: "haptic")
            print("haptic is on")
        } else {
            UserDefaults.standard.set(false, forKey: "haptic")
            print("haptic is off")
        }
        self.view.endEditing(true)
    }
    
    @objc private func currencyPressed() {
        currencyTextField.text = currencies.currencies[currencyPickerView.selectedRow(inComponent: 0)]
        print(currencyTextField.text!)
        if UserDefaults.standard.bool(forKey: "hapticOn") {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            UserDefaults.standard.set(true, forKey: "haptic")
            print("haptic is on")
        } else {
            UserDefaults.standard.set(false, forKey: "haptic")
            print("haptic is off")
        }
        self.view.endEditing(true)
    }
    
    @objc private func cyclePressed() {
        cycleOutlet.text = cyclesArray.cycleDays[cyclePicker.selectedRow(inComponent: 0)] + " " + type.type[cyclePicker.selectedRow(inComponent: 1)]
        let temp = (cycleOutlet.text?.components(separatedBy: " "))!
        //temp = (cycleOutlet.text?.components(separatedBy: " "))!
        day = Int(temp[0])
        dayMonthWeekYear = temp[1]
        let aDate = datePicker.date
        print("aDate \(aDate)")
        var dateComponent = DateComponents()
        formatter.dateFormat = "dd-MM-yyyy"
        
        switch dayMonthWeekYear {
        case "День":
            //            UserDefaults.standard.setValue("true", forKey: "daySet")
            //            print(UserDefaults.standard.bool(forKey: "daySet"))
            dateComponent.day = day
            newDay = Calendar.current.date(byAdding: dateComponent, to: aDate)
            UserDefaults.standard.set(day, forKey: "day")
            //UserDefaults.standard.setValue(day, forKey: "day")
            print(UserDefaults.standard.value(forKey: "day")!)
            userSetDate = newDay
            
            print("newDay! \(newDay!)")
        case "Неделя":
            //UserDefaults.standard.bool(forKey: "weekSet")
            let oneWeek = 7
            day! *= oneWeek
            dateComponent.day = day
            newDay = Calendar.current.date(byAdding: dateComponent, to: aDate)
            UserDefaults.standard.set(day, forKey: "week")
            userSetDate = newDay
            print("day = \(day!)")
        case "Месяц":
            //UserDefaults.standard.setValue("true", forKey: "monthSet")
            dateComponent.month = day
            newDay = Calendar.current.date(byAdding: dateComponent, to: aDate)
            UserDefaults.standard.set(day, forKey: "month")
            userSetDate = newDay
            print("new day = \(newDay!)")
        case "Год":
            //UserDefaults.standard.bool(forKey: "yearSet")
            dateComponent.year = day
            newDay = Calendar.current.date(byAdding: dateComponent, to: aDate)
            UserDefaults.standard.set(day, forKey: "year")
            userSetDate = newDay
            print("one day = \(day!)")
        default:
            return
        }
        print(cycleOutlet.text!)
        if UserDefaults.standard.bool(forKey: "hapticOn") {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            UserDefaults.standard.set(true, forKey: "haptic")
            print("haptic is on")
        } else {
            UserDefaults.standard.set(false, forKey: "haptic")
            print("haptic is off")
        }
        self.view.endEditing(true)
    }
    
    @IBAction func trialButtonPressed(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            self.trialButtonOutlet.setTitle("Нет", for: .normal)
            if UserDefaults.standard.bool(forKey: "hapticOn") {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                UserDefaults.standard.set(true, forKey: "haptic")
                print("haptic is on")
            } else {
                UserDefaults.standard.set(false, forKey: "haptic")
                print("haptic is off")
            }
        }
        
        if trialButtonOutlet.currentTitle == "Нет" {
            DispatchQueue.main.async {
                self.trialButtonOutlet.setTitle("Да", for: .normal)
                if UserDefaults.standard.bool(forKey: "hapticOn") {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    UserDefaults.standard.set(true, forKey: "haptic")
                    print("haptic is on")
                } else {
                    UserDefaults.standard.set(false, forKey: "haptic")
                    print("haptic is off")
                }
            }
        }
    }
    
    
    
    @objc private func textFieldChanged() {
        
        if nameTextField.text!.count > 0 && amountTextField.text!.count > 0 && currencyTextField.text!.count > 0 && paymentDateOutlet.text!.count > 0 && cycleOutlet.text!.count > 0 && notifyMeOutlet.text!.count > 0 && typeOfSubOutlet.text!.count > 0 {
            print("Everything is filled in")
            self.saveButtonOutlet.isEnabled = true
            self.saveButtonOutlet.setTitle("Сохранить", for: .normal)
            self.saveButtonOutlet.alpha = 1.0
        } else {
            print("Something is empty")
            self.saveButtonOutlet.isEnabled = false
            self.saveButtonOutlet.setTitle("Вы не заполнили все поля", for: .normal)
            self.saveButtonOutlet.alpha = 0.5
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
        } else if typeOfSubOutlet.isFirstResponder {
            return typesOfSubs.types.count
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
        } else if typeOfSubOutlet.isFirstResponder {
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
        } else if typeOfSubOutlet.isFirstResponder {
            return typesOfSubs.types[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if cycleOutlet.isFirstResponder {
            if component == 0 {
                print("component 0")
                let selectDay = cyclesArray.cycleDays[row]
                userDay = selectDay
                UserDefaults.standard.set(userDay, forKey: "userDay")
                print(userDay)
            } else if component == 1 {
                print("component 1")
                let selectType = (row < type.type.count ? type.type[row].description : nil)
                
                switch selectType {
                case "День":
                    secondsPerOneDay = (Double(userDay) ?? 1.0) * 86400
                    UserDefaults.standard.string(forKey: "daysSelected")
                    print(secondsPerOneDay)
                case "Неделя":
                    print("week")
                    //secondsPerOneDay = 86400.0
                    secondsPerOneDay = 86400 * ((Double(userDay) ?? 1.0) * 7)
                    print(secondsPerOneDay)
                case "Месяц":
                    print("month")
                    secondsPerOneDay = 86400 * ((Double(userDay) ?? 1.0) * 30)
                    UserDefaults.standard.set(true, forKey: "monthSelected")
                    print("Секунды = \(secondsPerOneDay)")
                case "Год":
                    print("year")
                    secondsPerOneDay = 86400 * ((Double(userDay) ?? 1.0) * 365)
                    print(secondsPerOneDay)
                default:
                    break
                }
            }
            UserDefaults.standard.set(secondsPerOneDay, forKey: "userSelectedDailyCycle")
        }
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

extension AddNewTVC: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}




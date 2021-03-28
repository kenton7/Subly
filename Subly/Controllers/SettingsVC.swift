//
//  SettingsVC.swift
//  Subly
//
//  Created by Илья Кузнецов on 10.02.2021.
//

import UIKit
import UserNotifications
import LocalAuthentication


class SettingsVC: UITableViewController {
    
    private var currencyPickerView = UIPickerView()
    private var pickerView = UIPickerView()
    private var currencies = Currenices()
    private let userNotificationCenter = UNUserNotificationCenter.current()

    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var faceIdSwitchOutlet: UISwitch!
    @IBOutlet weak var hapticSwitchOutlet: UISwitch!
    @IBOutlet weak var iCloudSwitchOutlet: UISwitch!
    @IBOutlet weak var notificationsSwitchOutlet: UISwitch!
    @IBOutlet weak var renewSubSwitchOutlet: UISwitch!
    @IBOutlet weak var biometricPictureOutlet: UIImageView!
    @IBOutlet weak var biometricNameLabelOutlet: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 60
        
        switch self.biometricType() {
        case .faceID:
            biometricPictureOutlet.image = UIImage(named: "icons8-face-id-96")
            biometricNameLabelOutlet.text = "Вход по FaceID"
        default:
            biometricPictureOutlet.image = UIImage(named: "icons8-touch-id-96")
            biometricNameLabelOutlet.text = "Вход по TouchID"
        }
        
        if UserDefaults.standard.bool(forKey: "SwitchStatus") {
            faceIdSwitchOutlet.isOn = true
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            UserDefaults.standard.set(true, forKey: "faceId")
        } else {
            faceIdSwitchOutlet.isOn = false
            UserDefaults.standard.set(false, forKey: "faceId")
        }
        
        if UserDefaults.standard.bool(forKey: "hapticOn") {
            hapticSwitchOutlet.isOn = true
            UserDefaults.standard.set(true, forKey: "haptic")
            print("haptic is on")
        } else {
            hapticSwitchOutlet.isOn = false
            UserDefaults.standard.set(false, forKey: "haptic")
            print("haptic is off")
        }
        
    
        currencyTextField.text = (UserDefaults.standard.value(forKey: "currencySelected") as? String ?? currencies.currencies[0])
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePicker), name: UITextField.textDidBeginEditingNotification, object: nil)
        createPickerViewWithCurrencies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func biometricType() -> BiometricType {
        let context = LAContext()
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        }
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
    
    @objc private func updatePicker(){
        self.pickerView.reloadAllComponents()
    }
    
    @objc private func currencyPressed() {
        UserDefaults.standard.set(currencies.currencies[currencyPickerView.selectedRow(inComponent: 0)], forKey: "currencySelected")
        print("Валюта по умолчанию изменена")
        currencyTextField.text = UserDefaults.standard.string(forKey: "currencySelected")
        self.view.endEditing(true)
    }
    
    @IBAction func notificationsSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            print("Уведомления включены")
        } else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            print("Уведомления выключены")
        }
    }
    @IBAction func tapticSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            hapticSwitchOutlet.isOn = true
            UserDefaults.standard.set(true, forKey: "hapticOn")
            UserDefaults.standard.set(true, forKey: "haptic")
            print("haptic is on")
        } else {
            hapticSwitchOutlet.isOn = false
            UserDefaults.standard.set(false, forKey: "hapticOn")
            UserDefaults.standard.set(false, forKey: "haptic")
            print("haptic is off")
        }
    }
    
    @IBAction func faceIDTouchIDSwitch(_ sender: UISwitch) {
        if sender.isOn {
            faceIdSwitchOutlet.isOn = true
            UserDefaults.standard.set(true, forKey: "SwitchStatus")
            UserDefaults.standard.set(true, forKey: "faceId")
        } else {
            faceIdSwitchOutlet.isOn = false
            UserDefaults.standard.set(false, forKey: "SwitchStatus")
            UserDefaults.standard.set(false, forKey: "faceId")
            print("face id is off")
        }
    }
    
    // MARK: - Table view data source
    
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
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.systemBackground
//        return headerView
//    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
      if let headerView = view as? UITableViewHeaderFooterView {
        headerView.backgroundColor = .clear
        headerView.contentView.backgroundColor = .clear
          headerView.textLabel?.textColor = .white
      }
  }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Основные"
        } else if section == 1 {
            return "Премиум"
        } else if section == 2 {
            return "Помощь"
        } else {
            return ""
        }
    }
}

// MARK: - UIPickerViewDelegate
extension SettingsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currencyTextField.isFirstResponder {
            return currencies.currencies.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies.currencies[row]
    }
    
}

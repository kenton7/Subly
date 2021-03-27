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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 60
        currencyTextField.text = (UserDefaults.standard.value(forKey: "currencySelected") as? String ?? currencies.currencies[0])
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePicker), name: UITextField.textDidBeginEditingNotification, object: nil)
        createPickerViewWithCurrencies()
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
        print("test")
    }
    
    @IBAction func faceIDTouchIDSwitch(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "faceId")
            let context = LAContext()
            var error: NSError? = nil
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                         error: &error) {
                let reason = "Пожалуйста, авторизуйтесь с помощью Touch ID."
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                       localizedReason: reason) { [weak self] (success, error) in
                    DispatchQueue.main.async {
                        guard success, error == nil else {
                            //failed
                            let alert = UIAlertController(title: "Авторизация не пройдена",
                                                          message: "Пожалуйста, попробуйте снова",
                                                          preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
                            self?.present(alert, animated: true, completion: nil)
                            return
                        }
                        //показываем другой экран
                        //success
                        let vc = MainViewController()
                        self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
                        }
                    }
            } else {
                //can not use
                let alert = UIAlertController(title: "Ой!",
                                              message: "Вы не можете использовать эту функцию",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } else {
            print("error")
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
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
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

//
//  MainCollectionView.swift
//  Subly
//
//  Created by Илья Кузнецов on 28.01.2021.
//

import UIKit
import RealmSwift
import MobileCoreServices
import UserNotifications

class MainViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBInspectable private var startColor: UIColor?
    @IBInspectable private var endColor: UIColor?
    @IBOutlet weak var subNameOutlet: UILabel!
    @IBOutlet weak var nextPaymentLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var daysMonthLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    
    
    
    private var subs: Results<Content>!
    private var data = [ContentModel]()
    public var arrayOfSubs = [String?]()
    private let gradientLayer = CAGradientLayer()
    private var imageName = ""
    private var nextDebit = Date()
    private let formatter = DateFormatter()
    private let content = Content()
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    let progressBarView = ProgressBarView()
    var progressValue: Float = 0
    var timer: Timer?
    let currentDate = Date()
    var endDate: Date?
    var userSetDate: Date?
    var newDateString: String?
    var newStringDate: String?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    let addNewTVC = AddNewTVC()
    
    var newDay = Date()

//    let progressBarView = ProgressBarView()
//    var progressValue: Float = 0
//    var timer: Timer?
//    let currentDate = Date()
//    var endDate: Date?
//    var userSetDate: Date?
//    private let formatter = DateFormatter()
//    private let content = Content()
//    var endTimeInterval = TimeInterval()
//    var new: Double?
    
//    private let noDataLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Вы не добавили подписок"
//        label.textAlignment = .center
//        label.textColor = .white
//        label.font = .systemFont(ofSize: 21, weight: .medium)
//        label.isHidden = true
//        return label
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subs = realm.objects(Content.self).sorted(byKeyPath: "paymentDate", ascending: false)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        navigationItem.setHidesBackButton(true, animated: true)
        
        //addNewTVC.updatingDatesWith()
        
        //updateProgress()
//        let stringDate = formatter.string(from: Date())
//        userSetDate = formatter.date(from: stringDate)
//        
//        endTimeInterval = currentDate.timeIntervalSince(userSetDate!)
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
//        endDate = content.nextPayment ?? Date()
//        //timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgress(with:)), userInfo: nil, repeats: true)
//        
//        //endDate = content.nextPayment ?? Date()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //addNewTVC.updatingDates()
        animateTable()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("экран закрыт")
    }
    
//    func updateProgress() {
//        //let startTimeInterval = Date.timeIntervalSince(userSetDate!)
//        formatter.dateFormat = "dd-MM-yyyy"
//        let todaysDate = Date()
//        let stringDate = formatter.string(from: todaysDate)
//        print("stringDate \(stringDate)")
////
////        newDateString = content.paymentDate ?? stringDate
////        let stringToDate = formatter.date(from: content.paymentDate ?? stringDate)
////
////        let endDateFromStringToDate = formatter.date(from: newStringDate ?? stringDate)
////        userSetDate = endDateFromStringToDate ?? Date()
////        print("endDateFromStringToDate \(endDateFromStringToDate)")
////        endDate = endDateFromStringToDate
////        print(stringToDate)
////        let timeInterval = userSetDate?.timeIntervalSince(endDate!)
////        print("end date = \(endDate)")
////        print("user's date = \(userSetDate)")
////        print("timeInterval \(timeInterval)")
//        guard let firstPayment = content.paymentDate else {
//            print("first nil")
//            return
//        }
//        guard let nextPayment = content.nextPayment else {
//            print("next nil")
//            return
//        }
//        let firstPaymentInDate = formatter.date(from: firstPayment)
//
//        let timeInterval = firstPaymentInDate?.timeIntervalSince(nextPayment ?? todaysDate)
//        print("firstPayment \(firstPayment)")
//        print("firstPaymentInDate \(firstPaymentInDate)")
//        print("nextPayment \(nextPayment)")
//        print("timeInterval \(firstPaymentInDate)")
//    }
    
    ///анимация table view
    private func animateTable() {
        tableView.reloadData()
            
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
            
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
            
        var index = 0
            
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
                
            index += 1
        }
    }
    
    private func setupGradient() {
        view.layer.addSublayer(gradientLayer)
    }
    
    ///принимаем данные обратно в первый сегвей
    @IBAction func unwindSegueToMain(_ segue: UIStoryboardSegue) {
        guard let addNewTVC = segue.source as? AddNewTVC else { return }
        addNewTVC.saveNewSub()
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        //addNewTVC.scheduleNotification()
        //addNewTVC.updateProgress()
        imageName = addNewTVC.imageName
        newDateString = addNewTVC.paymentDateOutlet.text
        newDay = addNewTVC.newDay!
        print("newDateString \(String(describing: newDateString))")
        tableView.isHidden = false
        ///обновляем таблицу
        tableView.reloadData()
    }
    
    @IBAction func unwindSegueFromCustomSubVC(_ segue: UIStoryboardSegue) {
        guard let addNewTVC = segue.source as? CustomSubTVC else { return }
        addNewTVC.saveNewSub()
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        newDateString = addNewTVC.dateTextField.text
        newDay = addNewTVC.newDay!
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let sub = subs![indexPath.row]
            let vc = segue.destination as! AddNewTVC
            vc.contentModel = sub
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
    
    
//    @objc func updateProgress() {
//        if currentDate >= endDate! {
//            print("current date > end date")
//            progressBarView.progressLayer.strokeEnd = 1.0
//            timer?.invalidate()
//            timer = nil
//        } else {
//            print("current date < end date")
//            let end = Date(timeIntervalSince1970: endTimeInterval)
//            var endTimeInterval2 = TimeInterval()
//            let now: Date = Date(timeIntervalSinceNow: 0)
//            endTimeInterval2 = endDate!.timeIntervalSince(userSetDate!)
//            let test = Date(timeIntervalSince1970: endTimeInterval2)
//            let percentage = (now.timeIntervalSince1970 - end.timeIntervalSince1970) * 100 / (test.timeIntervalSince1970 - end.timeIntervalSince1970)
//            progressValue += Float(percentage)
//            new = percentage
//            progressBarView.progressLayer.strokeEnd = CGFloat(progressValue)
//            print("progress = \(progressBarView.progressLayer.strokeEnd)")
//        }
//    }
}
    

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if subs!.isEmpty {
            DispatchQueue.main.async {
                self.tableView.setEmptyView(title: "У вас нет ни одной подписки.", message: "Нажмите на кнопку «Добавить» внизу", messageImage: UIImage(named: "icons8-hand-down-48")!)
            }
        } else {
            tableView.restore()
        }
        
        return subs!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let model = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as! TableViewCell
        
        let sub = subs![indexPath.row]
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.dateStyle = .short
        
    
        let currentDate = Date()
        print("currentDate \(currentDate)")
        print("sub.nextPayment \(sub.nextPayment)")
        print(sub.cycleDayWeekMonthYear)
        
        let day = UserDefaults.standard.integer(forKey: "day")
        let week = UserDefaults.standard.integer(forKey: "week")
        let month = UserDefaults.standard.integer(forKey: "month")
        let year = UserDefaults.standard.integer(forKey: "year")
        
        if currentDate >= sub.nextPayment! {
            print("more")
            if sub.cycleDayWeekMonthYear == "День" {
                let newDate = sub.nextPayment?.adding(days: day)
                newStringDate = formatter.string(from: newDate!)
                print("newStringDate \(newStringDate!)")
                cell.nextPaymentLabel.text = newStringDate
            } else if sub.cycleDayWeekMonthYear == "Неделя" {
                let newDate = sub.nextPayment?.adding(days: week)
                newStringDate = formatter.string(from: newDate!)
                print("newStringDate \(newStringDate!)")
                cell.nextPaymentLabel.text = newStringDate
            } else if sub.cycleDayWeekMonthYear == "Месяц" {
                let newDate = sub.nextPayment?.adding(months: month)
                newStringDate = formatter.string(from: newDate!)
                print("newStringDate \(newStringDate!)")
                cell.nextPaymentLabel.text = newStringDate
            } else if sub.cycleDayWeekMonthYear == "Год" {
                let newDate = sub.nextPayment?.adding(years: year)
                newStringDate = formatter.string(from: newDate!)
                print("newStringDate \(newStringDate!)")
                cell.nextPaymentLabel.text = newStringDate
            }
        } else {
            newStringDate = formatter.string(from: sub.nextPayment ?? Date())
            print("newStringDate \(newStringDate!)")
            cell.nextPaymentLabel.text = newStringDate
            print("less")
        }
        
//        if currentDate >= sub.nextPayment! {
//            print("more")
//            if UserDefaults.standard.value(forKey: "day") as! String == "День" {
//                let newDate = sub.nextPayment?.adding(days: UserDefaults.standard.value(forKey: "day") as! Int)
//                newStringDate = formatter.string(from: newDate!)
//                print(newStringDate)
//                cell.nextPaymentLabel.text = newStringDate
//            } else if UserDefaults.standard.value(forKey: "week") as! String == "Неделя" {
//                let newDate = sub.nextPayment?.adding(days: UserDefaults.standard.value(forKey: "day") as! Int)
//                newStringDate = formatter.string(from: newDate!)
//                cell.nextPaymentLabel.text = newStringDate
//            } else if UserDefaults.standard.value(forKey: "month") as! String == "Месяц" {
//                let newDate = sub.nextPayment?.adding(months: UserDefaults.standard.value(forKey: "month") as! Int)
//                newStringDate = formatter.string(from: newDate!)
//                cell.nextPaymentLabel.text = newStringDate
//            } else if UserDefaults.standard.value(forKey: "year") as! String == "Год" {
//                let newDate = sub.nextPayment?.adding(years: UserDefaults.standard.value(forKey: "year") as! Int)
//                newStringDate = formatter.string(from: newDate!)
//                cell.nextPaymentLabel.text = newStringDate
//            }
//        } else {
//            newStringDate = formatter.string(from: sub.nextPayment ?? Date())
//            cell.nextPaymentLabel.text = newStringDate
//            print("error")
//        }
//
//        if currentDate >= sub.nextPayment! {
//            let newDate = sub.nextPayment?.adding(days: UserDefaults.standard.value(forKey: "day") as! Int)
//            newStringDate = formatter.string(from: newDate!)
//            cell.nextPaymentLabel.text = newStringDate
//            print("more")
//        } else {
//            print("less")
//            newStringDate = formatter.string(from: sub.nextPayment ?? Date())
//            cell.nextPaymentLabel.text = newStringDate
//        }
//
//        if currentDate >= sub.nextPayment! {
//            sub.nextPayment = sub.nextPayment!.adding(days: UserDefaults.standard.value(forKey: "day") as! Int)
//            newDateString = formatter.string(from: sub.nextPayment!)
//            cell.nextPaymentLabel.text = newDateString
//            print("new = \(String(describing: newDateString))")
//        } else {
//            print("error")
//            newStringDate = formatter.string(from: sub.nextPayment ?? Date())
//            cell.nextPaymentLabel.text = newStringDate
//        }
        
        cell.layer.cornerRadius = 20
        cell.layer.shadowColor = UIColor.white.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.layer.shadowRadius = 12.0
        cell.layer.shadowOpacity = 0.7
        cell.layer.addSublayer(gradientLayer)
        cell.viewOutlet.layer.cornerRadius = 20
        cell.layer.addSublayer(gradientLayer)
        
        cell.amountLabel.text = sub.amount
        cell.currencyLabel.text = sub.currency
        cell.typeOfSub.text = sub.type
        cell.subNameLabel.text = sub.name
        //cell.daysLeftLabel.text = sub.nextPayment
        //newStringDate = formatter.string(from: sub.nextPayment ?? Date())
        //cell.nextPaymentLabel.text = newStringDate
        cell.imageOutlet.layer.cornerRadius = cell.imageOutlet.frame.size.width / 2
        cell.imageOutlet.image = UIImage(named: sub.imageName ?? "icons8-add-image-48")
        
        
        ///отправка уведомления
         func scheduleNotification() {
            
            let content = UNMutableNotificationContent() // Содержимое уведомления

            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            formatter.dateStyle = .short
            
            // Add the content to the notification content
            content.title = "Оплата подписки приближается"
            content.body = "Ваша подписка \(String(describing: sub.name)) закачивается совсем скоро!"
            print("sub.nextPayment! \(sub.nextPayment!)")
            let triggerDate = Calendar.current.dateComponents([.day, .month, .year], from: sub.nextPayment!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
            
            let identifier = "Local Notification"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            userNotificationCenter.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
            print("Функция вызвана")
        }
        scheduleNotification()
        print("Уведомление будет отправлено \(String(describing: sub.nextPayment!))")
        gradientLayer.colors = [UIColor.purple.cgColor, UIColor.link.cgColor]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    //удаляем данные из таблицы
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //выбираем объект для удаления
        //let sub = subs![indexPath.row]
        let deleteButton = UIContextualAction(style: .destructive, title: "") { [weak self] (contextualAction, view, boolValue) in

            let alertController = UIAlertController(title: "Подписка будет удалена 😢", message: "Вы уверены?", preferredStyle: .alert)
            
            guard let strongSelf = self else { return }
            
            let deleteAction = UIAlertAction(title: "Удалить", style: .default, handler: { (delete) in
                
                let sub = strongSelf.subs![indexPath.row]

                StorageManager.deleteObject(sub)

                tableView.deleteRows(at: [indexPath], with: .automatic)

                if strongSelf.subs!.isEmpty {
                    DispatchQueue.main.async {
                        strongSelf.tableView.setEmptyView(title: "У Вас нет ни одной подписки.", message: "Нажмите на кнопку «Добавить» внизу", messageImage: UIImage(named: "icons8-hand-down-48")!)
                    }
                } else {
                    DispatchQueue.main.async {
                        strongSelf.tableView.restore()
                    }
                }
            })
            
            deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
            alertController.addAction(deleteAction)

            let cancelAction = UIAlertAction(title: "Отменить", style: .default, handler: nil)
            alertController.addAction(cancelAction)

            strongSelf.present(alertController, animated: true, completion: nil)
        }
        deleteButton.image = UIImage(named: "icons8-trash-48")
        
        //
        deleteButton.backgroundColor = .systemBackground
        return UISwipeActionsConfiguration(actions: [deleteButton])
    }
    
}

// MARK: Date
extension Date {
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self)!
    }
    
    func adding(years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: self)!
    }
}
// MARK: UIViewController
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITableView
extension UITableView {
    
    func setEmptyView(title: String, message: String, messageImage: UIImage) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        messageImageView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.lightGray
        titleLabel.font = .systemFont(ofSize: 19, weight: .medium)
        
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = .systemFont(ofSize: 19, weight: .medium)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(messageLabel)
        
        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageImageView.image = messageImage
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        UIView.animate(withDuration: 1, animations: {
            
            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { (finish) in
            UIView.animate(withDuration: 1, animations: {
                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
            }, completion: { (finishh) in
                UIView.animate(withDuration: 1, animations: {
                    messageImageView.transform = CGAffineTransform.identity
                })
            })
            
        })
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}







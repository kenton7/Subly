//
//  MainCollectionView.swift
//  Subly
//
//  Created by Илья Кузнецов on 28.01.2021.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBInspectable private var startColor: UIColor?
    @IBInspectable private var endColor: UIColor?
    @IBOutlet weak var subNameOutlet: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var daysMonthLabel: UILabel!
    
    private var subs: Results<Content>!
    private var data = [ContentModel]()
    public var arrayOfSubs = [String]()
    private let gradientLayer = CAGradientLayer()
    private var imageName = ""
    
    
    private let noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "Вы не добавили подписок."
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subs = realm.objects(Content.self).sorted(byKeyPath: "paymentDate", ascending: false)
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        startListeningForConversations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    
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
//        if let startColor = startColor, let endColor = endColor {
//            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
//        }
    }
    
    private func startListeningForConversations() {
    
        guard !subs.isEmpty else {
            self.tableView.isHidden = false
            self.noDataLabel.isHidden = true
            view.addSubview(noDataLabel)
            self.noDataLabel.isHidden = false
            return
        }
        self.noDataLabel.isHidden = true
        self.tableView.isHidden = false
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    ///принимаем данные обратно в первый сегвей
    @IBAction func unwindSegueToMain(_ segue: UIStoryboardSegue) {
        guard let addNewTVC = segue.source as? AddNewTVC else { return }
        addNewTVC.saveNewSub()
        imageName = addNewTVC.imageName
        tableView.isHidden = false
        noDataLabel.isHidden = true
        ///обновляем таблицу
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noDataLabel.frame = CGRect(x: 10,
                                   y: (view.height - 300) / 2,
                                   width: view.width - 20,
                                   height: 100)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let sub = subs[indexPath.row]
            let vc = segue.destination as! AddNewTVC
            vc.content = sub
        }
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return subs.count
        //return arrayOfSubs.count
        //return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let model = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as! TableViewCell
        
        let sub = subs[indexPath.row]
        
        cell.layer.cornerRadius = 20
        cell.layer.shadowColor = UIColor.white.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.layer.shadowRadius = 12.0
        cell.layer.shadowOpacity = 0.7
        cell.layer.addSublayer(gradientLayer)
        cell.viewOutlet.layer.cornerRadius = 20
        cell.layer.addSublayer(gradientLayer)
        
        cell.amountLabel.text = String(sub.amount)
        cell.currencyLabel.text = sub.currency
        cell.typeOfSub.text = sub.type
        cell.subNameLabel.text = sub.name
        cell.daysLeftLabel.text = sub.paymentDate
        cell.imageOutlet.layer.cornerRadius = cell.imageOutlet.frame.size.width / 2
        cell.imageOutlet.image = UIImage(named: sub.imageName!)
        
        gradientLayer.colors = [UIColor.purple.cgColor, UIColor.link.cgColor]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //delete
            //some code
            tableView.beginUpdates()
            
            tableView.deleteRows(at: [indexPath], with: .left)
            
            tableView.endUpdates()
        }
    }
    
    ///удаляем данные из таблицы
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //выбираем объект для удаления
        let sub = subs[indexPath.row]
        let delete = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (contextualAction, view, boolValue) in
            StorageManager.deleteObject(sub)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            if self!.subs.isEmpty {
                DispatchQueue.main.async {
                    self!.tableView.isHidden = true
                    self!.noDataLabel.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    self!.tableView.isHidden = false
                    self!.noDataLabel.isHidden = true
                }
            }
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}





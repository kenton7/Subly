//
//  MainCollectionView.swift
//  Subly
//
//  Created by Илья Кузнецов on 28.01.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private var data = [ContentModel]()
    public var arrayOfSubs = [String]()
    private let gradientLayer = CAGradientLayer()
    @IBInspectable private var startColor: UIColor?
    @IBInspectable private var endColor: UIColor?
    
    
    private let noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "Вы не добавили подписок."
        label.textAlignment = .center
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        startListeningForConversations()
    }
    
    private func setupGradient() {
        view.layer.addSublayer(gradientLayer)
//        if let startColor = startColor, let endColor = endColor {
//            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
//        }
    }
    
    private func startListeningForConversations() {
    
        guard !arrayOfSubs.isEmpty else {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noDataLabel.frame = CGRect(x: 10,
                                   y: (view.height - 300) / 2,
                                   width: view.width - 20,
                                   height: 100)
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return arrayOfSubs.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let model = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as! TableViewCell
        cell.layer.cornerRadius = 20
        cell.layer.shadowColor = UIColor.white.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.layer.shadowRadius = 12.0
        cell.layer.shadowOpacity = 0.7
        cell.layer.addSublayer(gradientLayer)
        cell.viewOutlet.layer.cornerRadius = 20
        cell.layer.addSublayer(gradientLayer)
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
    
}




//
//  FirstVCForTabBar.swift
//  Subly
//
//  Created by Илья Кузнецов on 27.01.2021.
//

import UIKit
import Cards

class FirstVCForTabBar: UIViewController {
    
    private let card: CardHighlight = {
        let card = CardHighlight(frame: .zero)
        //configure
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.purple.cgColor, UIColor.link.cgColor]
        gradient.frame = card.frame
        card.backgroundColor = .link
        card.icon = UIImage(systemName: "pencil")
        card.title = "Test"
        card.itemTitle = "Apple Music"
        card.itemSubtitle = "Some Text"
        card.shadowBlur = 20
        card.buttonText = "GET"
        card.titleSize = 32
        card.textColor = .white
        card.itemTitleSize = 18
        return card
    }()
    
    private var data = [ContentModel]()
    private let gradientLayer = CAGradientLayer()
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        //table.isHidden = true
        table.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        return table
    }()
    
    private let noSubsLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавленные подписки отсутствуют."
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Подписки"
        view.backgroundColor = .systemBackground
        setupGradient()
        view.addSubview(card)
        view.addSubview(noSubsLabel)
        //setupTabBar()
        //setupTableView()
        startListeningForNewSubs()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noSubsLabel.frame = CGRect(x: 10,
                                   y: (view.height - 100) / 2,
                                   width: view.width - 20,
                                   height: 100)
        card.frame = CGRect(x: 0,
                            y: view.safeAreaInsets.top,
                            width: view.frame.size.width,
                            height: view.frame.size.width)
        gradientLayer.frame = view.bounds
    }
    
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func startListeningForNewSubs() {
        guard !data.isEmpty else {
            self.tableView.isHidden = true
            self.card.isHidden = true
            self.noSubsLabel.isHidden = false
            return
        }
        self.noSubsLabel.isHidden = true
        self.card.isHidden = false
        self.view.addSubview(card)
        self.tableView.isHidden = false
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setupGradient() {
        view.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [UIColor.purple.cgColor, UIColor.link.cgColor]
    }
}

extension FirstVCForTabBar: CardDelegate {
    
}

extension FirstVCForTabBar: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        cell.configure(with: model)
        return cell
    }
}

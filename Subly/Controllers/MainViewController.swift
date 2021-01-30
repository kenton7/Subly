//
//  ViewController.swift
//  Subly
//
//  Created by Илья Кузнецов on 27.01.2021.
//

import UIKit
import Cards

class MainViewController: UIViewController {
    
//    private let card: CardHighlight = {
//        let card = CardHighlight(frame: .zero)
//        //configure
//        card.backgroundColor = .link
//        card.icon = UIImage(systemName: "pencil")
//        card.title = "Test"
//        card.itemTitle = "Apple Music"
//        card.itemSubtitle = "Some Text"
//        card.shadowBlur = 20
//        card.buttonText = "GET"
//        card.titleSize = 32
//        card.textColor = .white
//        card.itemTitleSize = 18
//        return card
//    }()
    
    private var data = [ContentModel]()
    private let imagesForTabBar = ["house.fill", "plus.circle.fill", "gearshape.fill"]
    
//    private let tableView: UITableView = {
//       let table = UITableView()
//        //table.isHidden = true
//        table.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
//        return table
//    }()
//
//    private let noSubsLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Добавленные подписки отсутствуют."
//        label.textAlignment = .center
//        label.textColor = .gray
//        label.font = .systemFont(ofSize: 21, weight: .medium)
//        label.isHidden = true
//        return label
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTabBar()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//        noSubsLabel.frame = CGRect(x: 10,
//                                    y: (view.height - 100) / 2,
//                                    width: view.width - 20,
//                                    height: 100)
//    }
    
//    private func setupTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
    
//    private func startListeningForNewSubs() {
//        guard !data.isEmpty else {
//            self.tableView.isHidden = true
//            self.noSubsLabel.isHidden = false
//            return
//        }
//        self.noSubsLabel.isHidden = true
//        self.tableView.isHidden = false
//
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
    
    func setupTabBar() {
        let tabBarVC = UITabBarController()
        let vc1 = UINavigationController(rootViewController: FirstVCForTabBar())
        vc1.navigationBar.prefersLargeTitles = true
        vc1.title = "Главная"
        let vc3 = UINavigationController(rootViewController: ThirdVCForTabBar())
        vc3.title = "Добавить"
        vc3.navigationBar.prefersLargeTitles = true
        let vc5 = UINavigationController(rootViewController: FifthVCForTabBar())
        vc5.title = "Настройки"
        vc5.navigationBar.prefersLargeTitles = true
        
        tabBarVC.setViewControllers([vc1, vc3, vc5], animated: false)
        guard let items = tabBarVC.tabBar.items else { return }
        for x in 0..<items.count {
            items[x].image = UIImage(systemName: imagesForTabBar[x])
        }
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true, completion: nil)
        print("showed")
    }
}

extension MainViewController: CardDelegate {
    
}

//extension MainViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let model = data[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
//        cell.configure(with: model)
//        return cell
//    }
//}


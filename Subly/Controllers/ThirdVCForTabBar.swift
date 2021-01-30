//
//  ThirdVCForTabBar.swift
//  Subly
//
//  Created by Илья Кузнецов on 27.01.2021.
//

import UIKit

class ThirdVCForTabBar: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(AddTableViewCell.self, forCellReuseIdentifier: AddTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        //tableView.delegate = self
        title = "Добавить"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

//extension ThirdVCForTabBar: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//}

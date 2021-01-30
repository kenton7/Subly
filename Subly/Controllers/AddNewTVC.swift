//
//  AddNewTVC.swift
//  Subly
//
//  Created by Илья Кузнецов on 30.01.2021.
//

import UIKit

class AddNewTVC: UITableViewController {
    
    private let arrayOfField = AddNewSubFields()
    
    @IBOutlet weak var trialButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        //trialButtonOutlet.setTitle("Да", for: .normal)
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

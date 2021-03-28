//
//  NewSubVC.swift
//  Subly
//
//  Created by Илья Кузнецов on 30.01.2021.
//

import UIKit

class NewSubVC: UIViewController {
    
    var productName = ""
    var imageName = ""
    var indexesNeedPicker: [IndexPath]?
    let cell = NewSubCell()
    private var content: Content!
    
    public var amountToDouble: Double?
    public var currency: String?
    public var paymentType: String?
    public var paymentDate: Date?
    public var cycle: String?
    public var notifyMe: String?
    public var typeOfSub: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(productName)
        
        if UserDefaults.standard.bool(forKey: "hapticOn") {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            UserDefaults.standard.set(true, forKey: "haptic")
            print("haptic is on")
        } else {
            UserDefaults.standard.set(false, forKey: "haptic")
            print("haptic is off")
        }
        
        //subNameLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        //tableView.delegate = self
        //tableView.dataSource = self
        //        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.tintColor = .systemBackground
        navigationController?.navigationItem.rightBarButtonItem?.title = "Добавить"
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
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let vc = segue.source as? AddNewTVC else { return }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newTable" {
            let destinationVC = segue.destination as? AddNewTVC
            destinationVC!.name = productName
            destinationVC!.imageName = imageName
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension NewSubVC: UITableViewDelegate, UITableViewDataSource {
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return arrayOfField.arrayOfFields.count
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewSubCell.identifier) as! NewSubCell
        cell.titleLabel?.text = cell.arrayOfFields[indexPath.section]
        cell.imageViewOutlet.image = UIImage(named: imageName)
        cell.titleLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            cell.textFieldOutlet.isHidden = true
        case 1:
            print("1")
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
}



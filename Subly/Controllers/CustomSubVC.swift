//
//  CustomSubVC.swift
//  Subly
//
//  Created by Илья Кузнецов on 26.03.2021.
//

import UIKit

class CustomSubVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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

}

extension CustomSubVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomSubCell.identifier) as! CustomSubCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
}

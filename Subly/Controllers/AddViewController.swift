//
//  AddViewController.swift
//  Subly
//
//  Created by Илья Кузнецов on 30.01.2021.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let model = [ContentModel]()
    let data = Items()
    let addCell = AddCell()
    var kek = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = self.view.bounds
        tableView.tableFooterView = UIView()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    if(velocity.y>0) {
        UIView.animate(withDuration: 1.0, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            print("Hide")
        }, completion: nil)

    } else {
        UIView.animate(withDuration: 1.0, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            print("Unhide")
        }, completion: nil)
      }
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newSub" {
            if let nav = segue.destination as? UINavigationController,
               let vc = nav.topViewController as? NewSubVC {
                
                let sortedArray = data.arrayOfItemTitles.sorted(by: <)
                let selectedRow = tableView.indexPathForSelectedRow!.section
                vc.productName = sortedArray[selectedRow]
            }
        }
    }
    
}

// MARK: - UITableViewDelegate
extension AddViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.arrayOfItemTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view:UIView = UIView.init(frame:
                                        CGRect.init(x: 0,
                                                    y: 0,
                                                    width: self.view.bounds.size.width,
                                                    height: 10))
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddCell.identifier) as! AddCell
        cell.labelOutlet.text = cell.arrayOfItemTitles.sorted(by: <)[indexPath.section]
        cell.labelOutlet?.font = .systemFont(ofSize: 19, weight: .semibold)
        cell.configureImageView()
        //cell.textLabel?.text = self.items.arrayOfItemTitles[indexPath.row]
        cell.layer.cornerRadius = 20
        cell.layer.shadowColor = UIColor.white.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.layer.shadowRadius = 12.0
        cell.layer.shadowOpacity = 0.7
        cell.addCellViewOutlet.layer.cornerRadius = 20
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

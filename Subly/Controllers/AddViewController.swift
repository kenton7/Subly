//
//  AddViewController.swift
//  Subly
//
//  Created by Илья Кузнецов on 30.01.2021.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchOutlet: UISearchBar!
    
    let model = [ContentModel]()
    let data = Items()
    let addCell = AddCell()
    var filteredData: [String] = []
    var searchController: UISearchController!
    var subsArray = [ImagesAndNames]()
    var currentArray = [ImagesAndNames]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tabBarController?.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = self.view.bounds
        tableView.tableFooterView = UIView()
        self.hideKeyboardWhenTappedAround()
        searchOutlet.delegate = self
        filteredData = data.arrayOfItemTitles
        setupContent()
        print(filteredData)
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentArray = subsArray
        //searchController.searchBar.searchTextField.text = ""
        //searchController = UISearchController(searchResultsController: nil)
        animateTable()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
    
    private func setupContent() {
        subsArray.append(ImagesAndNames(imageName: "1Blocker", name: "1Blocker"))
        subsArray.append(ImagesAndNames(imageName: "onePassword", name: "1Password"))
        subsArray.append(ImagesAndNames(imageName: "500px-logo", name: "500px"))
        subsArray.append(ImagesAndNames(imageName: "adGuard", name: "AdGuard VPN"))
        subsArray.append(ImagesAndNames(imageName: "adobeCreativeCloud", name: "Adobe Creative Cloud"))
        subsArray.append(ImagesAndNames(imageName: "amazonPrimeVideo", name: "Amazon Prime Video"))
        subsArray.append(ImagesAndNames(imageName: "appleArcade", name: "Apple Arcade"))
        subsArray.append(ImagesAndNames(imageName: "AppleDeveloper", name: "Apple Developer Program"))
        subsArray.append(ImagesAndNames(imageName: "AppleFitness", name: "Apple Fitness+"))
        subsArray.append(ImagesAndNames(imageName: "appleMusic", name: "Apple Music"))
        subsArray.append(ImagesAndNames(imageName: "AppleNews", name: "Apple News+"))
        subsArray.append(ImagesAndNames(imageName: "AppleOne", name: "Apple One"))
        subsArray.append(ImagesAndNames(imageName: "AppleTV", name: "Apple TV+"))
        subsArray.append(ImagesAndNames(imageName: "bookmate", name: "Bookmate"))
        subsArray.append(ImagesAndNames(imageName: "codeAcademy", name: "Code Academy"))
        subsArray.append(ImagesAndNames(imageName: "deezer", name: "Deezer"))
        subsArray.append(ImagesAndNames(imageName: "disneyPlus", name: "Disney+"))
        subsArray.append(ImagesAndNames(imageName: "dropBox", name: "DropBox"))
        subsArray.append(ImagesAndNames(imageName: "eaAccess", name: "EA Access"))
        subsArray.append(ImagesAndNames(imageName: "evernote", name: "Evernote"))
        subsArray.append(ImagesAndNames(imageName: "figma", name: "Figma"))
        subsArray.append(ImagesAndNames(imageName: "firebase", name: "Flickr"))
        subsArray.append(ImagesAndNames(imageName: "geForce", name: "GeForce Now"))
        subsArray.append(ImagesAndNames(imageName: "gitHub", name: "GitHub"))
        subsArray.append(ImagesAndNames(imageName: "googleDrive", name: "Google Drive"))
        subsArray.append(ImagesAndNames(imageName: "googleMusic", name: "Google Музыка"))
        subsArray.append(ImagesAndNames(imageName: "googleFilms", name: "Google Фильмы"))
        subsArray.append(ImagesAndNames(imageName: "googlePhoto", name: "Google Фото"))
        subsArray.append(ImagesAndNames(imageName: "hbo", name: "HBO"))
        subsArray.append(ImagesAndNames(imageName: "htmlAcademy", name: "HTML Academy"))
        subsArray.append(ImagesAndNames(imageName: "javaRush", name: "Java Rush"))
        subsArray.append(ImagesAndNames(imageName: "jira", name: "Jira"))
        subsArray.append(ImagesAndNames(imageName: "kaspersky", name: "Kaspersky"))
        subsArray.append(ImagesAndNames(imageName: "lineMusic", name: "LINE Music"))
        subsArray.append(ImagesAndNames(imageName: "lightroom", name: "Lightroom"))
        subsArray.append(ImagesAndNames(imageName: "megogo", name: "MEGOGO"))
        subsArray.append(ImagesAndNames(imageName: "medium", name: "Medium"))
        subsArray.append(ImagesAndNames(imageName: "oneDrive", name: "One Drive"))
        subsArray.append(ImagesAndNames(imageName: "moreTv", name: "More.TV"))
        subsArray.append(ImagesAndNames(imageName: "netflix", name: "Netflix"))
        subsArray.append(ImagesAndNames(imageName: "nintendo", name: "Nintendo Online"))
        subsArray.append(ImagesAndNames(imageName: "okko", name: "Okko"))
        subsArray.append(ImagesAndNames(imageName: "premier", name: "ТНТ Премьер"))
        subsArray.append(ImagesAndNames(imageName: "pubg", name: "PUBG Mobile"))
        subsArray.append(ImagesAndNames(imageName: "parallelsAccess", name: "Parallels Access"))
        subsArray.append(ImagesAndNames(imageName: "parallelsDesktop", name: "Parallels Desktop"))
        subsArray.append(ImagesAndNames(imageName: "playstationPlus", name: "Playstation Plus"))
        subsArray.append(ImagesAndNames(imageName: "pocket", name: "Pocket"))
        subsArray.append(ImagesAndNames(imageName: "puzzleEng", name: "Puzzle English"))
        subsArray.append(ImagesAndNames(imageName: "start", name: "START"))
        subsArray.append(ImagesAndNames(imageName: "sketch", name: "Sketch"))
        subsArray.append(ImagesAndNames(imageName: "soundcloud", name: "SoundCloud"))
        subsArray.append(ImagesAndNames(imageName: "spotify", name: "Spotify"))
        subsArray.append(ImagesAndNames(imageName: "storytel", name: "Storytel"))
        subsArray.append(ImagesAndNames(imageName: "tj", name: "TJournal Plus"))
        subsArray.append(ImagesAndNames(imageName: "teleTwo", name: "Теле 2"))
        subsArray.append(ImagesAndNames(imageName: "tinder", name: "Tinder"))
        subsArray.append(ImagesAndNames(imageName: "tunnelBear", name: "Tunnel Bear"))
        subsArray.append(ImagesAndNames(imageName: "twitch", name: "Twitch"))
        subsArray.append(ImagesAndNames(imageName: "vkMusic", name: "VK Музыка"))
        subsArray.append(ImagesAndNames(imageName: "vsco", name: "VSCO"))
        subsArray.append(ImagesAndNames(imageName: "vimeo", name: "Vimeo"))
        subsArray.append(ImagesAndNames(imageName: "xboxLive", name: "Xbox Live"))
        subsArray.append(ImagesAndNames(imageName: "yota", name: "YOTA"))
        subsArray.append(ImagesAndNames(imageName: "youtube", name: "YouTube"))
        subsArray.append(ImagesAndNames(imageName: "youtubePremium", name: "YouTube Premium"))
        subsArray.append(ImagesAndNames(imageName: "youtubeMusic", name: "YouTube Music"))
        subsArray.append(ImagesAndNames(imageName: "zoom", name: "Zoom"))
        subsArray.append(ImagesAndNames(imageName: "zvooq", name: "Zvooq"))
        subsArray.append(ImagesAndNames(imageName: "iCloud", name: "iCloud"))
        subsArray.append(ImagesAndNames(imageName: "ivi", name: "ivi"))
        subsArray.append(ImagesAndNames(imageName: "amediateka", name: "Амедиатека"))
        subsArray.append(ImagesAndNames(imageName: "beeline", name: "Билайн"))
        subsArray.append(ImagesAndNames(imageName: "kinopoiskHd", name: "Кинопоиск HD"))
        subsArray.append(ImagesAndNames(imageName: "mgts", name: "МГТС"))
        subsArray.append(ImagesAndNames(imageName: "mts", name: "МТС"))
        subsArray.append(ImagesAndNames(imageName: "megafon", name: "Мегафон"))
        subsArray.append(ImagesAndNames(imageName: "rostelekom", name: "Ростекелом"))
        subsArray.append(ImagesAndNames(imageName: "sber", name: "Сбер"))
        subsArray.append(ImagesAndNames(imageName: "yandexDisk", name: "Яндекс Диск"))
        subsArray.append(ImagesAndNames(imageName: "yandexPlus", name: "Яндекс плюс"))
        
        currentArray = subsArray
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
    
//    func dismissAlert() {
//
//        let bounds = view.bounds
//        let smallFrame = view.frame.insetBy(dx: view.frame.size.width / 4, dy: view.frame.size.height / 4)
//        let finalFrame = smallFrame.offsetBy(dx: 0, dy: bounds.size.height)
//
//
//        UIView.animateKeyframes(withDuration: 4, delay: 0, options: .calculationModeCubic, animations: {
//            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
//                self.view.frame = smallFrame
//            }
//            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
//                self.view.frame = finalFrame
//            }
//        }, completion: nil)
//    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        //dismissAlert()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newSub" {
            if let nav = segue.destination as? UINavigationController,
               let vc = nav.topViewController as? NewSubVC {
                //let sortedArray = filteredData.sorted(by: <)
                //let sortedArray = data.arrayOfItemTitles.sorted(by: <)
                let selectedRow = tableView.indexPathForSelectedRow!.section
                vc.productName = currentArray[selectedRow].name
                vc.imageName = currentArray[selectedRow].imageName
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - UITableViewDelegate
extension AddViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentArray.count
        //return data.arrayOfItemTitles.count
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
        cell.labelOutlet.text = currentArray[indexPath.section].name
        cell.imageViewOutlet.image = UIImage(named: currentArray[indexPath.section].imageName)
        //cell.labelOutlet.text = filteredData.sorted(by: <)[indexPath.section]
        //cell.labelOutlet.text = cell.arrayOfItemTitles.sorted(by: <)[indexPath.section]
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
        //self.searchOutlet.searchTextField.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchOutlet.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchOutlet.endEditing(true)
    }
}

// MARK: - UITabBarControllerDelegate
extension AddViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else { currentArray = subsArray
            tableView.reloadData()
            return
        }
        currentArray = subsArray.filter({ (item) -> Bool in
            guard let text = searchBar.text else { return false }
            return item.name.lowercased().contains(text.lowercased())
        })
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? data.arrayOfItemTitles : data.arrayOfItemTitles.filter({(dataString: String) -> Bool in
                return dataString.range(of: searchText, options: .caseInsensitive) != nil
                })
                tableView.reloadData()
            }
    }
}

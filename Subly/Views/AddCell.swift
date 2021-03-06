//
//  AddCell.swift
//  Subly
//
//  Created by Илья Кузнецов on 30.01.2021.
//

import UIKit

class AddCell: UITableViewCell {

    static let identifier = "addCell"
    var arrayOfItemTitles = ["Spotify", "Apple Music", "VK Music", "iCloud", "Okko", "MEGOGO", "More.TV", "PREMIER", "START", "Storytel", "Tele 2", "МТС", "Билайн", "Мегафон", "YOTA", "Zvooq", "ivi", "Амедиатека", "Кинопоиск HD", "Яндекс+", "Яндекс Диск", "1Password", "Adobe Creative Cloud", "Apple Arcade", "Apple TV+", "Apple Developer Program", "Apple News+", "Apple Fitness", "Apple One", "Deezer", "Disney+", "Dropbox", "Evernote", "Github", "Firebase", "Google Drive", "Google Фото", "Google Play Фильмы", "Google Play Музыка", "HBO", "LINE Music", "Medium", "Microsoft OneDrive", "Netflix", "PUBG Mobile Prime", "Parallels Desktop", "Parallels Access", "PlayStation Plus", "SoundCloud", "Tinder", "TunnelBear", "Twitch", "VSCO X", "Xbox Live", "YouTube", "YouTube Music", "YouTube Premium", "500px", "1Blocker", "AdGuard VPN", "Bookmate", "Codeacademy", "EA Access", "Figma", "Flickr", "GeForce Now", "HTML Academy", "JavaRush", "Jira", "Kaspersky", "Lightroom", "MGTS", "Ростелеком", "Nintendo Online", "Pocket", "Amazon Prime Video", "Puzzle English", "SkyEng", "Сбер", "Sketch", "TJournal Plus", "Vimeo", "Zoom"]
    
    @IBOutlet weak var labelOutlet: UILabel!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var addCellViewOutlet: UIView!
    
    public func configureImageView() {
        imageViewOutlet.layer.cornerRadius = imageViewOutlet.frame.size.width / 2
    }
    
}

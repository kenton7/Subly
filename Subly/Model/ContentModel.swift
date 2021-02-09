//
//  ContentModel.swift
//  Subly
//
//  Created by Илья Кузнецов on 27.01.2021.
//

import Foundation
import RealmSwift

struct ContentModel {
    var subName: String
    var daysLeft: String
    var currency: String
    var amount: String
    var typeOfSub: String
    var image: Data
}

struct Items {
    
    var arrayOfItemTitles = ["Spotify", "Apple Music", "VK Music", "iCloud", "Okko", "MEGOGO", "More.TV", "PREMIER", "START", "Storytel", "Tele 2", "МТС", "Билайн", "Мегафон", "YOTA", "Zvooq", "ivi", "Амедиатека", "Кинопоиск HD", "Яндекс+", "Яндекс Диск", "1Password", "Adobe Creative Cloud", "Apple Arcade", "Apple TV+", "Apple Developer Program", "Apple News+", "Apple Fitness", "Apple One", "Deezer", "Disney+", "Dropbox", "Evernote", "Github", "Firebase", "Google Drive", "Google Фото", "Google Play Фильмы", "Google Play Музыка", "HBO", "LINE Music", "Medium", "Microsoft OneDrive", "Netflix", "PUBG Mobile Prime", "Parallels Desktop", "Parallels Access", "PlayStation Plus", "SoundCloud", "Tinder", "TunnelBear", "Twitch", "VSCO X", "Xbox Live", "YouTube", "YouTube Music", "YouTube Premium", "500px", "1Blocker", "AdGuard VPN", "Bookmate", "Codeacademy", "EA Access", "Figma", "Flickr", "GeForce Now", "HTML Academy", "JavaRush", "Jira", "Kaspersky", "Lightroom", "MGTS", "Ростелеком", "Nintendo Online", "Pocket", "Amazon Prime Video", "Puzzle English", "SkyEng", "Сбер", "Sketch", "TJournal Plus", "Vimeo", "Zoom"].sorted(by: <)
}

class ImagesAndNames {
    let imageName: String
    let name: String
    
    init(imageName: String, name: String) {
        self.imageName = imageName
        self.name = name
    }
}

struct Currenices {
    let currencies = ["RUB - ₽", "USD - $", "EUR - €", "UAH - ₴", "AUD - AU$", "BRL - ₽", "CAD - $", "CNY - ¥", "CZK - Kč", "DKK - Dč", "GBP - £", "ILS - ₪", "INR - ₹", "JPY - ¥", "KRW - ₩", "KZT - ₸", "PHP - ₱", "PLN - zł", "TRY - ₺", "VND - ₫"]
}

class Content: Object {
    @objc dynamic var amount = 0.0
    @objc dynamic var currency: String?
    @objc dynamic var note: String?
    @objc dynamic var paymentDate: String?
    @objc dynamic var cycle: String?
    @objc dynamic var notifyMe: String?
    @objc dynamic var trial: Data?
    @objc dynamic var type: String?
    @objc dynamic var name: String?
    @objc dynamic var imageName: String?
    
    convenience init(name: String, amount: Double, currency: String, note: String, paymentDate: String, cycle: String, notifyMe: String, trial: Data, type: String, imageName: String) {
        //инициализируем значения по умолчанию
        self.init()
        self.name = name
        self.amount = amount
        self.currency = currency
        self.note = note
        self.paymentDate = paymentDate
        self.cycle = cycle
        self.notifyMe = notifyMe
        self.trial = trial
        self.type = type
        self.imageName = imageName
    }
}

struct Cycle {
    let cycleDays = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
}

struct NotifyMe {
    let days = ["Не уведомлять", "В этот же день", "За 1 день", "За 2 дня", "За 3 дня", "За 5 дней", "за 7 дней", "За 10 дней", "За 14 дней"]
}

struct Type {
    let type = ["День", "Неделя", "Месяц", "Год"]
}


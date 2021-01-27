//
//  CardContentController.swift
//  Subly
//
//  Created by Илья Кузнецов on 27.01.2021.
//

import UIKit

class CardContentController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
        let label = UILabel(frame: CGRect(x: 20,
                                          y: view.safeAreaInsets.top,
                                          width: view.frame.size.width - 40,
                                          height: 100))
        view.addSubview(label)
        label.textAlignment = .center
        label.text = "Test Text"
        label.font = .systemFont(ofSize: 21, weight: .semibold)
    }
}

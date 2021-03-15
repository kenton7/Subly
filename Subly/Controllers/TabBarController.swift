//
//  TabBarController.swift
//  Subly
//
//  Created by Илья Кузнецов on 14.03.2021.
//

import UIKit

class TabBarController: UITabBarController {
    
    var firstItemImageView: UIImageView!
    var secondItemImageView: UIImageView!
    var thirdItemImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prominentTabBar = self.tabBar as! TabBarView
            prominentTabBar.prominentButtonCallback = prominentTabTaped
        
        let firstItemView = self.tabBar.subviews[0]
        let secondItemView = self.tabBar.subviews[1]
        let thirdItemView = self.tabBar.subviews[2]
        
        self.firstItemImageView = firstItemView.subviews.first as? UIImageView
        self.firstItemImageView.contentMode = .center
        
        self.secondItemImageView = secondItemView.subviews.first as? UIImageView
        self.secondItemImageView.contentMode = .center
        
        self.thirdItemImageView = thirdItemView.subviews.first as? UIImageView
        self.thirdItemImageView.contentMode = .center
    }
    
    func prominentTabTaped() {
        selectedIndex = (tabBar.items?.count ?? 0)/2
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            ///анимации для каждой кнопки в tab bar с присвоенным tag
            /// по 2 анимации для того, чтобы был поворот на 360 градусов
            self.firstItemImageView.transform = CGAffineTransform.identity
            
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.firstItemImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            
            UIView.animate(withDuration: 0.5, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
                self.firstItemImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            }, completion: nil)
        } else if item.tag == 2 {
            self.secondItemImageView.transform = CGAffineTransform.identity
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.secondItemImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            
            UIView.animate(withDuration: 0.5, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
                self.secondItemImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            }, completion: nil)
        } else if item.tag == 3 {
            self.thirdItemImageView.transform = CGAffineTransform.identity
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.thirdItemImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            
            UIView.animate(withDuration: 0.5, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
                self.thirdItemImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            }, completion: nil)
        }
    }
}

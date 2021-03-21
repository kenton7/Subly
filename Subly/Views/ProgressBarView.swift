//
//  ProgressBarView.swift
//  Subly
//
//  Created by Илья Кузнецов on 15.03.2021.
//

import UIKit

class ProgressBarView: UIView {

    var bgPath: UIBezierPath!
    var shapeLayer: CAShapeLayer!
    var progressLayer: CAShapeLayer!
    var maxProgress: Float!
    let colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
    let startingPoint = CGPoint(x: 0, y: 0)
    let endingPoint = CGPoint(x: 1, y: 1)
    let cornerRadiusOfMyView = CGFloat(10)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            bgPath = UIBezierPath()
            self.simpleShape()
        }
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            bgPath = UIBezierPath()
            self.simpleShape()
        }
    
        
        func simpleShape() {
            createCirclePath()
            //риусем не заполненный круг
            shapeLayer = CAShapeLayer()
            shapeLayer.path = bgPath.cgPath
            shapeLayer.lineWidth = 7
            shapeLayer.fillColor = nil
            shapeLayer.strokeColor = UIColor.lightGray.cgColor
            
            //риусем слой прогресса
            progressLayer = CAShapeLayer()
            progressLayer.path = bgPath.cgPath
            progressLayer.lineCap = CAShapeLayerLineCap.round
            progressLayer.lineWidth = 7
            progressLayer.fillColor = nil
//            progressLayer.strokeColor = UIColor.init(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).cgColor
            progressLayer.strokeColor = UIColor.red.cgColor
            progressLayer.strokeEnd = 0
            

            self.layer.addSublayer(shapeLayer)
            self.layer.addSublayer(progressLayer)
        }
        
        private func createCirclePath() {
            let x = self.frame.width / 2
            let y = self.frame.height / 2
            let center = CGPoint(x: x, y: y)
            bgPath = UIBezierPath(arcCenter: center, radius: 45, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
            bgPath.close()
        }

//    func updateProgress(with value: Float) {
//        if value > Float(UserSettings.result!) {
//            progressLayer.strokeEnd = 1.0
//            progressLayer.strokeColor = UIColor.green.cgColor
//            if progressLayer.strokeEnd >= 1.0 {
//                progressLayer.strokeColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
//            } else {
//                progressLayer.strokeColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
//            }
//            UserSettings.userProgress = Float(progressLayer.strokeEnd)
//                return
//            }
//        progressLayer.strokeEnd = CGFloat(value / Float(UserSettings.result))
//        //progressLayer.strokeEnd = CGFloat(value / maxProgress!)
//        UserSettings.userProgress = Float(progressLayer.strokeEnd)
//        }
//    }

}

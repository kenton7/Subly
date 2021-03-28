//
//  FaceIDViewController.swift
//  Subly
//
//  Created by Илья Кузнецов on 27.03.2021.
//

import UIKit
import LocalAuthentication

enum BiometricType {
    case none
    case touchID
    case faceID
}

class FaceIDViewController: UIViewController {
    
    @IBOutlet weak var faceIDButtonOutlet: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        faceIDButtonOutlet.isHidden = true
        navigationController?.navigationBar.isHidden = true
        faceIDButtonOutlet.layer.cornerRadius = 20
        
        faceIDRequest()
    }
    
    func faceIDRequest() {
        if UserDefaults.standard.bool(forKey: "faceId") {
            print("true")
            let context = LAContext()
            var error: NSError? = nil
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                         error: &error) {
                let reason = "Пожалуйста, авторизуйтесь с помощью Touch ID."
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                       localizedReason: reason) { [weak self] (success, error) in
                    DispatchQueue.main.async {
                        guard success, error == nil else {
                            //failed
                            let alert = UIAlertController(title: "Авторизация не пройдена",
                                                          message: "Пожалуйста, попробуйте снова",
                                                          preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
                            self?.faceIDButtonOutlet.isHidden = false
                            self?.present(alert, animated: true, completion: nil)
                            return
                        }
                        //показываем другой экран
                        //success
                        print("success")
                        self?.faceIDButtonOutlet.isHidden = true
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainViewController = mainStoryboard.instantiateViewController(identifier: "MainViewController")
                        self?.navigationController?.pushViewController(mainViewController, animated: false)
                        }
                    }
            } else {
                //can not use
                let alert = UIAlertController(title: "Ой!",
                                              message: "Вы не можете использовать эту функцию",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } else if UserDefaults.standard.bool(forKey: "faceId") == false {
            faceIDButtonOutlet.isHidden = true
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = mainStoryboard.instantiateViewController(identifier: "MainViewController")
            navigationController?.pushViewController(mainViewController, animated: false)
            print("error")
        }
    }
    
    func biometricType() -> BiometricType {
        let context = LAContext()
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        }
    }
    
    @IBAction func faceIDAction(_ sender: UIButton) {
        faceIDRequest()
    }
    
}

//
//  addCityVC.swift
//  appFactoryChallenge
//
//  Created by Raphaël Reiter on 12/11/2017.
//  Copyright © 2017 Raphaël Reiter. All rights reserved.
//

import UIKit

protocol AddCityDelegate {
    func userEnteredANewCityName(city: String)
}

class addCityVC: UIViewController {
   @IBOutlet weak var enterCityTextField: UITextField!
    
    var delegate : AddCityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backBtnWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getWeatherBtnWasPressed(_ sender: Any) {
      
        guard let cityName = enterCityTextField.text else { return }
        delegate?.userEnteredANewCityName(city: cityName)
        self.dismiss(animated: true, completion: nil)
    }
}

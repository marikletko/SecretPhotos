//
//  PasswordView.swift
//  Photos
//
//  Created by Kirill Letko on 12/29/19.
//  Copyright © 2019 Letko. All rights reserved.
//

import UIKit


protocol PasswordViewDelegate: AnyObject {
    func callback(_ someString: String)
}

class PasswordView: UIView {
    
    @IBOutlet var passField: UITextField!
    weak var delegate: PasswordViewDelegate?
    var name:String! = ""
    
    @IBAction func passCheckButton(_ sender: UIButton) {
        name = passField.text
        delegate?.callback(name ?? "")
    }
    
    func instanceFromNin() -> PasswordView {
        return UINib(nibName: "PasswordView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! PasswordView
    }
    
}

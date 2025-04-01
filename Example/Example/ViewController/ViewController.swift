//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2025/4/1.
//

import UIKit
import WWKeyboardShadowView
import WWExpandableTextView

final class ViewController: UIViewController {
    
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var shadowViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandableTextView: WWExpandableTextView!
    @IBOutlet weak var keyboardShadowView: WWKeyboardShadowView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initExpandableTextViewSetting()
        initKeyboardViewSetting()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func inputAction(_ sender: UIButton) {
        inputLabel.text = expandableTextView.text
    }
}

extension ViewController: WWKeyboardShadowViewDelegate {
    
    func keyboardWillChange(view: WWKeyboardShadowView, information: WWKeyboardShadowView.KeyboardInfomation) -> Bool {
        return true
    }
    
    func keyboardDidChange(view: WWKeyboardShadowView) {
        print(view)
    }
}

private extension ViewController {
    
    func initExpandableTextViewSetting() {
        expandableTextView.configure(lines: 3, gap: 21)
        expandableTextView.setting(font: .systemFont(ofSize: 20), backgroundColor: .white, borderWidth: 2, borderColor: .systemPink)
    }
    
    func initKeyboardViewSetting() {
        shadowViewHeightConstraint.constant = 0
        keyboardShadowView.configure(target: self, keyboardConstraintHeight: shadowViewHeightConstraint)
        keyboardShadowView.register()
    }
}

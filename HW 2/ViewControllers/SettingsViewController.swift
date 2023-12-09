//
//  ViewController.swift
//  HW 2
//
//  Created by Alexey Efimov on 12.06.2018.
//  Copyright © 2018 Alexey Efimov. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    @IBOutlet var colorView: UIView!

    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redValueTF: UITextField!
    @IBOutlet var greenValueTF: UITextField!
    @IBOutlet var blueValueTF: UITextField!
    
    var viewBackgroundColor: UIColor!
    
    weak var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 15
        
        updateColor()
        
        redLabel.text = string(from: redSlider)
        greenLabel.text = string(from: greenSlider)
        blueLabel.text = string(from: blueSlider)
        
        redValueTF.delegate = self
        greenValueTF.delegate = self
        blueValueTF.delegate = self
        
        redValueTF.text = string(from: redSlider)
        greenValueTF.text = string(from: greenSlider)
        blueValueTF.text = string(from: blueSlider)
        
        setupToolbar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        setColor()
        
        switch sender {
        case redSlider:
            redLabel.text = string(from: redSlider)
            redValueTF.text = string(from: redSlider)
        case greenSlider:
            greenLabel.text = string(from: greenSlider)
            greenValueTF.text = string(from: greenSlider)
        default:
            blueLabel.text = string(from: blueSlider)
            blueValueTF.text = string(from: blueSlider)
        }
    }
    
    @IBAction func doneButtonAction() {
        delegate?.updateBackgroundColor(colorView.backgroundColor ?? UIColor.black)
        dismiss(animated: true)
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    private func updateColor() {
        colorView.backgroundColor = viewBackgroundColor
        redSlider.value = Float(viewBackgroundColor.cgColor.components?[0] ?? 0)
        greenSlider.value = Float(viewBackgroundColor.cgColor.components?[1] ?? 0)
        blueSlider.value = Float(viewBackgroundColor.cgColor.components?[2] ?? 0)
    }
    
    private func setColor() {
        colorView.backgroundColor = UIColor(
            red: redSlider.value.cgFloat(),
            green: greenSlider.value.cgFloat(),
            blue: blueSlider.value.cgFloat(),
            alpha: 1
        )
    }
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    private func setupToolbar() {
        let toolbar = UIToolbar(
            frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44)
        )
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil
        )
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        toolbar.items = [flexibleSpace, doneButton]
        toolbar.sizeToFit()
        redValueTF.inputAccessoryView = toolbar
        greenValueTF.inputAccessoryView = toolbar
        blueValueTF.inputAccessoryView = toolbar
    }
}

extension Float {
    func cgFloat() -> CGFloat {
        CGFloat(self)
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case redValueTF:
            guard let inputText = checkInputText(redValueTF) else {
                return
            }
            redSlider.setValue(inputText, animated: true)
            redLabel.text = string(from: redSlider)
            setColor()
        case greenValueTF:
            guard let inputText = checkInputText(greenValueTF) else {
                return
            }
            greenSlider.setValue(inputText, animated: true)
            greenLabel.text = string(from: greenSlider)
            setColor()
        default:
            guard let inputText = checkInputText(blueValueTF) else {
                return
            }
            blueSlider.setValue(inputText, animated: true)
            blueLabel.text = string(from: blueSlider)
            setColor()
        }
    }
    
    private func checkInputText(_ textField: UITextField) -> Float? {
        guard let inputText = textField.text, !inputText.isEmpty else {
            showAlert()
            return nil
        }
        guard let text = textField.text, let inputText = Float(text), inputText <= 1 else {
            showAlert()
            return nil
        }
        return inputText
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Wrong format!",
            message: "Please enter correct value",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated:  true)
    }
}

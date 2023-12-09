//
//  ColorViewController.swift
//  HW 2
//
//  Created by Варвара Уткина on 09.12.2023.
//  Copyright © 2023 Alexey Efimov. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func updateBackgroundColor(_ color: UIColor)
}

final class ColorViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settingsVC = segue.destination as? SettingsViewController
        settingsVC?.viewBackgroundColor = view.backgroundColor
        settingsVC?.delegate = self
    }

}

// - MARK: SettingsViewControllerDelegate
extension ColorViewController: SettingsViewControllerDelegate {
    func updateBackgroundColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}

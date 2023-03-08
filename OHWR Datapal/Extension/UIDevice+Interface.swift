//
//  UIDevice+Interface.swift
//  OHWR Datapal
//
//  Created by David Bielik on 08/03/2023.
//

import UIKit

extension UIDevice {
    /// Returns `True` if the device is an iPad
    public static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

//
//  UIView+Extensions.swift
//  EnlargeZoomRotateCropImage
//
//  Created by Vladislav Movileanu on 02.07.2023.
//

import UIKit

extension UIView
{
    func getParentViewController() -> UIViewController?
    {
        if let parentViewController = self.next as? UIViewController
        {
            return parentViewController
        }
        else if let responder = self.next as? UIView
        {
            return responder.getParentViewController()
        }
        else
        {
            return nil
        }
    }
}

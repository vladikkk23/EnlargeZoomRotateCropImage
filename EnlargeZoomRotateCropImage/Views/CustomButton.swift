//
//  CustomButton.swift
//  EnlargeZoomRotateCropImage
//
//  Created by Vladislav Movileanu on 02.07.2023.
//

import UIKit

class CustomButton: UIButton
{
    let delayPoint: CGFloat = 1
    var startPoint: CGPoint?
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.startPoint = touches.first?.previousLocation(in: self)
        
        if self.shouldAllowForSendActionForPoint(location: (touches.first?.location(in: self))!)
        {
            if let parentVC = getParentViewController() as? ViewController
            {
                parentVC.containerView.touchesMoved(touches, with: event)
            }
            else
            {
                super.touchesMoved(touches, with: event)
            }
        }
    }
    
    func shouldAllowForSendActionForPoint(location: CGPoint) -> Bool
    {
        
        if self.startPoint != nil
        {
            
            let xDiff = (self.startPoint?.x)! - location.x
            let yDiff = (self.startPoint?.y)! - location.y
            
            if (xDiff > delayPoint || xDiff < -delayPoint || yDiff > delayPoint || yDiff < -delayPoint)
            {
                
                return true
            }
        }
        return false
    }
}

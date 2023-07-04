//
//  DraggableImageView.swift
//  EnlargeZoomRotateCropImage
//
//  Created by Vladislav Movileanu on 03.07.2023.
//

import UIKit

class DraggableImageView: UIImageView
{
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let position = touches.first?.location(in: superview)
        {
            center = position
        }
    }
}

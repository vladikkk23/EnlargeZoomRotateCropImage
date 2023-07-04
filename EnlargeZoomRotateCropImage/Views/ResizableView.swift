//
//  ResizableView.swift
//  EnlargeZoomRotateCropImage
//
//  Created by Vladislav Movileanu on 02.07.2023.
//

import UIKit

class ResizableView: UIView
{
    enum Edge
    {
        case topLeft, topRight, bottomLeft, bottomRight, none
    }
    
    static var edgeSize: CGFloat = 44.0
    private typealias `Self` = ResizableView
    
    var currentEdge: Edge = .none
    var touchStart = CGPoint.zero
    var identity = CGAffineTransform.identity
    
    private var buttons: [CustomButton] = []
    weak var imageView: UIImageView!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setupImageViewLayout()
        addButtons()
        setupGestures()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch = touches.first
        {
            touchStart = touch.location(in: self)
            
            currentEdge = {
                if self.bounds.size.width - touchStart.x < Self.edgeSize && self.bounds.size.height - touchStart.y < Self.edgeSize
                {
                    return .bottomRight
                }
                else if touchStart.x < Self.edgeSize && touchStart.y < Self.edgeSize
                {
                    return .topLeft
                }
                else if self.bounds.size.width-touchStart.x < Self.edgeSize && touchStart.y < Self.edgeSize
                {
                    return .topRight
                }
                else if touchStart.x < Self.edgeSize && self.bounds.size.height - touchStart.y < Self.edgeSize
                {
                    return .bottomLeft
                }
                
                return .none
            }()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch = touches.first
        {
            let currentPoint = touch.location(in: self)
            let previous = touch.previousLocation(in: self)
            
            let originX = self.frame.origin.x
            let originY = self.frame.origin.y
            let width = self.frame.size.width
            let height = self.frame.size.height
            
            let deltaWidth = currentPoint.x - previous.x
            let deltaHeight = currentPoint.y - previous.y
            
            switch currentEdge
            {
            case .topLeft:
                self.frame = CGRect(x: originX + deltaWidth, y: originY + deltaHeight, width: width - deltaWidth, height: height - deltaHeight)
                
                //                self.imageView.transform = .
            case .topRight:
                self.frame = CGRect(x: originX, y: originY + deltaHeight, width: width + deltaWidth, height: height - deltaHeight)
            case .bottomRight:
                self.frame = CGRect(x: originX, y: originY, width: width + deltaWidth, height: height + deltaWidth)
            case .bottomLeft:
                self.frame = CGRect(x: originX + deltaWidth, y: originY, width: width - deltaWidth, height: height + deltaHeight)
            default:
                // Moving
                self.center = CGPoint(x: self.center.x + currentPoint.x - touchStart.x,
                                      y: self.center.y + currentPoint.y - touchStart.y)
            }
            
            adjustButtonsPosition()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        currentEdge = .none
    }
    
    private func addButtons()
    {
        for index in 0...3
        {
            let button = CustomButton(configuration: .plain())
            button.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            button.tag = index
            button.tintColor = .lightGray

            if index == 0 // Resize button
            {
                button.addTarget(self, action: #selector(resizeAction), for: .allTouchEvents)
                button.frame = .init(x: bounds.minX, y: bounds.minY, width: 24, height: 24)
            }
            else if index == 1 // Zoom button
            {
                button.addTarget(self, action: #selector(resizeAction), for: .allTouchEvents)
                button.frame = .init(x: bounds.maxX - 24.0, y: bounds.minY, width: 24, height: 24)
            }
            else if index == 2 // Rotate button
            {
                button.addTarget(self, action: #selector(resizeAction), for: .allTouchEvents)
                button.frame = .init(x: bounds.minX, y: bounds.maxY - 24.0, width: 24, height: 24)
            }
            else if index == 3 // Crop button
            {
                button.addTarget(self, action: #selector(resizeAction), for: .allTouchEvents)
                button.frame = .init(x: bounds.maxX - 24.0, y: bounds.maxY - 24.0, width: 24, height: 24)
            }
            
            addSubview(button)
            self.buttons.append(button)
        }
    }
    
    private func adjustButtonsPosition()
    {
        self.buttons[0].frame = .init(x: bounds.minX, y: bounds.minY, width: 24, height: 24)
        self.buttons[1].frame = .init(x: bounds.maxX - 24.0, y: bounds.minY, width: 24, height: 24)
        self.buttons[2].frame = .init(x: bounds.minX, y: bounds.maxY - 24.0, width: 24, height: 24)
        self.buttons[3].frame = .init(x: bounds.maxX - 24.0, y: bounds.maxY - 24.0, width: 24, height: 24)
    }
    
    private func setupGestures()
    {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scale))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotate))
        
        pinchGesture.delegate = self
        rotationGesture.delegate = self
        
        addGestureRecognizer(pinchGesture)
        addGestureRecognizer(rotationGesture)
    }
    
    private func setupImageViewLayout()
    {
        let imageView = UIImageView(
            frame: .init(
                x: bounds.minX + 12.0,
                y: bounds.minY + 12.0,
                width: bounds.width - 24.0,
                height: bounds.height - 24.0
            )
        )
        
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        addSubview(imageView)
        
        self.imageView = imageView
    }
    
    @objc private func resizeAction()
    {
        currentEdge = .topLeft
    }
    
    @objc private func zoomAction()
    {
        currentEdge = .topRight
    }
    
    @objc private func rotateAction()
    {
        currentEdge = .bottomLeft
    }
    
    @objc private func cropAction()
    {
        currentEdge = .bottomRight
    }
}

// MARK: - UIGestureRecognizerDelegate
typealias ResizableViewGestureRecognizerDelegate = ResizableView
extension ResizableViewGestureRecognizerDelegate: UIGestureRecognizerDelegate
{
    @objc func scale(_ gesture: UIPinchGestureRecognizer)
    {
        switch gesture.state {
        case .began:
            identity = imageView.transform
        case .changed,.ended:
            imageView.transform = identity.scaledBy(x: gesture.scale, y: gesture.scale)
        case .cancelled:
            break
        default:
            break
        }
    }
    
    @objc func rotate(_ gesture: UIRotationGestureRecognizer)
    {
        imageView.transform = imageView.transform.rotated(by: gesture.rotation)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//
//  ViewController.swift
//  EnlargeZoomRotateCropImage
//
//  Created by Vladislav Movileanu on 02.07.2023.
//

import UIKit

class ViewController: UIViewController
{
    // MARK: - Properties
    private lazy var addImageButton: UIButton =
    {
        let button = UIButton(configuration: .filled())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private weak var infoLabel: UILabel!
    weak var containerView: ResizableView!
    
    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayouts()
    }
}

// MARK: - View Controller Layouts
typealias ViewControllerLayouts = ViewController
extension ViewControllerLayouts
{
    private func setupLayouts()
    {
        setupAddImageButtonLayout()
        setupContainerViewLayout()
        setupInfoLabelLayout()
    }
    
    private func setupAddImageButtonLayout()
    {
        view.addSubview(addImageButton)
        
        NSLayoutConstraint.activate([
            addImageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addImageButton.widthAnchor.constraint(equalToConstant: 100),
            addImageButton.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupContainerViewLayout()
    {
        let containerView = ResizableView(frame: CGRect(x: view.center.x - 100, y: view.center.y - 100, width: 200, height: 200))
        containerView.tintColor = .white
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.borderWidth = 0.5
        containerView.backgroundColor = .clear
        containerView.clipsToBounds = true
        containerView.isHidden = true
        
        view.addSubview(containerView)
        
        self.containerView = containerView
    }
    
    private func setupInfoLabelLayout()
    {
        let label = UILabel(frame: .init(x: view.center.x - 100, y: view.center.y - 25, width: 200, height: 50))
        label.text = "Please select an image"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .gray
        label.textAlignment = .center
        
        view.addSubview(label)
        
        self.infoLabel = label
    }
}

// MARK: - View Controller Actions
typealias ViewControllerActions = ViewController
extension ViewControllerActions
{
    @objc private func addButtonTapped()
    {
        imagePicker.photoGalleryAsscessRequest()
    }
}

// MARK: - ImagePickerDelegate
extension ViewController: ImagePickerDelegate {
    
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage)
    {
        containerView.imageView.contentMode = .scaleAspectFill
        containerView.imageView.image = image
        infoLabel.isHidden = true
        containerView.isHidden = false
        imagePicker.dismiss()
    }
    
    func cancelButtonDidClick(on imageView: ImagePicker)
    {
        containerView.isHidden = true
        infoLabel.isHidden = false
        imagePicker.dismiss()
    }
    
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool, to sourceType: UIImagePickerController.SourceType)
    {
        guard grantedAccess else { return }
        imagePicker.present(parent: self, sourceType: sourceType)
    }
}

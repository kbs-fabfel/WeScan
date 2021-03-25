//
//  ReviewViewController.swift
//  WeScan
//
//  Created by Boris Emorine on 2/25/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit

/// The `ReviewViewController` offers an interface to review the image after it has been cropped and deskwed according to the passed in quadrilateral.
final class ReviewViewController: UIViewController {
    
    private var rotationAngle = Measurement<UnitAngle>(value: 0, unit: .degrees)
    private var enhancedImageIsAvailable = false
    private var isCurrentlyDisplayingEnhancedImage = false
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.image = results.croppedScan.image
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var enhanceButton: UIBarButtonItem = {
        let image = UIImage(systemName: "wand.and.rays.inverse", named: "enhance", in: Bundle(for: ScannerViewController.self), compatibleWith: nil)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(toggleEnhancedImage))
        button.tintColor = .white
        return button
    }()
    
    private lazy var rotateButton: UIBarButtonItem = {
        let image = UIImage(systemName: "rotate.right", named: "rotate", in: Bundle(for: ScannerViewController.self), compatibleWith: nil)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(rotateImage))
        button.tintColor = .white
        return button
    }()
    
    private lazy var doneButton: UIButton = {        
        let title = NSLocalizedString("wescan_review_button_done", tableName: nil, bundle: Bundle(for: EditScanViewController.self), comment: "The done footer button")
        
        let button = UIButton(type: .custom)
        
        button.backgroundColor = UIColor(red: 143/255, green: 212/255, blue: 246/255, alpha: 1)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(finishScan), for: .touchUpInside)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        
        toolbar.backgroundColor = UIColor(red: 59/255, green: 59/255, blue: 59/255, alpha: 1)
        toolbar.isTranslucent = false
        toolbar.barTintColor = UIColor(red: 59/255, green: 59/255, blue: 59/255, alpha: 1)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        return toolbar
    }()
    
    private let results: ImageScannerResults
    
    // MARK: - Life Cycle
    
    init(results: ImageScannerResults) {
        self.results = results
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        enhancedImageIsAvailable = results.enhancedScan != nil
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if #available(iOS 13.0, *) {
            self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        }
        
        setupViews()
        setupToolbar()
        if #available(iOS 11.0, *) {
            setupConstraints()
        } else {
            // Fallback on earlier versions
        }
        
        title = NSLocalizedString("wescan_review_title", tableName: nil, bundle: Bundle(for: ReviewViewController.self), comment: "The navigation bar title for the review view")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: Setups
    
    private func setupViews() {
        view.backgroundColor = UIColor(red: 143/255, green: 212/255, blue: 246/255, alpha: 1)
        
        view.addSubview(imageView)
        view.addSubview(toolbar)
        view.addSubview(doneButton)
    }
    
    private func setupToolbar() {
        guard enhancedImageIsAvailable else { return }
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [fixedSpace, enhanceButton, flexibleSpace, rotateButton, fixedSpace]
    }
    
    @available(iOS 11.0, *)
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let doneButtonConstraints = [
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 56),
            doneButton.widthAnchor.constraint(equalTo: view.widthAnchor),
        ]
        
        let toolbarConstraints = [
            toolbar.bottomAnchor.constraint(equalTo: doneButton.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 44)
        ]
        
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: toolbar.topAnchor)
        ]
        
        NSLayoutConstraint.activate(doneButtonConstraints + toolbarConstraints + imageViewConstraints)
    }
    
    // MARK: - Actions
    
    @objc private func reloadImage() {
        if enhancedImageIsAvailable, isCurrentlyDisplayingEnhancedImage {
            imageView.image = results.enhancedScan?.image.rotated(by: rotationAngle) ?? results.enhancedScan?.image
        } else {
            imageView.image = results.croppedScan.image.rotated(by: rotationAngle) ?? results.croppedScan.image
        }
    }
    
    @objc func toggleEnhancedImage() {
        guard enhancedImageIsAvailable else { return }
        
        isCurrentlyDisplayingEnhancedImage.toggle()
        reloadImage()
      
        if isCurrentlyDisplayingEnhancedImage {
            enhanceButton.tintColor = .yellow
        } else {
            enhanceButton.tintColor = .white
        }
    }
    
    @objc func rotateImage() {
        rotationAngle.value += 90
        
        if rotationAngle.value == 360 {
            rotationAngle.value = 0
        }
        
        reloadImage()
    }
    
    @objc private func finishScan() {
        guard let imageScannerController = navigationController as? ImageScannerController else { return }
        
        var newResults = results
        newResults.croppedScan.rotate(by: rotationAngle)
        newResults.enhancedScan?.rotate(by: rotationAngle)
        newResults.doesUserPreferEnhancedScan = isCurrentlyDisplayingEnhancedImage
        imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFinishScanningWithResults: newResults)
    }

}

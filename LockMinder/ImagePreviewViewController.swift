//
//  ImagePreviewViewController.swift
//  LockMinder
//
//  Created by Nealon Young on 8/9/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

import Foundation

class ImagePreviewViewController: UIViewController {
    var image: UIImage?
    
    private var imageView: UIImageView!
    private var cancelButton: UIButton!
    private var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: image)
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(imageView)
        
        self.cancelButton = UIButton()
        self.cancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.cancelButton.backgroundColor = UIColor(white: 0.97, alpha: 0.65)
        self.cancelButton.titleLabel?.font = UIFont.mediumApplicationFont(19.0)
        self.cancelButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.cancelButton.setTitle("Cancel", forState: .Normal)
        self.cancelButton.addTarget(self, action: "cancelButtonPressed", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.cancelButton)
        
        self.saveButton = UIButton()
        self.saveButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.saveButton.backgroundColor = UIColor(white: 0.97, alpha: 0.65)
        self.saveButton.titleLabel?.font = UIFont.mediumApplicationFont(19.0)
        self.saveButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.saveButton.setTitle("Save", forState: .Normal)
        self.view.addSubview(self.saveButton)
        
        self.imageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        
        self.cancelButton.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(saveButton.snp_width)
            make.height.equalTo(saveButton.snp_height)
            
            make.height.equalTo(48.0)
            
            make.leading.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        self.saveButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.view)
            make.leading.equalTo(self.cancelButton.snp_trailing)
            make.trailing.equalTo(self.view)
        }
    }
    
    @objc private func cancelButtonPressed() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

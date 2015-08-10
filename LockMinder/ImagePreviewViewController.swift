//
//  ImagePreviewViewController.swift
//  LockMinder
//
//  Created by Nealon Young on 8/9/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

import AssetsLibrary
import NYAlertViewController

class ImagePreviewViewController: UIViewController {
    var image: UIImage?
    
    private var imageView: UIImageView!
    private var cancelButton: UIButton!
    private var saveButton: UIButton!
    
    let savedPhotosAlbumName = "LockMinder Wallpapers"
    
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
        self.saveButton.addTarget(self, action: "saveButtonPressed", forControlEvents: .TouchUpInside)
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
    
    @objc private func saveButtonPressed() {
        let assetsLibrary = ALAssetsLibrary()
        let orientation : ALAssetOrientation = ALAssetOrientation(rawValue: UIImage().imageOrientation.rawValue)!

        if let image = self.image {
            assetsLibrary.writeImageToSavedPhotosAlbum(
                image.CGImage,
                orientation: ALAssetOrientation(rawValue: image.imageOrientation.rawValue)!,
                completionBlock: { (url: NSURL!, error: NSError!) -> Void in
                    assetsLibrary.assetForURL(
                        url,
                        resultBlock: { (asset: ALAsset!) -> Void in
                            var albumCreated = false
                            
                            assetsLibrary.enumerateGroupsWithTypes(
                                ALAssetsGroupAlbum,
                                usingBlock: { (assetsGroup: ALAssetsGroup!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                                    // On the last iteration (when group is nil), we check if the album has been created
                                    if (assetsGroup == nil && !albumCreated) {
                                        assetsLibrary.addAssetsGroupAlbumWithName(
                                            self.savedPhotosAlbumName,
                                            resultBlock: { (assetsGroup: ALAssetsGroup!) -> Void in
                                                self.imageFinishedSaving(nil)
                                            },
                                            failureBlock: { (error: NSError!) -> Void in
                                                self.imageFinishedSaving(error)
                                            }
                                        )
                                        
                                        return
                                    } else {
                                        if let assetsGroup = assetsGroup {
                                            let albumName = assetsGroup.valueForProperty(ALAssetsGroupPropertyName) as? String
                                            if (albumName != nil)  {
                                                if (albumName == self.savedPhotosAlbumName) {
                                                    assetsGroup.addAsset(asset)
                                                    stop.memory = true
                                                    self.imageFinishedSaving(nil)
                                                }
                                            }
                                        }
                                    }
                                },
                                failureBlock: { (error: NSError!) -> Void in
                                    
                                }
                            )
                        },
                        failureBlock: { (error: NSError!) -> Void in
                            
                        }
                    )
                }
            )
        }
    }
    
    private func imageFinishedSaving(error: NSError!) {
        if (error != nil) {
            
        } else {
            if let presentingViewController = self.presentingViewController {
                presentingViewController.dismissViewControllerAnimated(true, completion: nil)
                
                let alertViewController = NYAlertViewController()
                alertViewController.title = NSLocalizedString("Wallpaper Saved", comment: "")
                alertViewController.message = NSLocalizedString("Your wallpaper was saved to the 'LockMinder Wallpapers' album in the Photos app", comment: "")
                
                let cancelAlertAction = NYAlertAction(
                    title: NSLocalizedString("Wallpaper Saved", comment: ""),
                    style: .Cancel,
                    handler: { (action: NYAlertAction!) -> Void in
                        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
                    }
                )
                
                alertViewController.addAction(cancelAlertAction)
                
                presentingViewController.presentViewController(alertViewController, animated: true, completion: nil)
            }
        }
    }
}

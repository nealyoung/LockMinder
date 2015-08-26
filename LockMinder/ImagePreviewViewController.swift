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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        
        self.cancelButton = UIButton()
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.backgroundColor = UIColor(white: 0.97, alpha: 0.65)
        self.cancelButton.titleLabel?.font = UIFont.mediumApplicationFont(19.0)
        self.cancelButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.cancelButton.setTitle("Cancel", forState: .Normal)
        self.cancelButton.addTarget(self, action: "cancelButtonPressed", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.cancelButton)
        
        self.saveButton = UIButton()
        self.saveButton.translatesAutoresizingMaskIntoConstraints = false
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
                            assetsLibrary.enumerateGroupsWithTypes(
                                ALAssetsGroupAlbum,
                                usingBlock: { (assetsGroup: ALAssetsGroup!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                                    // If we've gotten to the last iteration (when group is nil) we need to create the saved photos album
                                    if (assetsGroup == nil) {
                                        assetsLibrary.addAssetsGroupAlbumWithName(
                                            self.savedPhotosAlbumName,
                                            resultBlock: { (assetsGroup: ALAssetsGroup!) -> Void in
                                                assetsGroup?.addAsset(asset)
                                                self.imageFinishedSaving(nil)
                                            },
                                            failureBlock: { (error: NSError!) -> Void in
                                                self.imageFinishedSaving(error)
                                            }
                                        )
                                    } else {
                                        // Check if the album is the saved photos album by comparing their names
                                        let albumName = assetsGroup.valueForProperty(ALAssetsGroupPropertyName) as? String
                                        if (albumName == self.savedPhotosAlbumName) {
                                            assetsGroup.addAsset(asset)
                                            stop.memory = true
                                            self.imageFinishedSaving(nil)
                                        }
                                    }
                                },
                                failureBlock: { (error: NSError!) -> Void in
                                    self.imageFinishedSaving(error)
                                }
                            )
                        },
                        failureBlock: { (error: NSError!) -> Void in
                            self.imageFinishedSaving(error)
                        }
                    )
                }
            )
        }
    }
    
    private func imageFinishedSaving(error: NSError!) {
        if (error != nil) {
            let alertViewController = NYAlertViewController()
            alertViewController.title = NSLocalizedString("Error Saving Wallpaper", comment: "")
            alertViewController.message = NSLocalizedString("You need to allow LockMinder to access your photos.", comment: "")
            alertViewController.titleFont = .mediumApplicationFont(18.0)
            alertViewController.messageFont = .applicationFont(17.0)
            alertViewController.cancelButtonTitleFont = .mediumApplicationFont(18.0)
            alertViewController.cancelButtonColor = .purpleApplicationColor()
            alertViewController.swipeDismissalGestureEnabled = true
            alertViewController.backgroundTapDismissalGestureEnabled = true

            let cancelAlertAction = NYAlertAction(
                title: NSLocalizedString("Ok", comment: ""),
                style: .Cancel,
                handler: { (action: NYAlertAction!) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            )
            
            alertViewController.addAction(cancelAlertAction)
            
            self.presentViewController(alertViewController, animated: true, completion: nil)
        } else {
            if let presentingViewController = self.presentingViewController {
                presentingViewController.dismissViewControllerAnimated(true, completion: { () -> Void in
                    let alertViewController = NYAlertViewController()
                    alertViewController.title = NSLocalizedString("Wallpaper Saved", comment: "")
                    alertViewController.message = NSLocalizedString("Your wallpaper was saved to the 'LockMinder Wallpapers' album in the Photos app", comment: "")
                    alertViewController.titleFont = .mediumApplicationFont(18.0)
                    alertViewController.messageFont = .applicationFont(17.0)
                    alertViewController.cancelButtonTitleFont = .mediumApplicationFont(18.0)
                    alertViewController.cancelButtonColor = .purpleApplicationColor()
                    alertViewController.swipeDismissalGestureEnabled = true
                    alertViewController.backgroundTapDismissalGestureEnabled = true
                    
                    let cancelAlertAction = NYAlertAction(
                        title: NSLocalizedString("Ok", comment: ""),
                        style: .Cancel,
                        handler: { (action: NYAlertAction!) -> Void in
                            presentingViewController.dismissViewControllerAnimated(true, completion: nil)
                        }
                    )
                    
                    alertViewController.addAction(cancelAlertAction)
                    
                    presentingViewController.presentViewController(alertViewController, animated: true, completion: nil)
                })
            }
        }
    }
}

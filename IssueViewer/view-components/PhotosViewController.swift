//
//  PhotosViewController.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 24/08/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

//
//  PhotoViewer.swift
//  Aozora
//
//  Created by Paul Chavarria Podoliako on 4/28/16.
//  Copyright © 2016 AnyTap. All rights reserved.
//

import Foundation
import NYTPhotoViewer
import PINRemoteImage


open class ImageData: NSObject, NYTPhoto {
    
    open var url: String?
    open var width: Int
    open var height: Int
    
    open var image: UIImage?
    open var imageData: Data?
    open var placeholderImage: UIImage?
    open var attributedCaptionTitle: NSAttributedString?
    open var attributedCaptionSummary: NSAttributedString?
    open var attributedCaptionCredit: NSAttributedString?
    
    init(url: String) {
        self.url = url
        self.width = 0
        self.height = 0
    }
    
    init(url: String, width: Int, height: Int) {
        self.url = url
        self.width = width
        self.height = height
    }
    
    init(image: UIImage){
        self.image = image
        self.width = 0
        self.height = 0
        self.url = nil
    }
    
    class func imageDataWithDictionary(_ dictionary: [String: AnyObject]) -> ImageData {
        return ImageData(
            url: dictionary["url"] as! String,
            width: dictionary["width"] as! Int,
            height: dictionary["height"] as! Int)
    }
    
    open func toDictionary() -> [String: AnyObject] {
        return ["url": url as AnyObject, "width": width as AnyObject, "height": height as AnyObject]
    }
}

class PhotosViewController: NYTPhotosViewController {
    
    var enablePreviewActionItems = false
    
    var resolveActionsWhenPreview:(()->[UIPreviewActionItem])?
    
    var image: ImageData!
    
    override internal var previewActionItems: [UIPreviewActionItem] {
        if enablePreviewActionItems == false || resolveActionsWhenPreview == nil{
            return []
        }
        return self.resolveActionsWhenPreview!()
    }
    
    

    convenience init(imageURL: URL) {
        
        let photo  = ImageData(url: imageURL.absoluteString)
        self.init()
        self.dataSource = self
        self.delegate = self
        image = photo

        updateImageForPhoto(image, photosViewController: self)
    }
    

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
}
extension PhotosViewController: NYTPhotoViewerDataSource {
    
    var numberOfPhotos: NSNumber? {
        return 1
    }
    
    func index(of photo: NYTPhoto) -> Int {
        return 0
    }
    
    func photo(at photoIndex: Int) -> NYTPhoto? {
        return image
    }
    
    
}

extension PhotosViewController: NYTPhotosViewControllerDelegate {
    func photosViewController(_ photosViewController: NYTPhotosViewController, didNavigateTo photo: NYTPhoto, at photoIndex: UInt) {
        updateImageForPhoto(photo, photosViewController: photosViewController)
    }
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, handleActionButtonTappedFor photo: NYTPhoto) -> Bool {
        
        var objectsToShare: [AnyObject] = []
        
        if let image = photo.image {
            objectsToShare = [image]
        } else if let gif = photo.imageData {
            objectsToShare = [gif as AnyObject]
        }
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.barButtonItem = rightBarButtonItem
        activityVC.excludedActivityTypes = [UIActivityType.assignToContact, UIActivityType.addToReadingList]
        present(activityVC, animated: true, completion: nil)
        
        return true
    }
    
    func updateImageForPhoto(_ photo: NYTPhoto, photosViewController: NYTPhotosViewController) {
        guard let imageItem = photo as? ImageData , let url =  imageItem.url else {return}
        
        if let url = Foundation.URL(string: url) {
            
            PINRemoteImageManager.shared().downloadImage(with: url, options: [], completion: { result in
                if let image = result.image {
                    imageItem.image = image
                }
                //                if let image = result.animatedImage {
                //                    imageItem.imageData = image.data
                //                }
                OperationQueue.main.addOperation({
                    photosViewController.update(photo)
                })
            })
        }else{
            OperationQueue.main.addOperation({
                photosViewController.update(photo)
            })
        }
    }
}


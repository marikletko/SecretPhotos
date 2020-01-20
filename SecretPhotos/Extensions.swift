//
//  Extensions.swift
//  Photos
//
//  Created by Kirill Letko on 12/23/19.
//  Copyright © 2019 Letko. All rights reserved.
//

import Foundation
import UIKit

extension ImagesCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            
            let dataImage = pickedImage.jpegData(compressionQuality: 1)
            
            let image = Photos(context: PersistenceServce.context)
            image.photos = dataImage
            PersistenceServce.saveContext()
            photos.append(image)
             
            let obj = ImageProperties()
     
            obj.loves = false
            obj.text = nil
            obj.textPos = CGPoint(x:200,y:200)
            
            imageProperties.append(obj)
            UserDefaults.standard.set(encodable: self.imageProperties, forKey: "ImageProperties")

            self.imagePicker.dismiss(animated: true) {
            self.collectionView.reloadData() // опять? зачем?
            }
        }
    }
    
}


extension ImagePreviewFullViewCell: ImageViewZoomDelegate {
    func imageScrollViewDidChangeOrientation(imageViewZoom: ImageZoomView) {
        print("Did change orientation")
        // scrollImage.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        //
    }
    
   func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming at scale \(scale)")
 //   scrollImage.frame = CGRect(x: 0, y: 50, width: viewWidth, height: viewHeight - 150)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll at offset \(scrollView.contentOffset)")
    }
    
   func scrollViewDidZoom(_ scrollView: UIScrollView) {
    print("lala")
  //  scrollImage.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
//    scrollImage.frame.origin.y = 0
//    scrollImage.frame.size.height = viewHeight
    }
}


extension UserDefaults {
    
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}


extension UIScrollView {
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: true)
    }
}

class PhotoItemCell: UICollectionViewCell {
    
    @IBOutlet var img: UIImageView!
    
}



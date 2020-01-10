import Foundation
import UIKit

class ImagePreviewFullViewCell: UICollectionViewCell {

//   var imgView: UIImageView!
var imageArr:[BaseElement] = UserDefaults.standard.value([BaseElement].self, forKey: "photos") ?? []
var scrollImage:ImageZoomView!
var lovesView:UIButton!
var deleteImageView:UIButton!
var signView:UIButton! //
var signViewTextField:UITextField!
var bottomView:UIView!

override init(frame: CGRect) {
    super.init(frame: frame)
    scrollImage = ImageZoomView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
    scrollImage.setup()
    scrollImage.imageScrollViewDelegate = self
    scrollImage.imageContentMode = .aspectFit
    scrollImage.initialOffset = .center
  
    bottomView = UIView(frame: CGRect(x: 0, y: viewHeight - 50, width: viewWidth, height: 50))
    bottomView.backgroundColor = .white
    bottomView.isHidden = false
    
    lovesView = UIButton(frame: CGRect(x: viewWidth/2 - 20, y: 0, width: 40, height: 40))
    lovesView.backgroundColor = .white
    
    deleteImageView = UIButton(frame: CGRect(x: 10, y: 0, width: 40, height: 40))
    deleteImageView.backgroundColor = .white
    
    signView = UIButton(frame: CGRect(x: 300, y: 0, width: 40, height: 40)) //
    signView.backgroundColor = .red //
    
    signViewTextField = UITextField(frame:CGRect(x: 100, y: 100, width: 200, height: 50))
    signViewTextField.backgroundColor = .green
    
    bottomView.addSubview(lovesView)
    bottomView.addSubview(deleteImageView)
    bottomView.addSubview(signView)
    
    self.addSubview(bottomView)
    self.addSubview(scrollImage)
    self.bringSubviewToFront(bottomView)
    
    
}


required init?(coder aDecoder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
 }

}

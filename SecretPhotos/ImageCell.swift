import Foundation
import UIKit


class ImagePreviewFullViewCell: UICollectionViewCell {

//   var imgView: UIImageView!
var scrollImage:ImageZoomView!
var lovesView:UIButton!
var deleteImageView:UIButton!
var signView:UIButton! //
var signViewTextField:CustomTextField!// (может здесь сделать кастомный тип?) и инитить его из imagepreviewVC
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
    
    signViewTextField = CustomTextField(frame: CGRect(x: 50, y: 200, width: 200, height: 50))
    signViewTextField.backgroundColor = .white
    signViewTextField.frameToInters = bottomView
    
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


protocol CustomTextFieldDelegate: AnyObject {
    func callback()
   }

class CustomTextField: UITextField {
    
   
  // в идеале чтобы создавался объект кастомного текст филда уже с текстом?
    var lastLocation = CGPoint(x:0,y:0)
    var frameToInters: UIView?
   
    weak var delegates: CustomTextFieldDelegate?
    override init(frame:CGRect) {
        super.init(frame: frame)
    
        let panRecognizer = UIPanGestureRecognizer(target: self, action:#selector(CustomTextField.findPan(_:)))
        self.gestureRecognizers = [panRecognizer]
       
       
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func findPan(_ panRecognizer:UIPanGestureRecognizer) {
        let translationOfView = panRecognizer.location(in: self.superview)
        self.center = translationOfView
        if(self.frame.intersects(frameToInters!.frame)) {
                                 self.removeFromSuperview()
            delegates?.callback()
                               }
        
        if panRecognizer.state == .ended {
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.bringSubviewToFront(self)
              lastLocation = self.center
              print(lastLocation)
        
    }
       
}



import UIKit

class ImagePreviewVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    var myCollectionView: UICollectionView!
    var passedContentOffset = IndexPath()
     var imageArr:[BaseElement] = UserDefaults.standard.value([BaseElement].self, forKey: "photos") ?? []
    var arrayofBottomViews:[UIView] = []
     var bottomHidden:Bool = false
    
    var addSignBool:Bool = false
    // я пока хз как без этогo
    
    
     var textFieldOrigin : CGPoint = CGPoint(x: 0, y: 0)
    
    
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .up {
              self.myCollectionView.reloadData() // надо прям тут?
            if (!bottomHidden) {
                bottomHidden = true
                
            } else {
                bottomHidden = false
            }
        }
            
        else if gesture.direction == .down {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:))) // СВАЙП ВВЕРХ ДЛЯ ТОГО ЧТОБЫ ВЫЙТИ ИЗ ФОТКИ
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)  // СВАЙП ВНИЗ ДЛЯ ЛАЙКОВ
        
        self.view.backgroundColor=UIColor.black
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing=0
        layout.minimumLineSpacing=0
        layout.scrollDirection = .horizontal
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(ImagePreviewFullViewCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.isPagingEnabled = true
        
        DispatchQueue.main.async {
            // ЖЕСТЬ
            self.myCollectionView.scrollToItem(at: self.passedContentOffset, at: .left, animated: true)
        }
        
        self.view.addSubview(myCollectionView)
        
        myCollectionView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImagePreviewFullViewCell
        
        cell.scrollImage.display(image: imageArr[indexPath.row].image!)
       
        if imageArr[indexPath.row].loves == true {
            cell.lovesView.setImage(UIImage(named: "heartTwo"), for: .normal)
        } else {
            cell.lovesView.setImage(UIImage(named: "heart"), for: .normal)
        }
        
        cell.lovesView.addTarget(self, action: #selector(loveButton), for: .touchUpInside)
        
        cell.deleteImageView.setImage(UIImage(named: "delete"), for: .normal)
        
         cell.deleteImageView.addTarget(self, action: #selector(deleteButton), for: .touchUpInside)
        
        cell.signView.addTarget(self, action: #selector(addSign), for: .touchUpInside)
        
        
        if(bottomHidden == true) {
            cell.bottomView.isHidden = true
            
        } else {
            cell.bottomView.isHidden = false
        }

        if(addSignBool == true && imageArr[indexPath.row].text?.0 == false) {
        let gesture = customTextField(target: self, action: #selector(moveFunc(pan:)))
        gesture.custom = cell.signViewTextField
        gesture.custom?.addGestureRecognizer(gesture)
        gesture.custom?.isUserInteractionEnabled = true
        cell.addSubview(gesture.custom!)
        addSignBool = false
        } else if(imageArr[indexPath.row].text?.0 == true){
            let gesture = customTextField(target: self, action: #selector(moveFunc(pan:)))
                   gesture.custom = cell.signViewTextField
                   gesture.custom?.addGestureRecognizer(gesture)
                   gesture.custom?.isUserInteractionEnabled = true
            gesture.custom?.text = imageArr[indexPath.row].text?.1
                   cell.addSubview(gesture.custom!)
                   addSignBool = false
        }
        return cell
    }
    
    @objc func moveFunc(pan: customTextField) {
        var loc = pan.location(in: self.view)
        pan.custom?.center = loc
               }
    
    
    
    // в чем отличие addSubview от insertSubview
    @objc func addSign(sender: UIButton!) {
        self.myCollectionView.reloadData()
         if (!addSignBool) {
                     addSignBool = true
                      
                  } else {
                     addSignBool = false
                  }
              }
    
    @objc func deleteButton(sender: UIButton!) {
         let position = self.myCollectionView.contentOffset.x / viewWidth // костыли
        let alert = UIAlertController(title: "Delete image", message: "Are u sure?", preferredStyle: .actionSheet)
                      let okAction = UIAlertAction(title: "YES", style: .default , handler: { action in
                        self.imageArr.remove(at: Int(position))
                        
                        queue.async{ //?
                        UserDefaults.standard.set(encodable: self.imageArr, forKey: "photos")
                                     }
                        
                        self.myCollectionView.reloadData()
                        
                      })
                      let noAction = UIAlertAction(title: "NO", style: .default, handler: { action in
                        //
                      })
                      alert.addAction(okAction)
                      alert.addAction(noAction)
                      self.present(alert,animated:true, completion: nil)
           }
    // currentIndex создать
    
    @objc func loveButton(sender: UIButton!) {
      
            let position = self.myCollectionView.contentOffset.x / viewWidth // костыли
        if sender.currentImage == UIImage(named:"heart") {
            sender.setImage(UIImage(named:"heartTwo"), for: .normal)
            self.imageArr[Int(position)].loves = true
        } else {
            sender.setImage(UIImage(named:"heart"), for: .normal)
            self.imageArr[Int(position)].loves = false
        }
        
        
        queue.async{
     UserDefaults.standard.set(encodable: self.imageArr, forKey: "photos")
                  }
    //СПРОСИТЬ СВЕРХУ
       }
    

    // КОСТЫЛЬ сверху
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        flowLayout.itemSize = myCollectionView.frame.size
        
        flowLayout.invalidateLayout()
        
        myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let offset = myCollectionView.contentOffset
        let width  = myCollectionView.bounds.size.width
        
        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        
        myCollectionView.setContentOffset(newOffset, animated: false)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.myCollectionView.reloadData()
            
            self.myCollectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
    }
    
    

// КОСТЫЛЬ СВЕРХУ
    
}
  
class customTextField: UIPanGestureRecognizer {
    var custom: UITextField?
   // var bottomView: UIView?
}

import UIKit
import CoreData



class ImagePreviewVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var myCollectionView: UICollectionView!
    var passedContentOffset = IndexPath()
    var stringSaved: String = ""
    var bottomHidden:Bool = false
    var imageProperties:[ImageProperties] = UserDefaults.standard.value([ImageProperties].self, forKey: "ImageProperties") ?? []
    var addSignBool:Bool = false
    // я пока хз как без этогo
    var photos = [Photos]()
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

    
        let fetchRequest: NSFetchRequest<Photos> = Photos.fetchRequest()
               
               do {
                   let image = try PersistenceServce.context.fetch(fetchRequest)
                   self.photos = image
               } catch {}
        
        
        
        
        
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
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        imageProperties = UserDefaults.standard.value([ImageProperties].self, forKey: "ImageProperties") ?? []
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImagePreviewFullViewCell
        cell.signViewTextField.delegates = self
        let dataImage = photos[indexPath.row].photos
        let image = UIImage(data: dataImage!)
        
        cell.scrollImage.display(image: image!)
       
        if imageProperties[indexPath.row].loves == true {
            cell.lovesView.setImage(UIImage(named: "heartTwo"), for: .normal)
        } else {
            cell.lovesView.setImage(UIImage(named: "heart"), for: .normal)
        }
        
        // здесь надо создать кнопку(взять из ImageCell) для сохранения текста и добавить ее таргет
        
        cell.lovesView.addTarget(self, action: #selector(loveButton), for: .touchUpInside)
        
        cell.deleteImageView.setImage(UIImage(named: "delete"), for: .normal)
        
         cell.deleteImageView.addTarget(self, action: #selector(deleteButton), for: .touchUpInside)
        
        cell.signView.addTarget(self, action: #selector(addSign), for: .touchUpInside)
        cell.signView.tag = indexPath.row
        
        if(bottomHidden == true) {
            cell.bottomView.isHidden = true
            
        } else {
            cell.bottomView.isHidden = false
        }
        
     //   cell.signViewTextField.delegate = self
        cell.signViewTextField.addTarget(self, action: #selector(fieldChanged(textfieldChange:)), for: .editingChanged)
        cell.signViewTextField.addTarget(self, action: #selector(fieldDidBeginEditing(textfieldBeginEditing:)), for: .editingDidBegin) // xeph9
     //   cell.signViewTextField.addTarget(self, action: #selector(fieldDidBeginEditing(textfieldBeginEditing:)), for: .editingDidBegin)
        cell.signViewTextField.tag = indexPath.row
     //  cell.signViewTextField.frame.origin = imageProperties[indexPath.row].textPos!
        if(imageProperties[indexPath.row].text != nil) {
        cell.signViewTextField.text = imageProperties[indexPath.row].text
        cell.self.addSubview(cell.signViewTextField)
        } else {
            cell.signViewTextField.removeFromSuperview()
        }
    
        return cell
    }
    
    
    @objc func fieldChanged(textfieldChange: UITextField){
        stringSaved = textfieldChange.text!
    }
    
    @objc func fieldDidBeginEditing(textfieldBeginEditing: UITextField) {
     //   textFieldOrigin = textfieldBeginEditing.frame.origin
        let button = UIButton()
        let indexPath = IndexPath(item: textfieldBeginEditing.tag, section: 0)
        button.frame = CGRect(x: 300, y: 600, width: 50, height: 50)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(saveText), for: .touchUpInside)
        myCollectionView.cellForItem(at: indexPath)?.addSubview(button)
    }
    
    
    
    @objc func saveText(sender:UIButton!) {
        
         let position = self.myCollectionView.contentOffset.x / viewWidth
        imageProperties[Int(position)].text = stringSaved
      //  imageProperties[Int(position)].textPos = textFieldOrigin
          UserDefaults.standard.set(encodable:self.imageProperties, forKey: "ImageProperties")
        sender.removeFromSuperview()
        myCollectionView.reloadData()
    }
    
    // в чем отличие addSubview от insertSubview
    @objc func addSign(sender: UIButton!) {
        self.imageProperties[sender.tag].text = ""
          UserDefaults.standard.set(encodable:self.imageProperties, forKey: "ImageProperties")
        myCollectionView.reloadData()
              }
    
    @objc func deleteButton(sender: UIButton!) {
         let position = self.myCollectionView.contentOffset.x / viewWidth // костыли
        let alert = UIAlertController(title: "Delete image", message: "Are u sure?", preferredStyle: .actionSheet)
                      let okAction = UIAlertAction(title: "YES", style: .default , handler: { action in
                        self.imageProperties.remove(at: Int(position))
                        
                        queue.async {
                        UserDefaults.standard.set(encodable: self.imageProperties, forKey: "ImageProperties")
                                     }
                  
                        let context = PersistenceServce.context
                        context.delete(self.photos[Int(position)])
                        PersistenceServce.saveContext()
                        self.photos.remove(at:Int(position))
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
            self.imageProperties[Int(position)].loves = true
        } else {
            sender.setImage(UIImage(named:"heart"), for: .normal)
            self.imageProperties[Int(position)].loves = false
        }
        
        
        queue.async{
     UserDefaults.standard.set(encodable: self.imageProperties, forKey: "ImageProperties")
                  }//СПРОСИТЬ СВЕРХУ
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
  
extension ImagePreviewVC:CustomTextFieldDelegate {
    func callback() {
   
       
 let position = self.myCollectionView.contentOffset.x / viewWidth
     imageProperties[Int(position)].text = nil
     UserDefaults.standard.set(encodable:self.imageProperties, forKey: "ImageProperties")
     myCollectionView.reloadData()
   }
}



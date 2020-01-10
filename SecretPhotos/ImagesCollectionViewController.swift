import UIKit

private let reuseIdentifier = "Cell"

class ImagesCollectionViewController: UICollectionViewController {
    
    
    let imagePicker = UIImagePickerController()
    var imageArr:[BaseElement] = UserDefaults.standard.value([BaseElement].self, forKey: "photos") ?? []
    
    
    @IBAction func lala(_ sender: UIButton) {
        let defaults = UserDefaults.standard
           let dictionary = defaults.dictionaryRepresentation()
           dictionary.keys.forEach
               {
                   key in defaults.removeObject(forKey: key)
           }
    }
    
    @IBAction func addPhotoButton(_ sender: UIButton) {
//   imageArr = UserDefaults.standard.value([BaseElement].self, forKey: "photos") ?? []
        pick()
    }
    
     override func viewWillAppear(_ animated: Bool) {
    
         
               
                 UserDefaults.standard.synchronize() //
                          self.imageArr = UserDefaults.standard.value([BaseElement].self, forKey: "photos") ?? [] // чтобы фотка удалилась из мэйн коллекшн вью приходится еще раз считывать значения, это норм?
         self.collectionView.reloadData()
           
       }
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           self.imagePicker.delegate = self
           
           self.collectionView!.register(PhotoItemCell.self, forCellWithReuseIdentifier: reuseIdentifier)
           
           self.collectionView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
           
       }
    
  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoItemCell
        cell.img.image = imageArr[indexPath.row].image!
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc=ImagePreviewVC()
        vc.imageArr = self.imageArr
        vc.passedContentOffset = indexPath
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        
        if DeviceInfo.Orientation.isPortrait {
            return CGSize(width: width/4 - 1, height: width/4 - 1)
        } else {
            return CGSize(width: width/6 - 1, height: width/6 - 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func pick() {
          self.imagePicker.sourceType = .photoLibrary
          self.present(self.imagePicker, animated: true, completion: nil)
      }
    
    
    struct DeviceInfo {
        struct Orientation {
            
            static var isLandscape: Bool {
                get {
                    return UIDevice.current.orientation.isValidInterfaceOrientation
                        ? UIDevice.current.orientation.isLandscape
                        : UIApplication.shared.statusBarOrientation.isLandscape
                }
            }
            
            static var isPortrait: Bool {
                get {
                    return UIDevice.current.orientation.isValidInterfaceOrientation
                        ? UIDevice.current.orientation.isPortrait
                        : UIApplication.shared.statusBarOrientation.isPortrait
                }
            }
        }
    }
    
    
}

